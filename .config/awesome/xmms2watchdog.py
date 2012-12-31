#!/usr/bin/env python
import xmmsclient, os

class Watchdog():
    def __init__(self):
        self.client = xmmsclient.XMMS("watchdog")
        self.client.connect(os.getenv("XMMS_PATH"), self._disconnect)
        self.client.broadcast_playback_status(self._status_changed)
        self.client.broadcast_playback_current_id(self._status_changed)

    def main_loop(self):
        self.client.loop()

    def quit(self):
        print "Woof..."
        self.client.exit_loop()
    
    def _disconnect(self, client_instance):
        self.quit()

    def _status_changed(self, result):
        os.system("echo 'updateStatus()' | awesome-client")

if __name__ == "__main__":
    dog = Watchdog()
    dog.main_loop()
