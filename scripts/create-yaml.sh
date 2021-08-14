#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CHART_DIR=$(cd "${SCRIPT_DIR}/../chart/dashboard"; pwd -P)

OUTPUT_PATH="$1"
VALUES_FILE="$2"

mkdir -p "${OUTPUT_PATH}"

cp -R "${CHART_DIR}"/* "${OUTPUT_PATH}"

if [[ -n "${VALUES_CONTENT}" ]]; then
  echo "${VALUES_CONTENT}" > "${OUTPUT_PATH}/values.yaml"
fi

if [[ -n "${VALUES_SERVER_CONTENT}" ]] && [[ -n "${VALUES_FILE}" ]]; then
  echo "${VALUES_SERVER_CONTENT}" > "${OUTPUT_PATH}/${VALUES_FILE}"
fi

echo "Files in output path"
ls -l "${OUTPUT_PATH}"
