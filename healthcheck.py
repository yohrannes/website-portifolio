import socket
import sys

def check_health():
    try:
        # Tenta conectar ao serviço na porta 5000
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(5)
        s.connect(('localhost', 5000))
        s.close()
    except Exception as e:
        # Se falhar, imprime o erro e retorna código de saída 1
        print(f"Healthcheck failed: {e}")
        sys.exit(1)

# Se tudo estiver OK, retorna código de saída 0
check_health()
sys.exit(0)