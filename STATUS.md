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
  - **Bloqueado, aguardando Julio.** Preciso de:
    1. IP local do PC na Wi-Fi (`ipconfig` no PowerShell, "Endereço IPv4").
    2. Nome de usuário do Windows pra logar (`ssh <usuario>@<ip>`).
    3. Confirmação de que o OpenSSH Server do Windows está **rodando e com a
       porta 22 liberada no firewall** — normalmente vem desativado. Julio
       pediu explicitamente pra não habilitar isso daqui sem ele olhando.
    4. Confirmação de que Quest e PC estão na mesma rede Wi-Fi. Se não
       estiverem, `TASK.md` diz pra parar e reportar antes de partir pra
       Tailscale.
- [ ] `claude` funcionando do lado do PC via essa sessão SSH
