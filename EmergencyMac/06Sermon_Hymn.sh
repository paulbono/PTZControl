#!/bin/bash
# 06Sermon_Hymn.sh

echo "Sermon Hymn"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Sermon Hymn]"}' http://127.0.0.1:3000/slide

