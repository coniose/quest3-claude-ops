#!/data/data/com.termux/files/usr/bin/bash
# claudepc-reabrir — encerra sessoes claudepc abertas no Termux e abre uma
# nova, visivel na tela do Quest. Pensado pra ser disparado do PC:
#   ssh quest3 claudepc-reabrir
# Instalar: cp shortcuts/claudepc-reabrir.sh $PREFIX/bin/claudepc-reabrir && chmod +x $PREFIX/bin/claudepc-reabrir
#
# Requer allow-external-apps = true em ~/.termux/termux.properties (intent
# RUN_COMMAND). SESSION_ACTION 0 = abre aba nova e traz o Termux pra frente.
#
# Roda dentro do tmux (sessao "claude") pra que o PC consiga digitar nela:
#   ssh quest3 "tmux send-keys -t claude 'texto' Enter"

tmux kill-session -t claude 2>/dev/null
pkill -f "^ssh -t pc " && sleep 1

am startservice --user 0 \
  -n com.termux/com.termux.app.RunCommandService \
  -a com.termux.RUN_COMMAND \
  --es com.termux.RUN_COMMAND_PATH "$PREFIX/bin/tmux" \n  --esa com.termux.RUN_COMMAND_ARGUMENTS "new-session,-s,claude,$PREFIX/bin/claudepc" \
  --ez com.termux.RUN_COMMAND_BACKGROUND false \
  --es com.termux.RUN_COMMAND_SESSION_ACTION 0 >/dev/null
