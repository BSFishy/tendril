# list just recipes
default:
  @just --list

# deploy phase 01
deploy-01:
  @bash phases/01-core/deploy.sh

# destroy phase 01
destroy-01:
  @bash phases/01-core/destroy.sh

# prompt for and deploy cloudflare-related tokens
cloudflare-token:
  @bash phases/01-core/scripts/cloudflare_token.sh

# get and deploy cert-manager passwords
cert-manager-password:
  @bash phases/01-core/scripts/cert_manager_password.sh

# generate and deploy postgres passwords
postgres-password:
  @bash phases/01-core/scripts/postgres_password.sh

# generate and deploy redis passwords
redis-password:
  @bash phases/01-core/scripts/redis_password.sh

# generate and deploy authentik passwords
authentik-password:
  @bash phases/01-core/scripts/authentik_password.sh
