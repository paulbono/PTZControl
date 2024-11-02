#!/bin/bash

echo "START"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Start]"}' http://127.0.0.1:3000/slide

