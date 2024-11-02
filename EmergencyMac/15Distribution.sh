#!/bin/bash
# 15Distribution.sh

echo "Distribution"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Distribution]"}' http://127.0.0.1:3000/slide

