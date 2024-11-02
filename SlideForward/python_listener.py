from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Python listener on port 3000
@app.route('/slide', methods=['POST'])
def relay_to_node():
    data = request.get_json()  # Get the JSON data from the POST request
    if not data:
        app.logger.error("No data received")
        return jsonify({"error": "No data received"}), 400
    
    app.logger.info(f"Received data: {data}")

    # Forward the request to the Node.js server on port 3001
    try:
        node_response = requests.post('http://localhost:3001/slide', json=data)
        return node_response.content, node_response.status_code
    except requests.exceptions.RequestException as e:
        app.logger.error(f"Failed to relay to Node.js server: {str(e)}")
        return f"Failed to relay to Node.js server: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
