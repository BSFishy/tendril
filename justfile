# list just recipes
default:
  @just --list

deploy-01:
  @bash phases/01-core/deploy.sh
