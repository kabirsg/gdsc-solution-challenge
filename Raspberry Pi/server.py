import socket
import time
from signal import signal, SIGPIPE, SIG_DFL  
signal(SIGPIPE,SIG_DFL)


def connect():
	HOST = "0.0.0.0"
	PORT = 5000
	with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
		print("Create socket")
		s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
		s.bind((HOST,PORT))
		s.listen()
		conn, addr = s.accept()
		with conn:
			print(f"Connected by {addr}")
			data = conn.recv(1024)
			filename = data.decode("utf-8")
			print(data)
			print(type(data))
			print(data.decode("utf-8"))
			
			message = "Hello World"
			conn.send(message.encode("utf-8"))
			
			print('Done sending')
			conn.send(b'Thank you for connecting')
			conn.close()
			s.close()

connect()
