# quest3-claude-ops — contexto pra qualquer sessão nova

Ponto de coordenação entre a sessão Claude Code no PC do Julio (`<hostname>`,
usuário `<usuario>`) e a sessão Termux no Meta Quest 3. Objetivo do Julio:
"zero barreiras" — ligar o headset, tocar um app, abrir o agente aqui, e
tudo funcionar sem reexplicar contexto.

## Estado permanente (não precisa refazer)

- PC: `sshd` é serviço Windows (`Get-Service sshd`), `StartupType: Automatic`
  — sobe sozinho a cada boot do PC. Firewall porta 22 já liberada.
- PC → Quest: `ssh quest3 "<comando>"` já configurado (`~/.ssh/config`, host
  `quest3`, chave `id_ed25519_quest3_reverse`). Testado e funcionando.
- Quest → PC: `ssh <usuario>@<ip-do-pc>` já funciona (chave `id_ed25519_quest`
  do lado Termux, em `administrators_authorized_keys` — `<usuario>` é admin).

## Único ponto frágil real: sshd do Termux não sobrevive a background/reboot

Se `ssh quest3 whoami` falhar (timeout ou connection refused):

1. Confirmar que o Quest está ligado e na mesma rede (`192.168.x.x`).
2. Pedir ao Julio pra tocar o widget "iniciar-ssh" na tela inicial do Quest
   (Termux:Widget, script em `shortcuts/iniciar-ssh.sh` — sobe `sshd` com
   `termux-wake-lock`, idempotente). Se o widget não estiver instalado
   ainda, ele abre o Termux manualmente uma vez (o `.bashrc` já sobe o
   `sshd` sozinho ao abrir shell interativo).
3. IP do Quest é DHCP — pode ter mudado. Reconfirmar com
   `ssh quest3 whoami` depois de reinstalar o alias se necessário (ver
   `SKILL_sessao_remota.md` pros dados de referência, mas o IP real pode
   estar desatualizado ali — sempre validar antes de assumir).

## Armadilha conhecida do lado Termux

O pacote global `@anthropic-ai/claude-code` já voltou sozinho pra uma
versão que exige binário nativo inexistente pra Android/Bionic. Se
`ssh quest3 claude --version` der `Error: claude native binary not
installed`, rodar:
```bash
ssh quest3 "npm install -g @anthropic-ai/claude-code@2.1.112 --ignore-scripts --force"
```

## Privilégios de administrador no PC

Comandos que exigem admin (instalar capability do Windows, mudar firewall,
editar `administrators_authorized_keys`) **não têm elevação automática** —
a sessão do Claude Code aqui roda com privilégio normal de usuário, de
propósito. Quando precisar de admin, a sessão deve pedir ao Julio pra abrir
PowerShell "Executar como Administrador" e colar o comando — não existe
hoje um caminho de auto-elevação configurado. Se isso mudar (ex: task
agendada com privilégio elevado), documentar aqui a decisão e o motivo.

## Convenção de comunicação

- Rotina/reporte: direto por SSH, sem passar por issue.
- Bloqueio real (decisão de arquitetura, mudança de sistema): issue no
  GitHub, label `para-julio`/`para-pc`/`para-termux` conforme quem
  precisa agir.
- Trabalho feito: commit + push direto, sem PR se for so documentacao de
  estado (STATUS.md, este arquivo).
