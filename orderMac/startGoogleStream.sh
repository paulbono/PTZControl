#!/bin/bash

# OBS WebSocket API settings
OBS_HOST="127.0.0.1:4455"
PASSWORD="TGV0IBXOtBXotn3j"  # Update with your WebSocket password

# Function to check OBS WebSocket API connectivity
check_obs_connection() {
    response=$(curl -s --header "Content-Type: application/json" \
                    --request POST \
                    --data '{"op": 6, "d": {"requestType": "GetVersion", "requestId": "0"}}' \
                    http://$OBS_HOST)
    
    if echo "$response" | grep -q '"status":"ok"'; then
        echo "OBS WebSocket API is reachable and working."
    else
        echo "Failed to connect to OBS WebSocket API. Please check the connection and password."
        echo "Response from OBS: $response"  # Debug line
        exit 1
    fi
}

# Function to set the OBS profile
set_obs_profile() {
    local profile_name="$1"
    curl -s --header "Content-Type: application/json" \
         --request POST \
         --data "{\"op\": 6, \"d\": {\"requestType\": \"SetCurrentProfile\", \"requestId\": \"1\", \"requestData\": {\"profileName\": \"$profile_name\"}}}" \
         http://$OBS_HOST
    echo "Profile set to $profile_name."
}

# Function to start streaming in OBS
start_streaming() {
    curl -s --header "Content-Type: application/json" \
         --request POST \
         --data '{"op": 6, "d": {"requestType": "StartStream", "requestId": "2"}}' \
         http://$OBS_HOST
    echo "Streaming started."
}

# Get list of profiles from OBS
list_profiles() {
    response=$(curl -s --header "Content-Type: application/json" \
                    --request POST \
                    --data '{"op": 6, "d": {"requestType": "GetProfileList", "requestId": "3"}}' \
                    http://$OBS_HOST)
    echo "$response" | jq -r '.d.responseData.profiles[].profileName'
}

# Main flow
check_obs_connection  # Check if API is working before proceeding

echo "Available OBS Profiles:"
list_profiles

# Prompt user to select a profile
read -p "Enter the profile name to stream: " profile_name

# Set the OBS profile and start streaming
set_obs_profile "$profile_name"
start_streaming