# Plano — reduzir a barreira de conexão Quest ↔ PC (2026-09-25)

Conclusão do experimento 01: o 3D é a parte fácil. A barreira pra escalar
(ex: animador vendo o modelo do Blender no óculos) é **o setup da conexão**.
Problema de ovo e galinha: o Claude não consegue configurar o óculos antes
de existir conexão com ele — o primeiro passo sempre é humano. Objetivo:
encolher esse passo ao mínimo.

## Caminho A — animador, zero instalação no Quest (recomendado)

No experimento 01, cubo, recarga, log e captura funcionaram **pela página**,
não pelo SSH. SSH/Termux só serviram pro Claude controlar o Quest — o
animador não precisa disso.

```
PC do animador                                   Quest (nada instalado)
 instalador único ──► servidor + túnel HTTPS ──► Quest Browser abre link/QR
 vigia a pasta de export do Blender              modelo aparece e recarrega
 recebe logs e capturas                          captura, oclusão, mãos
```

- PC: um comando/instalador sobe servidor + túnel HTTPS (ex: Cloudflare
  quick tunnel — URL `https://` sem conta). Resolve a exigência de contexto
  seguro do WebXR sem Termux e sem certificado.
- Quest: abrir o link uma vez, salvar nos favoritos. Sem modo
  desenvolvedor, sideload, SSH ou IP.
- Claude roda no PC do animador, lê logs/capturas direto, otimiza modelos.
- Custo: o modelo trafega pela internet. Pra sigilo de estúdio, trocar
  depois por HTTPS na rede local.

## Caminho B — desenvolvedor, Claude controlando o Quest (o atual, simplificado)

1. Sideload do Termux (modo desenvolvedor) — inevitável, é da Meta.
2. No Termux, uma linha: `curl -fsSL <url>/setup.sh | bash` — instala
   openssh/tmux/python, `sshd` via termux-services, `allow-external-apps`,
   mostra um **código de pareamento**.
3. No PC, `quest-pair`: acha o Quest na rede (varre porta 8022), usa o
   código pra trocar chaves e desliga senha.
4. Cortar o sentido Quest → PC: sem sshd no Windows, sem PowerShell
   elevado, sem firewall. Só o PC precisa entrar no Quest.

## Próximo: Experimento 02

Servir o cubo **do PC** via túnel HTTPS e abrir o link no Quest Browser,
sem Termux. Validar: WebXR + mãos + oclusão + botão de captura. Se passar,
o caminho A está provado. Requer `cloudflared` no PC (winget).
