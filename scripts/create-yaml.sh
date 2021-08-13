#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
CHART_DIR=$(cd "${SCRIPT_DIR}/..chart/dashboard"; pwd -P)

OUTPUT_PATH="$1"
VALUES_FILE="$2"

mkdir -p "${OUTPUT_PATH}"

cp -R "${CHART_DIR}"/* "${OUTPUT_PATH}"

echo "${VALUES_CONTENT}" > "${OUTPUT_PATH}/${VALUES_FILE}"
