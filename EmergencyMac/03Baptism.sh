#!/bin/bash

echo "Baptism"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Baptism]"}' http://127.0.0.1:3000/slide

