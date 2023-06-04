import tkinter as tk
from PIL import Image, ImageTk
import threading
import cv2
from tmlib import *
import RPi.GPIO as GPIO
import numpy as np
import argparse
import time
import customtkinter as ctk
from queue import Queue
from updateFirebase import firebaseConnection


#Global variables
class_queue = Queue() #Current detection class
prev_class = None #Previous detection class
stop_thread = False
last_send_time = 0
sys_name = "EAYtmACasVXqC4f0qqCA" #System's name, defined in software
mode = "Plastic" #Mode for single bin
servo = 17 #Servo motor GPIO
p = None
TRIG_PIN = 23 #Ultrasonic sensor GPIO
ECHO_PIN = 24 #Ultrasonic sensor GPIOs
true_capacity = 0
num_waste_recycled = 0

#Algorithm for updating the previous class every two seconds
def update_prev_class():
    global prev_class
    global stop_thread
    while not stop_thread:
        if not class_queue.empty():
            prev_class = class_queue.get()
        time.sleep(2)  # Update every 2 seconds

#Algorithm for checking the object is correct/incorrect
def check_class():
  global stop_thread
  global last_send_time
  global mode
  global class_queue
  global prev_class
  global sys_name
  global true_capacity
  global num_waste_recycled
  
  class_count = 0
  
  while not stop_thread:
    if not class_queue.empty():
        current_class = class_queue.get()
        class_count += 1
    else:
        continue
    
    if (class_count >= 2 and mode == current_class and prev_class == current_class):
      set_angle(60)
      time.sleep(1)
      print(f"Same class '{current_class}' detected for 3 seconds.")
      class_count = 0
      current_time = time.time()
      if (current_time - last_send_time >= 4):
        print("Sending analytics data to the RecycleRight App")
        last_send_time = current_time
        firebase = firebaseConnection()
        firebase.update(sys_name, "bin1", true_capacity, num_waste_recycled)
        time.sleep(1)
    elif (class_count >= 2 and mode != current_class and mode != "None"):
      set_angle(120)
      time.sleep(1)
      class_count = 0
    time.sleep(1)
    
def check_distance():
    global true_capacity
    global num_waste_recycled
    while not stop_thread:
        distance = measure_distance(TRIG_PIN, ECHO_PIN)
        if distance is not None:
            capacity = round(((distance - 24) / (1 - 24)) * 100,2)
            if (abs(true_capacity - capacity) > 5):
                if (capacity - true_capacity) > 5:
                    num_waste_recycled += 1
                true_capacity = capacity
            print(capacity)
        else:
            print("Failed")
        time.sleep(2)

#Set angle of the servo motor to control opening/closing of the bin
def set_angle(angle):
    global p
    pulse_width = 500 + (angle * ((2500 - 500) / 270))
    duty = pulse_width / 20000 * 100
    GPIO.output(servo, True)
    p.ChangeDutyCycle(duty)
    time.sleep(1)
    GPIO.output(servo,False)
    p.ChangeDutyCycle(0)

#Measures distance of the ultrasounic sensor to bottom of bin
def measure_distance(TRIG_PIN, ECHO_PIN):
    GPIO.output(TRIG_PIN, True)
    time.sleep(0.00001)
    GPIO.output(TRIG_PIN, False)
    
    start_time = time.time()
    timeout = start_time + 0.02
    
    pulse_send = None
    pulse_received = None
    
    while GPIO.input(ECHO_PIN) == 0 and time.time() < timeout:
        pulse_send = time.time()
        
    if time.time() >= timeout:
        return None
        
    while GPIO.input(ECHO_PIN) == 1 and time.time() < timeout:
        pulse_received = time.time()
    
    if time.time() >= timeout:
        return None
    
    if pulse_received == None or pulse_send == None:
        return None
    else:
        pulse_duration = pulse_received - pulse_send
        pulse_duration = pulse_duration/2
        distance = 34000 * pulse_duration
        return distance

