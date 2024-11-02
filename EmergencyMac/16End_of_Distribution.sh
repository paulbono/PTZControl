#!/bin/bash
# 16End_of_Distribution.sh

echo "End of Distribution"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[End of Distribution]"}' http://127.0.0.1:3000/slide

