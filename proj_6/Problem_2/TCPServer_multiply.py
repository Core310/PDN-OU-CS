import socketserver
import math

def calculate_product(data_str):
    """
    Parses comma-separated numbers and returns their product as a string.
    Returns 'Invalid input' if any token is non-numeric or if string is empty.
    """
    try:
        # Split by comma and strip whitespace
        tokens = [t.strip() for t in data_str.split(',') if t.strip()]
        if not tokens:
            return "Invalid input"
        
        # Convert to float and multiply
        numbers = [float(t) for t in tokens]
        product = math.prod(numbers)
        
        # Return as string, format as int if it has no decimal part for cleaner output
        if product == int(product):
            return str(int(product))
        return str(product)
    except (ValueError, TypeError):
        return "Invalid input"

class MultiplicationTCPHandler(socketserver.BaseRequestHandler):
    """
    Handler for TCP connections. Receives string, returns product.
    """
    def handle(self):
        # Receive data from client (max 1024 bytes)
        data = self.request.recv(1024).strip()
        if not data:
            return
        
        # Decode and calculate
        input_str = data.decode('utf-8')
        result = calculate_product(input_str)
        
        # Send response back
        self.request.sendall(result.encode('utf-8'))

class RobustTCPServer(socketserver.ThreadingTCPServer):
    # Allow immediate rebinding to the port after server restart
    allow_reuse_address = True

if __name__ == "__main__":
    HOST, PORT = "127.0.0.1", 5050
    print(f"TCP Multiplication Server starting on {HOST}:{PORT}...")
    
    with RobustTCPServer((HOST, PORT), MultiplicationTCPHandler) as server:
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("\nShutting down TCP Server.")
