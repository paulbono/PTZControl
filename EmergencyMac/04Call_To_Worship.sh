#!/bin/bash
# 04Call_To_Worship.sh

echo "Call To Worship"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Call To Worship]"}' http://127.0.0.1:3000/slide

