#!/bin/bash
# Show diff before upgrading a release
helm plugin install https://github.com/databus23/helm-diff 2>/dev/null || true
helm diff upgrade $1 $2 --values values.yaml
