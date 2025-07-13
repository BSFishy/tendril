#!/usr/bin/env bash

set -e

helmfile -f phases/01-core/helmfile.yaml apply
