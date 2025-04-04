#!/bin/bash
. "$(dirname "$0")/.env"

inotifywait -m -r -e create --format '%f' "${SCAN_DIR}" | while read -r NEWFILE
do
  file="${SCAN_DIR}/${NEWFILE}"
  if [[ "${file}" =~ \.[pP][dD][fF]$ ]]; then
    sleep 10 # FIXME: Wait until the document is fully streamed
    # Upload the file
    curl -X POST \
      -H 'Accept: application/json' \
      -H "Authorization: Token $API_KEY" \
      -F "document=@$file" \
      "$REMOTE_URL"
    if [ "$?" == 0 ]; then
      echo "File ${file} uploaded."
    else
      echo "File ${file} not uploaded!"
    fi
  fi
  rm -- "${file}" || true
done