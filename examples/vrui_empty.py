#!/usr/bin/env python

import sys
try:
   import pyvrui
except ImportError:
   print('ERROR: could not import pyvrui')
   sys.exit(1)

class Demo(pyvrui.Application):
   def __init__(self):
      pyvrui.Application.__init__(self, sys.argv)

if __name__ == '__main__':
   app = Demo()
   app.run()
