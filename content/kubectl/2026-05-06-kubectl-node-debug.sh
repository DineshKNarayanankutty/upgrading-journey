#!/bin/bash
# Debug a node via ephemeral container
kubectl debug node/$1 -it --image=busybox
