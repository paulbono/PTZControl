@echo off


pushd C:\Users\User\git\StreamPC
git add .
git commit -m "Latest image %DATE% %TIME%"
git push origin -f
popd