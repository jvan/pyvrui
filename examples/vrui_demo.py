#!/usr/bin/env python

import sys
try:
   import pyvrui
except ImportError:
   print('ERROR: could not import pyvrui')
   sys.exit(1)

from OpenGL.GL import *


class Demo(pyvrui.Application, pyvrui.GLObject):

   class DataItem(pyvrui.DataItem):
      def __init__(self):
         pyvrui.DataItem.__init__(self)
         self.displayListId = glGenLists(1)

      def __del__(self):
         glDeleteLists(self.displayListId, 1)

   def __init__(self):
      pyvrui.Application.__init__(self, sys.argv)
      pyvrui.GLObject.__init__(self)

      self.modelAngles    = [0.0,   0.0,  0.0]
      self.rotationSpeeds = [9.0, -31.0, 19.0]
   
      self.rotating = True

      mainMenu = self.createMainMenu()
      pyvrui.setMainMenu(mainMenu)

      self.resetNavigationCallback(None)
      
   def initContext(self, contextData):
      dataItem = Demo.DataItem()

      contextData.addDataItem(self, dataItem)

      glNewList(dataItem.displayListId, GL_COMPILE)

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
      if not self.rotating:
         return

      frameTime = pyvrui.getCurrentFrameTime()
      for i in range(3):
         self.modelAngles[i] += self.rotationSpeeds[i]*frameTime
         self.modelAngles[i]  = self.modelAngles[i] % 360.0
      pyvrui.requestUpdate()

   def display(self, contextData):
      dataItem = contextData.retrieveDataItem(self)

      glPushMatrix()

      glRotatef(self.modelAngles[0], 1.0, 0.0, 0.0)
      glRotatef(self.modelAngles[1], 0.0, 1.0, 0.0)
      glRotatef(self.modelAngles[2], 0.0, 0.0, 1.0)
      
      glCallList(dataItem.displayListId)

      glPopMatrix()

   def createMainMenu(self):
      widgetManager = pyvrui.getWidgetManager()
      ss = widgetManager.getStyleSheet()

      mainMenuPopup = pyvrui.PopupMenu('MainMenuPopup', widgetManager)
      mainMenuPopup.setTitle('pyvrui Demo')
    
      mainMenu = pyvrui.Menu('MainMenu', mainMenuPopup, False)
      
      resetNavigationButton = pyvrui.Button('ResetNavigationButton', mainMenu, 'Reset Navigation')
      resetNavigationButton.getSelectCallbacks().add(self.resetNavigationCallback)

      rotateToggleButton = pyvrui.ToggleButton('RotateToggleButton', mainMenu, 'Rotate')
      rotateToggleButton.setToggle(True)
      rotateToggleButton.getValueChangedCallbacks().add(self.toggleRotationCallback)

      mainMenu.manageChild()

      return mainMenuPopup

   @pyvrui.Button.SelectCallback
   def resetNavigationCallback(self, cbData):
      t = [0.0, 0.0, 0.0]
      pyvrui.setNavigationTransformation(t, -10.0)

   @pyvrui.ToggleButton.ValueChangedCallback
   def toggleRotationCallback(self, cbData):
      self.rotating = cbData.toggle.getToggle()

if __name__ == '__main__':
   app = Demo()
   app.run()
