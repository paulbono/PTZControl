#!/bin/bash
# 12Prayer.sh

echo "Prayer"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Prayer]"}' http://127.0.0.1:3000/slide

