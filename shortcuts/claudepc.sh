#!/data/data/com.termux/files/usr/bin/bash
# claudepc — abre o Claude Code do PC a partir do Termux no Quest.
# Instalar: cp shortcuts/claudepc.sh $PREFIX/bin/claudepc && chmod +x $PREFIX/bin/claudepc
#
# Depende de um alias "pc" no ~/.ssh/config do Termux (IP/usuario ficam so
# la, fora deste repo publico):
#   Host pc
#     HostName <ip-do-pc>
#     User <usuario>
#     IdentityFile ~/.ssh/id_ed25519_quest
#     IdentitiesOnly yes
#
# Uso:
#   claudepc                 -> sessao interativa NOVA (sem --continue: nao
#                               herda a conversa do PC — ver SKILL_sessao_remota.md)
#   (sempre com --dangerously-skip-permissions — decisao do Julio 2026-09-25,
#   ver SKILL_sessao_remota.md)
#   claudepc -p "prompt"     -> repassa os argumentos pro claude (headless)
#
# Shell padrao do sshd no Windows e cmd.exe, por isso "cd /d" e "&&".
# Argumentos vao entre aspas duplas pro cmd — evite aspas duplas dentro do
# prompt.

PC_HOST="${CLAUDEPC_HOST:-pc}"
PC_DIR="${CLAUDEPC_DIR:-C:\\quest3-claude-ops}"

if [ $# -eq 0 ]; then
  exec ssh -t "$PC_HOST" "cd /d $PC_DIR && claude --dangerously-skip-permissions"
fi

args=""
for a in "$@"; do
  args="$args \"$a\""
done
exec ssh -t "$PC_HOST" "cd /d $PC_DIR && claude --dangerously-skip-permissions$args"
