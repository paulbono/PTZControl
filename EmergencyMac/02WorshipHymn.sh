#!/bin/bash

echo "Worship Hymn"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Worship Hymn]"}' http://127.0.0.1:3000/slide

