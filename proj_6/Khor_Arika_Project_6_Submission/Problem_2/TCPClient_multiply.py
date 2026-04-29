import socket

def main():
    HOST, PORT = "127.0.0.1", 5050
    
    # Get user input
    user_input = input("Enter comma-separated numbers: ")
    
    try:
        # Create a socket (SOCK_STREAM means a TCP socket)
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            # Connect to server and send data
            sock.connect((HOST, PORT))
            sock.sendall(user_input.encode('utf-8'))

            # Receive data from the server and shut down
            received = sock.recv(1024).decode('utf-8')
            print(f"Server response: {received}")
            
    except ConnectionRefusedError:
        print("Error: Could not connect to server. Is it running?")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
