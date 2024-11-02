#!/bin/bash
# 22Sanctuary_Special.sh

echo "Sanctuary Special"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Sanctuary Special]"}' http://127.0.0.1:3000/slide

