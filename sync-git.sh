#!/bin/bash
# sync-git.sh
cd ~/workspace/projects.node/ts-parse/output

inotifywait -m -e modify,create -r . |
while read path action file; do
  echo "Mudança detectada: $file ($action)"
  git add .
  git commit -m "auto-update: $(date)"
  git push origin main
  sleep 2
done

