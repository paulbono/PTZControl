#!/bin/bash
# 10Creed.sh

echo "Creed"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Creed]"}' http://127.0.0.1:3000/slide

