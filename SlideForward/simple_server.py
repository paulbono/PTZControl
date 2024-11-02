import http.server
import socketserver
import json

PORT = 3000

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/relay':
            # Get the length of the incoming data
            content_length = int(self.headers['Content-Length'])

            # Read and decode the data
            post_data = self.rfile.read(content_length)
            post_data = post_data.decode('utf-8')

            # Parse the data into JSON
            try:
                data = json.loads(post_data)
                print("Received data:", data)

                # Send a response back
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(bytes(json.dumps({"received": data}), "utf-8"))
            except json.JSONDecodeError:
                self.send_response(400)
                self.end_headers()
                self.wfile.write(b"Invalid JSON")
        else:
            self.send_response(404)
            self.end_headers()

# Set up the server
with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
    print(f"Serving on port {PORT}")
    httpd.serve_forever()

