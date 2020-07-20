#!/bin/sh

FILE="/usr/share/nginx/html/index.html"

if [ -z "${ENVIRONMENT}" ]; then
  ENVIRONMENT="undefined"
fi

if [ -e "${FILE}" ]; then
  sed -i'' "s/%%environment%%/${ENVIRONMENT}/g" "${FILE}"
fi

