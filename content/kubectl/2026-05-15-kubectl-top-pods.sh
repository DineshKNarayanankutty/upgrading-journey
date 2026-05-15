#!/bin/bash
# Top pods sorted by CPU
kubectl top pods -A --sort-by=cpu | head -20
