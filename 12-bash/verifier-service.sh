#!/usr/bin/env bash
# Vérifie un service étape par étape : DNS, port (TCP), HTTP.
# Usage : ./verifier-service.sh <hôte> <port> [chemin]
# Codes de sortie : 0 tout va bien, 1 DNS, 2 port, 3 HTTP.

set -euo pipefail

HOTE="${1:?Usage : $0 <hôte> <port> [chemin]}"
PORT="${2:?Usage : $0 <hôte> <port> [chemin]}"
CHEMIN="${3:-/}"

echo "🔎 Vérification de http://$HOTE:$PORT$CHEMIN"

# 1. DNS : le nom donne-t-il une adresse IP ?
if IP=$(getent ahosts "$HOTE" | awk 'NR == 1 { print $1 }') && [ -n "$IP" ]; then
  echo "✅ DNS  : $HOTE → $IP"
else
  echo "❌ DNS  : impossible de résoudre $HOTE"
  exit 1
fi

# 2. Port : quelqu'un écoute-t-il ?
if nc -z -w 3 "$IP" "$PORT" 2>/dev/null; then
  echo "✅ Port : $PORT ouvert"
else
  echo "❌ Port : rien n'écoute sur $IP:$PORT (vérifier sur le serveur : ss -tlnp)"
  exit 2
fi

# 3. HTTP : le service répond-il correctement ?
CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "http://$HOTE:$PORT$CHEMIN") || CODE="000"
if [ "$CODE" -ge 200 ] && [ "$CODE" -lt 400 ]; then
  echo "✅ HTTP : code $CODE"
else
  echo "❌ HTTP : code $CODE (regarder les logs de l'application)"
  exit 3
fi

echo "🎉 Service opérationnel"
