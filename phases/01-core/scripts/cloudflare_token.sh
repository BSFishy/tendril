#!/usr/bin/env bash

set -euo pipefail

NS="${1:-cloudflared}"
SECRET_NAME="cloudflared-secret"

# 0. Create the namespace
if kubectl get namespace "$NS" &>/dev/null; then
  echo "Namespace '$NS' already exists."
else
  echo "Namespace '$NS' not found. Creating..."
  kubectl create namespace "$NS"
fi

# 0.5. Check if the secret already exists
if kubectl get secret -n "$NS" "$SECRET_NAME" &>/dev/null; then
  echo "Secret '$SECRET_NAME' in namespace '$NS' already exists. To rewrite it, delete it and rerun this script"
  exit
fi

# 1. Get information from user
echo "You can get an API token from https://dash.cloudflare.com/profile/api-tokens. It will need zone read & DNS edit permissions on all zones."
read -sr -p "Enter API token: " CLOUDFLARE_TOKEN

echo "The Cloudflare Zero Trust dashboard is at https://one.dash.cloudflare.com/. You can find your tunnel token from there."
read -sr -p "Enter tunnel token: " CLOUDFLARE_TUNNEL_TOKEN

# 2. Create or update the K8s secret
kubectl -n "$NS" delete secret "$SECRET_NAME" --ignore-not-found
kubectl -n "$NS" create secret generic "$SECRET_NAME" \
  --from-literal=api-token="$CLOUDFLARE_TOKEN" \
  --from-literal=cf-tunnel-token="$CLOUDFLARE_TUNNEL_TOKEN"

# 3. Output the password to stdout (or pipe to wherever you store your Helm values)
echo "Created secret '$SECRET_NAME' in namespace '$NS'"
