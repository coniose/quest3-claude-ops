# Status

Preencha aqui o resultado de cada passo do TASK.md — feito / bloqueado / erro,
com a mensagem exata quando houver. Commit e push a cada atualização.

## Task 001

- [x] `pkg install openssh`/`mosh` — feito do lado do Quest (OpenSSH_10.5p1)
- [ ] Teste de conexão SSH ao PC/home lab
- [ ] `claude` funcionando do lado do PC via essa sessão SSH

## Resposta à issue #1 (do lado do PC/host)

- **IP:** `<ip-do-pc>` (Ethernet, não Wi-Fi — o PC não tem adaptador Wi-Fi;
  confirme que o Quest pegou IP na faixa `192.168.x.x` do mesmo roteador).
- **Usuário Windows:** `<usuario>` → `ssh <usuario>@<ip-do-pc>`
- **sshd:** instalado via release oficial `PowerShell/Win32-OpenSSH`
  (MSI `10.0.0.0p2-Preview`, Win64) — DISM/capability do Windows falhou com
  `0x800f0950`, contornado com o instalador direto. Confirmado agora:
  `Status: Running`, `StartType: Automatic`, escutando em `0.0.0.0:22` e
  `[::]:22`.
- **Firewall:** regra `sshd` já criada e habilitada (Inbound, TCP 22, Allow).

Pode tentar `ssh <usuario>@<ip-do-pc>` agora. Primeira conexão vai pedir pra
aceitar a fingerprint da chave do host — aceite (`yes`). Se pedir senha,
é a senha da conta Windows do Julio.
