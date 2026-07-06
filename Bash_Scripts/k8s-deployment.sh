#!/bin/bash

APP_NAME = "my-web-app"
NAME_SPACE = "dev-namespace"
IMAGE_NAME = "azurecr.io/my-app-dkn"
VERSION = $(git rev-parse --short HEAD)
MANIFEST_PATH = "./k8s/deployment.yaml"

echo "Starting Deployment for $APP_NAME"

echo "Applying Manifest from $MANIFEST_PATH"

kubectl apply -f $MANIFEST_PATH -n $NAME_SPACE

echo "Updating Image to $IMAGE_NAME:$VERSION"

kubectl set image deployment/$APP_NAME $APP_NAME=$IMAGE_NAME:$VERSION -n $NAME_SPACE

echo "Waiting for rollout to complete"

if kubectl rollout status deployment/$APP_NAME -n $NAME_SPACE; then
  echo "Deployment Successful"
else
  echo "Deployment failed, rolling back"
  kubectl rollout undo deployment/$APP_NAME -n $NAME_SPACE
  exit 1
fi