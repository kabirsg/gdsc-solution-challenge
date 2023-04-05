import socket
import time
import threading
	
class Server():
    def __init__(self, port) -> None:
        self.PORT = port
        
    def start_connection(self):
        self.HOST = "0.0.0.0"
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as self.s:
            print("Create socket")
            self.s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.s.bind((self.HOST,self.PORT))
            self.s.listen()
            self.conn, self.addr = self.s.accept()
    
    def close_connection(self):
        self.conn.close()
        self.s.close()

    def send_analytics(self, data):
        with self.conn:
            # print(f"Connected by {addr}")
            # data = conn.recv(1024)
            # print(data)
            # print(type(data))
            # print(data.decode("utf-8"))
            
            self.conn.send(data.encode("utf-8"))
    
    def receive_mode(self):
        with self.conn:
            mode = self.conn.recv(1024)
            mode = mode.decode("utf-8")
            with open('Raspberry Pi/server_file.txt','r') as file:
                lines = file.readlines()
            lines[0] = f"{mode}" + "\n"
            with open('Raspberry Pi/server_file.txt','w') as file:
                file.writelines(lines)

print("Process end")