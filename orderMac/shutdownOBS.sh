#!/bin/bash

# OBS WebSocket API settings
OBS_HOST="localhost:4455"
PASSWORD="TGV0IBXOtBXotn3j"  # Update if a password is set

# Function to authenticate and get a session token
authenticate() {
    # Fetch a session token if authentication is required
    auth_response=$(curl -s --header "Content-Type: application/json" \
                          --request POST \
                          --data "{\"jsonrpc\": \"2.0\", \"method\": \"Auth\", \"params\": {\"password\": \"$PASSWORD\"}, \"id\": \"1\"}" \
                          http://$OBS_HOST)

    # Extract session token
    session_token=$(echo "$auth_response" | grep -o '"result":{"auth":".*"' | cut -d '"' -f5)
    
    if [ -n "$session_token" ]; then
        echo "Authenticated. Session token received."
        return 0
    else
        echo "Failed to authenticate. Please check the password."
        return 1
    fi
}

# Function to save the current scene collection
save_scene_collection() {
    curl -s --header "Content-Type: application/json" \
         --request POST \
         --data "{\"jsonrpc\": \"2.0\", \"method\": \"SaveSceneCollection\", \"id\": \"2\", \"params\": {\"auth\": \"$session_token\"}}" \
         http://$OBS_HOST
    echo "Scene collection save command sent."
}

# Function to shutdown OBS
shutdown_obs() {
    curl -s --header "Content-Type: application/json" \
         --request POST \
         --data "{\"jsonrpc\": \"2.0\", \"method\": \"Shutdown\", \"id\": \"3\", \"params\": {\"auth\": \"$session_token\"}}" \
         http://$OBS_HOST
    echo "Shutdown command sent to OBS."
}

# Authenticate and run commands if successful
if authenticate; then
    save_scene_collection
    shutdown_obs
else
    echo "Cannot proceed without authentication."
fi
