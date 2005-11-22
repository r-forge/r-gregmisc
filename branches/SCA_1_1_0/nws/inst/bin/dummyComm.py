
## Copyright (c) 2005, Scientific Computing Associates, Inc.
## All rights reserved.

# these dummy classes are used by the objects that want to pretend
# they are clients of the nws server.

class DummyTransport:
    def __init__(self): return

    def write(self, data): return

class DummyConnection:
    def __init__(self, wslv = None, peerId = '[Web Interface]'):
        self.mySets, self.peer, self.wsMap = [], peerId, {}
	self.transport = DummyTransport()
        if not wslv:
            self.writeStatusLenValue = self.dummyWslv
        else:
            self.writeStatusLenValue = wslv

    def dummyWslv(self, (status, value)):
	pass

