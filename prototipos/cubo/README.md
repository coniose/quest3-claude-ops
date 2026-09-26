# Protótipo: cubo interativo em WebXR servido pelo Termux

Prova de viabilidade (2026-09-25) do ciclo "editar no PC → ver no Quest em
segundos", sem cabo, sem Link, sem build de APK.

- `index.html` — three.js (CDN) + WebXR `immersive-ar` (passthrough). Cubo de
  20 cm que gira; mira = laranja, segurando (gatilho/pinça) = verde. Anel
  magenta marca onde o cubo está. Manda logs pro servidor (`POST /log`).
- `servidor.py` — servidor estático em `127.0.0.1:8080` + grava logs da
  página em `log.txt`. **`localhost` é contexto seguro**, então WebXR
  funciona sem HTTPS/certificado.

## Rodar (a partir do PC)

```bash
ssh quest3 'mkdir -p ~/cubo && cat > ~/cubo/index.html' < prototipos/cubo/index.html
ssh quest3 'cat > ~/cubo/servidor.py' < prototipos/cubo/servidor.py
ssh quest3 'termux-wake-lock; tmux new-session -d -s cubo "python ~/cubo/servidor.py"'
ssh quest3 'am start -a android.intent.action.VIEW -d http://localhost:8080/ -n com.oculus.browser/.PanelActivity'
ssh quest3 'tail -f ~/cubo/log.txt'   # ver o que acontece dentro do navegador
```

## Aprendido

- Página carrega, three.js carrega, `immersive-ar` suportado, sessão AR
  inicia com `alpha-blend` (passthrough) — confirmado pelos logs.
- Sem o log remoto não há como ver erros de JS no Quest (sem adb/DevTools).
- Pendente: confirmar cubo visível e "pegável" dentro da sessão AR.
