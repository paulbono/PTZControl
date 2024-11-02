#!/bin/bash
# 13Lords_Prayer.sh

echo "Lords Prayer"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Lords Prayer]"}' http://127.0.0.1:3000/slide

