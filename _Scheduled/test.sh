#!/bin/bash

# Script to create a file called itworked.txt with the current date and time
echo "This file was created by test.sh script!" > itworked.txt
echo "Current date and time: $(date)" >> itworked.txt
echo "File itworked.txt has been created successfully with the current timestamp."
