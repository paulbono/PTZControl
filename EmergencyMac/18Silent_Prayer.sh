#!/bin/bash
# 18Silent_Prayer.sh

echo "Silent prayer"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Silent prayer]"}' http://127.0.0.1:3000/slide

