#!/bin/bash
# 11Pulpit.sh

echo "Pulpit"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Pulpit]"}' http://127.0.0.1:3000/slide

