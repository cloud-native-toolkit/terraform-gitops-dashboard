#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
MODULE_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)
CHART_DIR=$(cd "${MODULE_DIR}/chart/dashboard"; pwd -P)

DEST_DIR="$1"
SERVER_VALUES_FILE="$2"

mkdir -p "${DEST_DIR}"

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR="./.tmp/dashboard"
fi
mkdir -p "${TMP_DIR}"
cp -R "${CHART_DIR}"/* "${DEST_DIR}"

if [[ -n "${VALUES_CONTENT}" ]]; then
  echo "${VALUES_CONTENT}" > "${DEST_DIR}/values.yaml"
fi

if [[ -n "${VALUES_SERVER_CONTENT}" ]] && [[ -n "${SERVER_VALUES_FILE}" ]]; then
  echo "${VALUES_SERVER_CONTENT}" > "${DEST_DIR}/${SERVER_VALUES_FILE}"
fi

echo "Files in output path"
ls -l "${DEST_DIR}"
