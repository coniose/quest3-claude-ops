# Servidor estatico + POST /log (a pagina manda logs/erros pra ca, o PC le
# via SSH em ~/cubo/log.txt). Uso: python servidor.py  (porta 8080, so localhost)
import http.server, datetime, os

os.chdir(os.path.dirname(os.path.abspath(__file__)))

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        if self.path.startswith('/captura'):
            # corpo = JPEG binario; ?tipo=virtual|camera
            tipo = 'camera' if 'tipo=camera' in self.path else 'virtual'
            dados = self.rfile.read(int(self.headers.get('Content-Length', 0)))
            os.makedirs('capturas', exist_ok=True)
            nome = f"capturas/{datetime.datetime.now():%Y%m%d-%H%M%S}-{tipo}.jpg"
            with open(nome, 'wb') as f:
                f.write(dados)
            print(f"captura salva: {nome} ({len(dados)} bytes)", flush=True)
            self.send_response(204)
            self.end_headers()
            return
        if self.path != '/log':
            self.send_error(404)
            return
        corpo = self.rfile.read(int(self.headers.get('Content-Length', 0))).decode('utf-8', 'replace')
        linha = f"{datetime.datetime.now():%H:%M:%S} {corpo}"
        print(linha, flush=True)
        with open('log.txt', 'a', encoding='utf-8') as f:
            f.write(linha + '\n')
        self.send_response(204)
        self.end_headers()

    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

http.server.ThreadingHTTPServer(('127.0.0.1', 8080), Handler).serve_forever()
