#!/bin/bash
# 17Closing_Hymn.sh

echo "Closing Hymn"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Closing Hymn]"}' http://127.0.0.1:3000/slide

