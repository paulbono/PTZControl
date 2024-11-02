#!/bin/bash
# 20After_Service_Video.sh

echo "After Service Video"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[After Service Video]"}' http://127.0.0.1:3000/slide

