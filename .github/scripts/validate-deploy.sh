#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

ls -l

if [[ ! -f "argocd/2-services/active/dashboard.yaml" ]]; then
  echo "ArgoCD config for dashboard missing"
  exit 1
else
  echo "ArgoCD config for dashboard found"
fi

cat argocd/2-services/active/dashboard.yaml

if [[ ! -f "payload/2-services/dashboard/values.yaml" ]]; then
  echo "Dashboard application values not found"
  exit 1
else
  echo "Dashboard application values found"
fi

cat payload/2-services/dashboard/values.yaml

cd ..
rm -rf .testrepo
