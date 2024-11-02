#!/bin/bash
# 05Old_Testament.sh

echo "Old Testament"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Old Testament]"}' http://127.0.0.1:3000/slide

