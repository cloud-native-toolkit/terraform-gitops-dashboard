#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)
CHART_DIR=$(cd "${SCRIPT_DIR}/../chart"; pwd -P)

REPO="$1"
REPO_PATH="$2"
NAMESPACE="$3"
VALUES_CONTENT="$4"

REPO_DIR=".tmprepo-dashboard-${NAMESPACE}"

SEMAPHORE="${REPO//\//-}.semaphore"

while true; do
  echo "Checking for semaphore"
  if [[ ! -f "${SEMAPHORE}" ]]; then
    echo -n "${REPO_DIR}" > "${SEMAPHORE}"

    if [[ $(cat "${SEMAPHORE}") == "${REPO_DIR}" ]]; then
      echo "Got the semaphore. Setting up gitops repo"
      break
    fi
  fi

  SLEEP_TIME=$((1 + $RANDOM % 10))
  echo "  Waiting $SLEEP_TIME seconds for semaphore"
  sleep $SLEEP_TIME
done

function finish {
  rm "${SEMAPHORE}"
}

trap finish EXIT

git config --global user.email "cloudnativetoolkit@gmail.com"
git config --global user.name "Cloud-Native Toolkit"

mkdir -p "${REPO_DIR}"

git clone "https://${TOKEN}@${REPO}" "${REPO_DIR}"

cd "${REPO_DIR}" || exit 1

mkdir -p "${REPO_PATH}"

cp -R "${CHART_DIR}/dashboard" "${REPO_PATH}"
echo "${VALUES_CONTENT}" > "${REPO_PATH}/dashboard/values.yaml"

git add .
git commit -m "Adds config for Dashboard"
git push

cd ..
rm -rf "${REPO_DIR}"
