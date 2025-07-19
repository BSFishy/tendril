#!/usr/bin/env bash

set -euo pipefail

NS="${1:-authentik}"
SECRET_NAME="authentik-creds"

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
POSTGRES_ADMIN_PASSWORD=$(kubectl get -n postgres secret postgres-creds -o jsonpath='{.data.postgres-password}' | base64 --decode)
REDIS_PASSWORD=$(kubectl get -n redis secret redis-creds -o jsonpath='{.data.password}' | base64 --decode)
AUTHENTIK_SECRET_KEY="$(openssl rand -base64 32 | tr -d '\n')"

# 2. Create or update the K8s secret
kubectl -n "authentik" delete secret "authentik-creds" --ignore-not-found
kubectl -n "authentik" create secret generic "authentik-creds" \
  --from-literal=postgres-password="$POSTGRES_ADMIN_PASSWORD" \
  --from-literal=redis-password="$REDIS_PASSWORD" \
  --from-literal=secret-key="$AUTHENTIK_SECRET_KEY"

# 3. Output the password to stdout (or pipe to wherever you store your Helm values)
echo "Created secret '$SECRET_NAME' in namespace '$NS'"
