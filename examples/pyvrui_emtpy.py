#!/usr/bin/env python2.7
#
# Empty VRUI application.
#
# This program does nothing except initialize and run a VRUI application
# object. It is used to verify that the VRUI environment is working
# properly (menus are present, tools can be created/destroyed, etc).
#
import sys

try:
   import pyvrui
except ImportError:
   print('ERROR: could not import pyvrui')
   sys.exit(1)

class Demo(pyvrui.Application):

   def __init__(self):
      pyvrui.Application.__init__(self, sys.argv)

   def frame(self):
      pass

   def display(self, contextData):
      pass

if __name__ == '__main__':
   app = Demo()
   app.run()
