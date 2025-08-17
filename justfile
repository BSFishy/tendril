# list just recipes
default:
  @just --list

# deploy the cluster
deploy:
  @bash deploy.sh

# destroy the cluster
destroy:
  @bash destroy.sh

# prompt for and deploy cloudflare-related tokens
cloudflare-token:
  @bash scripts/cloudflare_token.sh

# get and deploy cert-manager passwords
cert-manager-password:
  @bash scripts/cert_manager_password.sh

# generate and deploy postgres passwords
postgres-password:
  @bash scripts/postgres_password.sh

# generate and deploy redis passwords
redis-password:
  @bash scripts/redis_password.sh

# generate and deploy authentik passwords
authentik-password:
  @bash scripts/authentik_password.sh
