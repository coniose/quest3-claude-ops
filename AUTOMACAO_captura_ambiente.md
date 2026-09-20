# Automação: captura de ambiente via Google Drive

Primeiro "Hello World" de percepção do projeto: o Quest captura algo
(print de tela ou foto via passthrough) e o PC — via uma sessão de
Claude Code com acesso ao Google Drive — lê e descreve o conteúdo, sem
depender de acesso a armazenamento do Termux (que esbarra em restrições de
escopo do Android sem root — ver a nota abaixo).

## Por que Google Drive, e não SSH/armazenamento do Termux

Tentamos primeiro localizar o arquivo de captura de tela nativo do Quest
via `~/storage` do Termux (depois de `termux-setup-storage`). Não funcionou:
mesmo com a permissão básica de armazenamento concedida, as pastas
relevantes (`pictures`, `dcim`, `shared`) apareciam vazias para o Termux.
Isso é esperado em Android moderno — a permissão básica de armazenamento
não dá acesso a arquivos criados por outros apps fora das categorias
indexadas; resolver isso de verdade exigiria a permissão especial "acesso a
todos os arquivos" (não testada) ou pode nem ser possível se o Quest salva
capturas num caminho proprietário da Meta.

Google Drive contorna o problema inteiro: o usuário arrasta o arquivo
manualmente para uma pasta do Drive (o app já está instalado e sincronizado
no Quest), e o PC lê de lá via integração MCP — sem tocar em permissão de
armazenamento do Android.

## Fluxo

1. Usuário captura algo no Quest (print de tela nativo, ou foto via
   passthrough) — fora do escopo desta automação, é ação manual do usuário.
2. Usuário move/compartilha o arquivo para uma pasta específica do Google
   Drive, acessível a partir do app Drive já instalado no Quest.
3. Do lado do PC, uma sessão de Claude Code com acesso à ferramenta de
   Google Drive: busca o arquivo mais recente na pasta combinada
   (`search_files` com `parentId`), baixa o conteúdo
   (`download_file_content`, retorna base64), decodifica pra um arquivo
   binário local, e lê a imagem com a ferramenta de leitura de arquivo —
   nesse ponto o modelo já "vê" o conteúdo e pode descrever, contextualizar
   ou disparar a próxima ação.

## Limitação conhecida, de propósito nesta fase

Isso é prototipagem, não a arquitetura final de baixa latência — cada
captura exige uma ação manual do usuário (mover o arquivo pro Drive) e uma
consulta do PC (não é tempo real, é sob demanda). Serve para validar o
conceito ("o agente consegue perceber algo capturado no device") antes de
investir em automação de captura contínua ou pipeline de menor latência.

## Próximo passo em aberto

Se a captura de ambiente virar rotina (várias fotos, contexto contínuo), a
automação de fato seria: script no Termux que tira a foto (`termux-camera-photo`,
já disponível — não depende do problema de armazenamento descrito acima,
porque escreve direto num caminho que o próprio Termux controla) e algo do
lado do Termux/PC que envia automaticamente pro Drive sem intervenção
manual a cada captura. Ainda não construído.
