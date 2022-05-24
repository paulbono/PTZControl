import json
import os
import xmlrpc.client
from xmlrpc.server import SimpleXMLRPCServer


class ptz_data_handler():
    def __init__(self):
        self._ptz_data_last_read_time = 0
        self.ptz_data = None
        self.file_path = 'ptz_data.json'
        
    def flush_ptz_data(self):
        with open(self.file_path, 'w') as f:
            f.write(json.dumps(self.ptz_data, indent=4))
        mod_date = os.stat(self.file_path)[8]
        self._ptz_data_last_read_time = mod_date

    def reload_ptz_data(self):
        mod_date = os.stat(self.file_path)[8]        
        if mod_date > self._ptz_data_last_read_time:
            with open(self.file_path, 'r') as f:
                self.ptz_data = json.load(f)
                self._ptz_data_last_read_time = mod_date
        
    def start_daemon(self):
        # Create server
        with SimpleXMLRPCServer(('127.0.0.1', 8001), logRequests=False, allow_none=True) as server:
            server.register_introspection_functions()
            self.reload_ptz_data()

            class ServerFunctions():
                def __init__(self, daemon_instance):
                    super.__init__
                    self.daemon_instance = daemon_instance

                # TODO could actually handle input data
                def get(self, camera, key):
                    self.daemon_instance.reload_ptz_data()
                    return self.daemon_instance.ptz_data[camera][key]
                
                def set(self, camera, key, value):
                    self.daemon_instance.reload_ptz_data()
                    self.daemon_instance.ptz_data[camera][key] = value
                    self.daemon_instance.flush_ptz_data()
                    return True

                def log(self, data):
                    self.daemon_instance.reload_ptz_data()
                    self.daemon_instance.ptz_data["log"] = self.daemon_instance.ptz_data.get("log", [])
                    self.daemon_instance.ptz_data["log"].append(xmlrpc.client.loads(data)[0][0])
                    self.daemon_instance.flush_ptz_data()
                    return True

            @server.register_function
            def stop_daemon():
                server._BaseServer__shutdown_request = True
            
            server.register_instance(ServerFunctions(self))
            
            server.serve_forever()

if __name__ == "__main__":
    daemon = ptz_data_handler()
    daemon.start_daemon()
