import json
from xmlrpc.server import SimpleXMLRPCServer
from xmlrpc.server import SimpleXMLRPCRequestHandler
from pprint import pprint


def flush_ptz_data(ptz_data):
    with open('ptz_data.json', 'w') as f:
        f.write(json.dumps(ptz_data, indent=4))

def start_daemon():
    # Create server
    with SimpleXMLRPCServer(('localhost', 8001)) as server:
        server.register_introspection_functions()
        with open('ptz_data.json', 'r') as f:
            ptz_data = json.load(f)
            
        class ServerFunctions:
            def get(self, camera, key):
                # TODO could actually handle input data
                return ptz_data[camera][key]
            
            def set(self, camera, key, value):
                ptz_data[camera][key] = value
                flush_ptz_data(ptz_data)
                return True

            def log(self, data):
                ptz_data.get(log, []).append(data)
                flush_ptz_data(ptz_data)
                return True

        @server.register_function
        def stop_daemon():
            server._BaseServer__shutdown_request = True
        
        server.register_instance(ServerFunctions())
        
        server.serve_forever()

if __name__ == "__main__":
    start_daemon()

# C:\Users\paulb\AppData\Local\Programs\Python\Python310\python.exe
# C:\Users\paulb\AppData\Local\Programs\Python\Python310\python.exe client.py
# C:\Users\paulb\AppData\Local\Programs\Python\Python310\python.exe daemon.py
# data_server.stop_daemon()
