@echo off

echo Begin Program
curl -i -X POST -H "Content-Type: application/json" -d "{'tag': '[Begin Program]'}" 127.0.0.1:3000/slide