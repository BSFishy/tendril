#!/usr/bin/env bash

set -euo pipefail

NS="${1:-cert-manager}"
SECRET_NAME="cloudflare-api-token-secret"

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

# 1. Generate a secure password (32 bytes, Base64 URL-safe)
CLOUDFLARE_API_TOKEN=$(kubectl get -n cloudflared secret cloudflared-secret -o jsonpath='{.data.api-token}' | base64 --decode)

# 2. Create or update the K8s secret
kubectl -n "$NS" delete secret "$SECRET_NAME" --ignore-not-found
kubectl -n "$NS" create secret generic "$SECRET_NAME" \
  --from-literal=api-token="$CLOUDFLARE_API_TOKEN"

# 3. Output the password to stdout (or pipe to wherever you store your Helm values)
echo "Created secret '$SECRET_NAME' in namespace '$NS'"
