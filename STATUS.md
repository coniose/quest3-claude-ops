# Status

Preencha aqui o resultado de cada passo do TASK.md — feito / bloqueado / erro,
com a mensagem exata quando houver. Commit e push a cada atualização.

## Task 001

- [x] `pkg install openssh`/`mosh`
  - Feito 2026-09-20. `openssh` já estava instalado na versão mais nova do repo
    Termux: `openssh is already the newest version (10.5p1). 0 upgraded, 0
    newly installed`. Cliente `ssh` disponível: `OpenSSH_10.5p1, OpenSSL 3.6.3`.
    Não instalei `mosh` — só se a rede se mostrar instável no passo 2.
- [~] Teste de conexão SSH ao PC/home lab — **em progresso, bloqueado em auth**
  - Alvo: `<usuario>@<ip-do-pc>` (dados vieram do PR #2 do PC, seção abaixo).
  - Rede: `ping` bloqueado (esperado — firewall Windows não libera ICMP), mas
    TCP:22 responde e banner é `SSH-2.0-OpenSSH_for_Windows_10.0
    Win32-OpenSSH-GitHub`. Ou seja: **rota + porta 22 + sshd todos OK**.
  - Auth: sessão Termux não tem como digitar senha interativamente. Gerei par
    ed25519 local (`~/.ssh/id_ed25519_quest`, sem passphrase). Bloqueio ativo
    → **issue #3**: PC não conseguiu escrever em
    `C:\ProgramData\ssh\administrators_authorized_keys` (shell dele sem admin);
    pediu ao Julio rodar o bloco PowerShell **em janela elevada**. Testado
    daqui: `ssh -i ... -o PasswordAuthentication=no <usuario>@<ip-do-pc>` retorna
    `Permission denied (publickey,password,keyboard-interactive)` — auth ainda
    falha, ou seja pubkey não está no arquivo (ou está com ACL errada).
  - Chave pública (adicionar como linha única no `authorized_keys`):
    ```
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCx/33S+CLcn0N9ZFwivh/5hNkv2fuZgY9esxyJRmJR quest3-termux-20260920
    ```
- [ ] `claude` funcionando do lado do PC via essa sessão SSH

## Resposta à issue #1 (do lado do PC/host, PR #2 do PC)

- **IP:** `<ip-do-pc>` (Ethernet, não Wi-Fi — o PC não tem adaptador Wi-Fi;
  Quest e PC no mesmo roteador `192.168.x.x` — confirmado, TCP alcança).
- **Usuário Windows:** `<usuario>` → `ssh <usuario>@<ip-do-pc>`
- **sshd:** instalado via release oficial `PowerShell/Win32-OpenSSH`
  (MSI `10.0.0.0p2-Preview`, Win64) — DISM/capability do Windows falhou com
  `0x800f0950`, contornado com o instalador direto. Confirmado agora:
  `Status: Running`, `StartType: Automatic`, escutando em `0.0.0.0:22` e
  `[::]:22`.
- **Firewall:** regra `sshd` já criada e habilitada (Inbound, TCP 22, Allow).
