import socket
import time
import threading

file_lock = threading.Lock() #Prevent race conditions for file access

class Cilent():
    def __init__(self, port) -> None:
        self.port = port
    def start_connection(self):
        self.s = socket.socket()
        self.host = "192.168.2.18"
        try:
            self.s.connect((self.host, self.port))
        except:
            print("Cannot connect to desired host")
            pass

    def close_connection(self):
        self.s.close()

    def change_mode(self, mode): 
        self.s.send(bytes(f"{mode}", encoding="utf-8"))
        with file_lock:
            with open('Flutter/lib/data_file.txt', 'r') as file:
                lines = file.readlines()
            lines[0] = f"{mode}" + "\n"
            with open('Flutter/lib/data_file.txt', 'w') as file:
                file.writelines(lines)
        self.s.close()
    
    def receive_analytics(self):
        while True:
            try:
                data = self.s.recv(1024)
            except:
                print("Socket not connected")
                break
            print('data=', (data))
            if not data:
                break
            data = data.decode("utf-8")
            with file_lock:
                with open('Flutter/lib/data_file.txt', 'r') as file:
                    lines = file.readlines()
                if (data == "Y"): #If correct classification
                    num = int(lines[1]) + 1
                    lines[1] = f"{str(num)}" + "\n"
                else:
                    num = int(lines[2]) + 1
                    lines[2] = f"{str(num)}" + "\n"
                with open('Flutter/lib/data_file.txt', 'w') as file:
                    file.writelines(lines)
    
def run_cilent_analytics():
    def run_cilent_loop():
        while True:
            cilent = Cilent(1235)
            cilent.start_connection()
            cilent.receive_analytics()
            cilent.close_connection()
            time.sleep(0.5)
            
    cilent_thread = threading.Thread(target=run_cilent_loop)
    cilent_thread.start()




