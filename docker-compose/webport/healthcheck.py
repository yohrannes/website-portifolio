import socket
import sys

def check_health():
    try:
        # Try to connect to the service on port 5000
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(5)
        s.connect(('localhost', 5000))
        s.close()
    except Exception as e:
        # If it fails, print the error and exit with code 1
        print(f"Healthcheck failed: {e}")
        sys.exit(1)

# If everything is OK, exit with code 0
check_health()
sys.exit(0)