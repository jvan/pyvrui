#!/usr/bin/env python

import sys
try:
   import pyvrui
except ImportError:
   print('ERROR: could not import pyvrui')
   sys.exit(1)

from OpenGL.GL import *

class Demo(pyvrui.Application):

   def __init__(self):
      pyvrui.Application.__init__(self, sys.argv)
      self.modelAngles = [0.0, 0.0, 0.0]
      self.rotationSpeeds = [9.0, -31.0, 19.0]

   def initContext(self, contextData):
      self.displayListId = glGenLists(1)
      glNewList(self.displayListId, GL_COMPILE)

      glPushAttrib(GL_LIGHTING_BIT)
      glDisable(GL_LIGHTING)
      glLineWidth(3.0)
      glColor(1.0,1.0,1.0)
      glBegin(GL_LINES)
      glVertex(-5.0,-5.0,-5.0)
      glVertex( 5.0,-5.0,-5.0)
      glVertex(-5.0, 5.0,-5.0)
      glVertex( 5.0, 5.0,-5.0)
      glVertex(-5.0, 5.0, 5.0)
      glVertex( 5.0, 5.0, 5.0)
      glVertex(-5.0,-5.0, 5.0)
      glVertex( 5.0,-5.0, 5.0)
     
      glVertex(-5.0,-5.0,-5.0)
      glVertex(-5.0, 5.0,-5.0)
      glVertex( 5.0,-5.0,-5.0)
      glVertex( 5.0, 5.0,-5.0)
      glVertex( 5.0,-5.0, 5.0)
      glVertex( 5.0, 5.0, 5.0)
      glVertex(-5.0,-5.0, 5.0)
      glVertex(-5.0, 5.0, 5.0)
     
      glVertex(-5.0,-5.0,-5.0)
      glVertex(-5.0,-5.0, 5.0)
      glVertex( 5.0,-5.0,-5.0)
      glVertex( 5.0,-5.0, 5.0)
      glVertex( 5.0, 5.0,-5.0)
      glVertex( 5.0, 5.0, 5.0)
      glVertex(-5.0, 5.0,-5.0)
      glVertex(-5.0, 5.0, 5.0)
      glEnd()
      glPopAttrib()
   
      glEndList()

   def frame(self):
      frameTime = pyvrui.getCurrentFrameTime()
      for i in range(3):
         self.modelAngles[i] += self.rotationSpeeds[i]*frameTime
         self.modelAngles[i] = self.modelAngles[i] % 360.0
      pyvrui.requestUpdate()

   def display(self, contextData):
      glPushMatrix()

      glRotatef(self.modelAngles[0], 1.0, 0.0, 0.0)
      glRotatef(self.modelAngles[1], 0.0, 1.0, 0.0)
      glRotatef(self.modelAngles[2], 0.0, 0.0, 1.0)

      glCallList(self.displayListId)
      
      glPopMatrix()


if __name__ == '__main__':
   app = Demo()
   app.run()
