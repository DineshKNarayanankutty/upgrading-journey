#!/bin/bash
# Safely drain a node before maintenance
kubectl drain $1 --ignore-daemonsets --delete-emptydir-data
