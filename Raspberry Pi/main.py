from tmlib import *
#from server import *
from gpiozero import LED
import RPi.GPIO as GPIO
import cv2
import numpy as np
import argparse
import threading
import time

#Global variables
prev_class = None
class_count = 0
stop_thread = False
last_send_time = 0
mode = None

green = LED(16)
red = LED(20)
blue = LED(21)
servo = 17

#Algorithm for checking the object is correct/incorrect
def check_class():
  global prev_class
  global class_count
  global stop_thread
  global last_send_time
  
  while not stop_thread:
    current_class = prev_class
    green.off()
    red.off()
    blue.off()
    
    if (prev_class == current_class):
      class_count += 1
    else:
      class_count = 1
    
    if (class_count == 2 and mode == current_class):
      green.on()
      set_angle(200)
      time.sleep(1)
      print(f"Same class '{current_class}' detected for 3 seconds.")
      #server.connect()
      class_count = 0
      current_time = time.time()
      if (current_time - last_send_time >= 4):
        print("Sending analytics data to the RecycleRight App")
        last_send_time = current_time
        blue.on()
        time.sleep(1)
    elif (class_count == 2 and mode != current_class and mode != "None"):
      red.on()
      set_angle(100)
      time.sleep(1)
      class_count = 0
    prev_class = current_class
    time.sleep(1)

#Set angle of the servo motor to control opening/closing of the bin
def set_angle(angle):
    duty = angle / 18 + 2
    GPIO.output(servo, True)
    p.ChangeDutyCycle(duty)
    time.sleep(1)
    GPIO.output(servo,False)
    p.ChangeDutyCycle(0)

if __name__ == "__main__":
  #Retrieving mode from localstore
  mode_path = "mode.txt"
  with open(mode_path) as f:
      c = f.read().split('\n')
      mode = c[0]

  #Initialize model
  tm = TeachableMachineTf()
  tm.load('model_unquant.tflite', 'labels.txt')
  
  #Initialize servo motor
  GPIO.setmode(GPIO.BCM)
  GPIO.setwarnings(False)
  GPIO.setup(servo, GPIO.OUT)

  p = GPIO.PWM(servo, 50)
  p.start(0)
  
  #server = Server()

  cap = cv2.VideoCapture(0)
  
  
  timer_thread = threading.Thread(target=check_class)
  timer_thread.start()
    
  while True:
    _, img = cap.read()
    flipped = cv2.flip(img, 0)
    res, name = tm.predict(flipped)
    print("{}: {:.2f}%".format(name,np.max(res)*100))
    cv2.putText(flipped, "{}: {:.2f}%".format(name,np.max(res)*100), (50,50), cv2.FONT_HERSHEY_SIMPLEX, 1, (50,50,50), 4)
    cv2.imshow("RecycleRight", flipped)
    
    prev_class = name
    
    if cv2.waitKey(1) & 0xFF == ord('q'):
      cap.release()
      p.stop()
      GPIO.cleanup()
      stop_thread = True
      break
    
  timer_thread.join()
  cv2.destroyAllWindows()
