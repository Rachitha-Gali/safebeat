import socket
import add_to_db

print("wereg")

TCP_IP = '127.0.0.1'
TCP_PORT = 5013
BUFFER_SIZE = 1024  # Normally 1024, but we want fast response


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((TCP_IP, TCP_PORT))
s.listen(1)

print('connection recv')

conn, addr = s.accept()
print('Connection address:', addr)
while 1:
    data = conn.recv(BUFFER_SIZE)
    if not data: break
    if True:
        print('button pressed')
        add_to_db.new_record()
        data = ''
conn.close()
