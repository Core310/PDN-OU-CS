import socketserver
import math

def calculate_product(data_str):
    """
    Parses comma-separated numbers and returns their product as a string.
    Returns 'Invalid input' if any token is non-numeric or if string is empty.
    """
    try:
        tokens = [t.strip() for t in data_str.split(',') if t.strip()]
        if not tokens:
            return "Invalid input"
        
        numbers = [float(t) for t in tokens]
        product = math.prod(numbers)
        
        if product == int(product):
            return str(int(product))
        return str(product)
    except (ValueError, TypeError):
        return "Invalid input"

class MultiplicationUDPHandler(socketserver.BaseRequestHandler):
    """
    Handler for UDP packets.
    """
    def handle(self):
        # self.request is a tuple of (data, socket)
        data = self.request[0].strip()
        socket = self.request[1]
        
        input_str = data.decode('utf-8')
        result = calculate_product(input_str)
        
        # Send response back to the client address
        socket.sendto(result.encode('utf-8'), self.client_address)

class RobustUDPServer(socketserver.ThreadingUDPServer):
    allow_reuse_address = True

if __name__ == "__main__":
    HOST, PORT = "127.0.0.1", 5051
    print(f"UDP Multiplication Server starting on {HOST}:{PORT}...")
    
    with RobustUDPServer((HOST, PORT), MultiplicationUDPHandler) as server:
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("\nShutting down UDP Server.")
