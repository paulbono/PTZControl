#!/bin/bash
# 19Announcements.sh

echo "Announcements"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Announcements]"}' http://127.0.0.1:3000/slide

