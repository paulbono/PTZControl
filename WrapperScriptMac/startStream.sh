#!/bin/bash

# echo "Begin Program"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Begin Program]"}' http://127.0.0.1:3000/slide

# Call Start Stream Button
# curl http://127.0.0.1:8888/press/bank/1/17