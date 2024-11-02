#!/bin/bash
# 07Sermon_Text.sh

echo "Sermon Text"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Sermon Text]"}' http://127.0.0.1:3000/slide

