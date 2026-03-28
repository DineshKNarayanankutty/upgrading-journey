#!/bin/bash
# Prune unused images, containers, volumes
docker system prune -af --volumes
