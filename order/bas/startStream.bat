@echo off

echo Begin Program
curl -i -X POST -H 'Content-Type: application/json' -d '{"tag": "[Begin Program]"}' localhost:3000/slide