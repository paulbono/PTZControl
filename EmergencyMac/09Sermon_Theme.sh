#!/bin/bash
# 09Sermon_Theme.sh

echo "Sermon Theme"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Sermon Theme]"}' http://127.0.0.1:3000/slide

