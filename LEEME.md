# Mi IA Portátil

Una IA privada que vive entera en este disco USB. Funciona sin internet, no se paga y no instala nada en el PC donde la conectas.

## Uso diario

| Quiero... | Haz doble clic en |
|---|---|
| Usar la IA (web tipo ChatGPT) | `INICIAR-IA.bat` → se abre http://127.0.0.1:8090 |
| Apagarla antes de quitar el USB | `PARAR-IA.bat` |
| Chatear rápido en una ventana negra | `CHAT-TERMINAL.bat` |
| Usarla en un PC "raro" o si lo demás falla | `MODO-EMERGENCIA.bat` |
| Añadir otro modelo | `herramientas\DESCARGAR-MODELO.bat` (necesita internet) |

La primera vez que la abres en un PC nuevo tarda 1-3 minutos en arrancar. Luego va más rápido.

## Modelos instalados

| Modelo | Tamaño | Para qué |
|---|---|---|
| `qwen3.5:4b` | 4 GB | El de uso diario. Rápido, cabe entero en una gráfica de 6 GB |
| `qwen3.5:9b` | 7,6 GB | Más listo, pero más lento. Para tareas difíciles |
| `nomic-embed-text` | 0,3 GB | No se chatea con él: sirve para que la IA lea tus documentos |

Más modelos en https://ollama.com/library. En un PC con gráfica NVIDIA de 6 GB, lo ideal son modelos de menos de 6 GB.

## Cómo funciona por dentro

```
 Navegador  ──►  Open WebUI (interfaz)  ──►  Ollama (motor)  ──►  Modelo (.gguf en modelos\)
 :8090           interfaz\python             motor\ollama          usa la gráfica si hay NVIDIA
```

- **Modelo**: un archivo enorme con lo que la IA "sabe". Es el cerebro.
- **Ollama**: el programa que carga el modelo en la gráfica o la RAM y genera el texto.
- **Open WebUI**: la página web desde la que hablas con la IA. Guarda chats, documentos y ajustes.
- Todo se ejecuta en `127.0.0.1`, es decir, en tu propio PC. No sale nada a internet.

## Carpetas

```
motor\        Ollama (el motor)
modelos\      los cerebros descargados
interfaz\     Python portátil + Open WebUI
datos\        tus chats, documentos y ajustes  ← HAZ COPIA DE ESTO
portable\     KoboldCpp (modo emergencia, un solo .exe)
instaladores\ copias de los instaladores originales
herramientas\ scripts internos
```

## Requisitos del PC

- Windows 10/11 de 64 bits.
- Mínimo 8 GB de RAM (16 GB recomendado).
- Gráfica NVIDIA opcional. Sin ella funciona, pero más lento.

## Problemas típicos

- **No se abre el navegador**: espera 1-2 minutos y entra a mano en http://127.0.0.1:8090.
- **Va muy lento**: usa `qwen3.5:4b` en lugar del 9b, o el PC no tiene gráfica NVIDIA.
- **El PC bloquea los .bat**: botón derecho → Propiedades → "Desbloquear".
