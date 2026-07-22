#!/bin/bash
# sync-git.sh
cd ~/workspace/projects.node/ts-parse/output

REPO="conecdata/uai-data"
BRANCH="main"

# O @.git ignora alterações internas do Git para não gerar loop
inotifywait -m -e modify,create -r --exclude '@\.git' . |
while read path action file; do
  echo "Mudança detectada: $file ($action)"

  git add .
  git commit -m "auto-update: $(date)"
  git push origin "$BRANCH"

  echo "Purgando cache jsDelivr para todos os arquivos .json..."

  # Purga cache de cada .json na pasta output (nível raiz)
  find . -maxdepth 1 -type f -name "*.json" -print0 |
  while IFS= read -r -d '' jsonfile; do
    filename=$(basename "$jsonfile")
    url="https://purge.jsdelivr.net/gh/${REPO}@${BRANCH}/${filename}"
    curl -s "$url" > /dev/null
    echo "  -> Cache purgado: $filename"
  done

  echo "Purge finalizado!"
  sleep 2
done
