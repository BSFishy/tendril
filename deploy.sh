#!/usr/bin/env bash

set -e

helmfile -f helmfile.yaml apply
