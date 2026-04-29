import socket

def main():
    HOST, PORT = "127.0.0.1", 5051
    
    user_input = input("Enter comma-separated numbers: ")
    
    try:
        # SOCK_DGRAM is the socket type for UDP
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
            # UDP is connectionless; we just send to the address
            sock.sendto(user_input.encode('utf-8'), (HOST, PORT))

            # Receive response (max 1024 bytes)
            received, _ = sock.recvfrom(1024)
            print(f"Server response: {received.decode('utf-8')}")
            
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