class Application(ctk.CTk):    
    def __init__(self, *args, **kwargs):
        ctk.CTk.__init__(self, *args, **kwargs)
        
        self.title("RecycleRight")
        self.attributes('-fullscreen', True)
        
        self.bind("<F11>", self.toggle_fullscreen)
        self.bind("<Escape>", self.end_fullscreen)
                        
        self.container = tk.Frame(self)
        self.container.pack(side="top", fill="both", expand=True)
        
        self.container.grid_rowconfigure(0, weight=1)
        self.container.grid_columnconfigure(0, weight=1)
        
        self.tm = TeachableMachineTf()
        self.tm.load('model_unquant.tflite', 'labels.txt')

        self.frames = {}

        for F in (CameraFrame, StatsFrame):
            frame = F(self.container, self, self.tm)
            self.frames[F] = frame
            frame.grid(row=0, column=0, sticky="nsew")

        self.show_frame(CameraFrame)

    def show_frame(self, cont):
        frame = self.frames[cont]
        frame.tkraise()
    
    def close_window(self, event):
        cap.release()
        p.stop()
        GPIO.cleanup()
        stop_thread = True
        timer_thread.join()
        ultra_timer_thread.join()
        self.window.destroy()
        
    def toggle_fullscreen(self, event=None):
        self.attributes('-fullscreen', not self.attributes('-fullscreen'))
        return "break"

    def end_fullscreen(self, event=None):
        self.attributes('-fullscreen', False)
        return "break"


class CameraFrame(ctk.CTkFrame):    
    def __init__(self, parent, controller, tm):
        global p
        global prev_class
        
        ctk.CTkFrame.__init__(self, parent)

        self.controller = controller
        self.tm = tm

        self.lmain = tk.Label(self)
        self.button = ctk.CTkButton(self, text="Switch to Stats View", command=self.on_switch)

        # Define grid layout
        self.lmain.grid(row=0, column=0, sticky="nsew")
        self.button.grid(row=1, column=0, sticky="nsew")

        self.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=99)  # Give more weight to the lmain label
        self.rowconfigure(1, weight=1)  # Lesser weight to the button

        #Initialize servo motor
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        GPIO.setup(servo, GPIO.OUT)

        p = GPIO.PWM(servo, 50)
        p.start(0)

        GPIO.setup(TRIG_PIN, GPIO.OUT)
        GPIO.setup(ECHO_PIN, GPIO.IN)
        GPIO.output(TRIG_PIN, False)
          
        time.sleep(0.5)

        self.cap = cv2.VideoCapture(0)
        
        # Thread that updates the previous class every three seconds
        prev_class_thread = threading.Thread(target=update_prev_class)
        prev_class_thread.start()
        
        # Thread that checks which class is being detected
        timer_thread = threading.Thread(target=check_class)
        timer_thread.start()
        
        # Thread that updates the capacity every two seconds
        ultra_timer_thread = threading.Thread(target=check_distance)
        ultra_timer_thread.start()

        self.show_frame()

    def show_frame(self):
        _, frame = self.cap.read()
        #flipped = cv2.flip(frame, 0)
        res, name = self.tm.predict(frame)
        #print("{}: {:.2f}%".format(name,np.max(res)*100))
        cv2.putText(frame, "{}: {:.2f}%".format(name,np.max(res)*100), (50,50), cv2.FONT_HERSHEY_SIMPLEX, 1, (50,50,50), 4)
        cv2image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGBA)
        img = Image.fromarray(cv2image)
        imgtk = ImageTk.PhotoImage(image=img)
        self.lmain.imgtk = imgtk
        self.lmain.configure(image=imgtk)
        self.lmain.after(10, self.show_frame)
        
        while not class_queue.empty():
            class_queue.get()
        class_queue.put(name)
                
    def on_switch(self):
        self.controller.show_frame(StatsFrame)

