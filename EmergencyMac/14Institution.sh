#!/bin/bash
# 14Institution.sh

echo "Institution"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Institution]"}' http://127.0.0.1:3000/slide

