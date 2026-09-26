# Experimento 01 — cubo interativo em AR, editado do PC (2026-09-25)

**Pergunta:** dá pra editar um objeto 3D no PC e ver o resultado no Quest 3
"de bate-pronto", sem cabo, build ou Link?

**Resposta: sim.** Página three.js/WebXR servida pelo Termux em
`localhost` (contexto seguro → WebXR sem HTTPS), atualizada pelo PC via SSH
em segundos.

## Confirmado no headset (pelo Julio)

- Cubo em AR com passthrough, pegável com mão (pinça) ou controle.
- Oclusão: mão real na frente esconde o cubo (esferas depth-only nas
  articulações + `depth-sensing` concedido pelo Quest Browser).
- Botão 3D de captura: manda pro PC a cena virtual (olho esquerdo) e um
  quadro da câmera real do passthrough — só quando o Julio aperta.
- Log remoto da página (`POST /log`) — único jeito de ver erro de JS no
  Quest sem adb/DevTools. Foi o que destravou todos os bugs.

## Custo real pra chegar aqui

Termux sideloaded, sshd nos dois lados, chaves, firewall, PowerShell
elevado, IP fixo/descoberto à mão — ver `STATUS.md`. **Essa é a barreira
pra escalar**, não o 3D. Próximo experimento ataca isso.

Código: `prototipos/cubo/`. Tag: `experimento-01`.