class StatsFrame(ctk.CTkFrame):
    def __init__(self, parent, controller, tm):
        global true_capacity
        global mode
        global num_waste_recycled
        ctk.CTkFrame.__init__(self, parent)
        self.controller = controller

        # Define the button first, so it will be packed at the bottom
        self.button = ctk.CTkButton(self, text="Switch to Camera View", command=self.on_switch)

        # Now, define the label and the bin_frame
        self.label = ctk.CTkLabel(self, text="StatsFrame", font=('Helvetica', 18, "bold"))

        # Creating three bins
        self.bin_frame = ctk.CTkFrame(self)

        # First bin
        bin_column1 = ctk.CTkFrame(self.bin_frame)
        bin_column1.grid(row=0, column=0, sticky="nsew", padx=10, pady=10)  # Use grid instead of pack
        bin_label1 = ctk.CTkLabel(bin_column1, text="Bin "+str(1), font=('Helvetica', 18, "bold"))
        bin_label1.pack(pady=5)
        self.capacity_label1 = ctk.CTkLabel(bin_column1, text="Capacity: "+str(true_capacity)+"%")
        self.capacity_label1.pack()
        waste_type_label1 = ctk.CTkLabel(bin_column1, text="Type of Waste: "+str(mode))
        waste_type_label1.pack()
        self.num_trash_label1 = ctk.CTkLabel(bin_column1, text="Number of Trash Recycled: "+str(num_waste_recycled))
        self.num_trash_label1.pack()
        bin_column1.grid_columnconfigure(0, weight=1)
        
        # Second bin
        bin_column2 = ctk.CTkFrame(self.bin_frame)
        bin_column2.grid(row=0, column=1, sticky="nsew", padx=10, pady=10)  # Use grid instead of pack
        bin_label2 = ctk.CTkLabel(bin_column2, text="Bin "+str(2), font=('Helvetica', 18, "bold"))
        bin_label2.pack(pady=5)
        capacity_label2 = ctk.CTkLabel(bin_column2, text="Capacity: N/A")
        capacity_label2.pack()
        waste_type_label2 = ctk.CTkLabel(bin_column2, text="Type of Waste: N/A")
        waste_type_label2.pack()
        num_trash_label2 = ctk.CTkLabel(bin_column2, text="Number of Trash Recycled: N/A")
        num_trash_label2.pack()
        bin_column2.grid_columnconfigure(1, weight=1)
        
        # Third bin
        bin_column3 = ctk.CTkFrame(self.bin_frame)
        bin_column3.grid(row=0, column=2, sticky="nsew", padx=10, pady=10)  # Use grid instead of pack
        bin_label3 = ctk.CTkLabel(bin_column3, text="Bin "+str(3), font=('Helvetica', 18, "bold"))
        bin_label3.pack(pady=5)
        capacity_label3 = ctk.CTkLabel(bin_column3, text="Capacity: N/A")
        capacity_label3.pack()
        waste_type_label3 = ctk.CTkLabel(bin_column3, text="Type of Waste: N/A")
        waste_type_label3.pack()
        num_trash_label3 = ctk.CTkLabel(bin_column3, text="Number of Trash Recycled: N/A")
        num_trash_label3.pack()
        bin_column3.grid_columnconfigure(2, weight=1)

        # Pack the button first (at the bottom)
        self.button.pack(side="bottom", fill="x")

        # Now pack the bin_frame and the label
        self.label.pack(pady=10, padx=10, fill="x")
        self.bin_frame.pack(fill="both", expand="True")

        # Configure the bin_frame to distribute its columns evenly
        self.bin_frame.grid_columnconfigure(0, weight=1)
        self.bin_frame.grid_columnconfigure(1, weight=1)
        self.bin_frame.grid_columnconfigure(2, weight=1)
        
        self.update_capacity()

    def on_switch(self):
        self.controller.show_frame(CameraFrame)
    
    def update_capacity(self):
        global true_capacity
        global num_waste_recycled
        self.capacity_label1.configure(text="Capacity: "+str(true_capacity)+"%")
        self.num_trash_label1.configure(text="Number of Trash Recycled: "+str(num_waste_recycled))
        self.after(1000, self.update_capacity)  # update every second

app = Application()
ctk.set_appearance_mode("dark")
app.mainloop()

