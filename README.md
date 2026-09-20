# quest3-claude-ops

Registro público de como rodei o Claude Code dentro de um Meta Quest 3
(via Termux, sideload) e conectei isso a uma sessão de Claude Code no meu
computador principal — os dois se coordenando via SSH, nos dois sentidos.
É infraestrutura exploratória pra um agente de IA vestível, não produto
pronto.

## O que tem aqui

- **`TASK.md`/`STATUS.md`** — o histórico real do trabalho: cada problema
  batido, cada correção, na ordem em que aconteceu. Não é retrospectiva
  limpa, é o log de verdade (incluindo os becos sem saída).
- **`SKILL_sessao_remota.md`** — como funciona a conexão SSH bidirecional
  entre o PC e o Quest, e a armadilha real de versão que já pegou mais de
  uma vez.
- **`CLAUDE.md`** — contexto de bootstrap: o que qualquer sessão nova de
  Claude Code precisa saber pra continuar esse trabalho sem re-explicação.
- **`AUTOMACAO_captura_ambiente.md`** — primeiro teste de percepção: Quest
  captura algo, Claude do lado do PC lê e descreve, via Google Drive como
  ponte (não via armazenamento do Termux, que esbarra em restrição de
  escopo do Android sem root).
- **`shortcuts/`** — script pra manter o SSH do lado do Quest resiliente a
  reinício de app/dispositivo, pensado pra rodar via Termux:Widget.

## Obstáculos reais, não escondidos

- Claude Code (binário nativo, a partir da v2.1.113) não tem build pra
  `linux-arm64-android` (Bionic) — só roda em Termux numa versão JS mais
  antiga (2.1.112), e essa versão volta a ser sobrescrita sozinha por
  atualizações do pacote global — é preciso reinstalar a versão fixa
  sempre que isso acontecer.
- Sessão SSH não-interativa no Windows não enxerga o Credential Manager —
  git por HTTPS falha silenciosamente nesse contexto; a solução foi trocar
  pra autenticação por chave SSH.
- `sshd` do Termux não sobrevive a app em segundo plano nem a reinício do
  device por padrão — sem root, não tem gerenciamento de serviço real como
  o Windows tem.

## Por que isso é interessante

O objetivo de longo prazo não é rodar tudo no Quest — é validar arquitetura
antes de decidir onde processar o quê. Óculos mais baratos e mais leves
(o alvo real) têm ainda menos CPU/memória que o Quest 3, então "o que dá
pra tirar do dispositivo e processar em outro lugar" importa mais que
"o que dá pra forçar rodar localmente".
