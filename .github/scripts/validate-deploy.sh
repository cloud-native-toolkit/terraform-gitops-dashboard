#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

NAMESPACE="gitops-dashboard"
SERVER_NAME="default"

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/2-services/cluster/${SERVER_NAME}/base/${NAMESPACE}-dashboard.yaml" ]]; then
  echo "ArgoCD config for dashboard missing: argocd/2-services/cluster/${SERVER_NAME}/base/${NAMESPACE}-dashboard.yaml"
  exit 1
fi

echo "ArgoCD config found: argocd/2-services/cluster/${SERVER_NAME}/base/${NAMESPACE}-dashboard.yaml"
cat argocd/2-services/cluster/${SERVER_NAME}/base/${NAMESPACE}-dashboard.yaml

if [[ ! -f "payload/2-services/namespace/${NAMESPACE}/dashboard/values-${SERVER_NAME}.yaml" ]]; then
  echo "Dashboard application values not found: payload/2-services/namespace/${NAMESPACE}/dashboard/values-${SERVER_NAME}.yaml"
  exit 1
fi

echo "Dashboard application values found: payload/2-services/namespace/${NAMESPACE}/dashboard/values-${SERVER_NAME}.yaml"
cat payload/2-services/namespace/${NAMESPACE}/dashboard/values-${SERVER_NAME}.yaml
sleep 4m
cd ..
rm -rf .testrepo
