# Lanzador de Open WebUI que usa el Python portatil del disco
# (los .exe que crea pip guardan rutas absolutas y se rompen si cambia la letra del disco).
import sys
from open_webui import app

if __name__ == "__main__":
    sys.exit(app())
