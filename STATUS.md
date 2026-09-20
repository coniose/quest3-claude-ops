# Status

Preencha aqui o resultado de cada passo do TASK.md — feito / bloqueado / erro,
com a mensagem exata quando houver. Commit e push a cada atualização.

## Task 001

- [x] `pkg install openssh`/`mosh`
  - Feito 2026-09-20. `openssh` já estava instalado na versão mais nova do repo
    Termux: `openssh is already the newest version (10.5p1). 0 upgraded, 0
    newly installed`. Cliente `ssh` disponível: `OpenSSH_10.5p1, OpenSSL 3.5.4`.
    Não instalei `mosh` — só se a rede se mostrar instável no passo 2.
- [ ] Teste de conexão SSH ao PC/home lab
  - **Bloqueado.** Aberto issue #1 pedindo IP, usuário Windows, status do
    `sshd` e confirmação de mesma Wi-Fi. Sessão PC (PC) resolve por
    comentário no issue; sessão Termux relê e retoma o passo 2.
- [ ] `claude` funcionando do lado do PC via essa sessão SSH
