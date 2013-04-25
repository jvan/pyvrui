#!/usr/bin/env python2.7

import sys
try:
   import pyvrui
except ImportError:
   print('ERROR: could not import pyvrui')
   sys.exit(1)

from OpenGL.GL import *
from OpenGL.arrays.vbo import VBO
import numpy
import Image

import earth_functions

def setMaterial(material):
   glMaterial(GL_FRONT_AND_BACK, GL_AMBIENT, material[0])
   glMaterial(GL_FRONT_AND_BACK, GL_DIFFUSE, material[0])
   glMaterial(GL_FRONT_AND_BACK, GL_SPECULAR, material[1])
   glMaterial(GL_FRONT_AND_BACK, GL_SHININESS, material[2])

class Application(pyvrui.Application, pyvrui.GLObject):

   class DataItem(pyvrui.DataItem):
      def __init__(self):
         pyvrui.DataItem.__init__(self)
         
         self.surfaceVertexBufferObjectId = None
         self.surfaceIndexBufferObjectId = None
         self.surfaceTextureObjectId = glGenTextures(1)
         self.displayListIdBase = glGenLists(4)

      def __del__(self):
         pass

   def __init__(self):
      pyvrui.Application.__init__(self, sys.argv)
      pyvrui.GLObject.__init__(self)

      self.showSurface = True
      self.surfaceTransparent = True
      self.showGrid = True
      self.rotateEarth = True

      self.showInnerCore = True
      self.innerCoreTransparent = True

      self.showOuterCore = True
      self.outerCoreTransparent = True

      self.surfaceMaterial = ([1.0, 1.0, 1.0, 0.333], [0.333, 0.333, 0.333], 10.0)
      self.outerCoreMaterial = ([1.0, 0.5, 0.0, 0.333], [1.0, 1.0, 1.0], 50.0)
      self.innerCoreMaterial = ([1.0, 0.0, 0.0, 0.333], [1.0, 1.0, 1.0], 50.0)

      self.mainMenu = self.createMainMenu()
      pyvrui.setMainMenu(self.mainMenu)

      self.renderDialog = self.createRenderDialog()

      self.lastFrameTime = 0.0
      self.rotationAngle = 0.0
      self.rotationSpeed = 5.0

      self.centerDisplayCallback(None)

   ############################################################   
   # Rendering methods
   #
   ############################################################   

   def initContext(self, contextData):
      dataItem = Application.DataItem()
      contextData.addDataItem(self, dataItem)

      img = Image.open('EarthTopography.png')
      try:
         # get image meta-data (dimensions) and data
         ix, iy, image = img.size[0], img.size[1], img.tostring("raw", "RGBA", 0, -1)
      except SystemError:
         # has no alpha channel, synthesize one, see the
         # texture module for more realistic handling
         ix, iy, image = img.size[0], img.size[1], img.tostring("raw", "RGBX", 0, -1)

      glBindTexture(GL_TEXTURE_2D, dataItem.surfaceTextureObjectId)

      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_BASE_LEVEL,0)
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAX_LEVEL,0)
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT)
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP)
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR)
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR)

      glTexImage2D(GL_TEXTURE_2D, 0, 3, ix, iy, 0, GL_RGBA, GL_UNSIGNED_BYTE, image)

      glBindTexture(GL_TEXTURE_2D, 0)

      # Create the Earth surface display list
      glNewList(dataItem.displayListIdBase+0, GL_COMPILE)
      earth_functions.drawEarth(90, 180, 1.0e-3, dataItem)
      glEndList()

      # Create the lat/lon grid display list
      glNewList(dataItem.displayListIdBase+1, GL_COMPILE)
      earth_functions.drawGrid(18, 36, 10, 1.0e-3)
      glEndList()

      # Create the outer core display list
      glNewList(dataItem.displayListIdBase+2, GL_COMPILE)
      pyvrui.glDrawSphereIcosahedron(3480.0, 8)
      glEndList()

      # Create the inner core display list
      glNewList(dataItem.displayListIdBase+3, GL_COMPILE)
      pyvrui.glDrawSphereIcosahedron(1221.0, 8)
      glEndList()

   def frame(self):
      newFrameTime = pyvrui.getApplicationTime()

      if self.rotateEarth:
         self.rotationAngle += self.rotationSpeed*(newFrameTime-self.lastFrameTime)
         if self.rotationAngle >= 360.0:
            self.rotationAngle -= 360.0

      pyvrui.requestUpdate()

      self.lastFrameTime = newFrameTime

   def display(self, contextData):
      dataItem = contextData.retrieveDataItem(self)

      # Save rendering state
      glPushAttrib(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_LIGHTING_BIT|GL_POLYGON_BIT)

      # Rotate all 3D models by the Earth rotation angle
      glPushMatrix()
      glRotatef(self.rotationAngle, 0.0, 0.0, 1.0)

      self._render_opaque_surfaces(dataItem)

      self._render_transparent_surfaces(dataItem)

      # Disable blending
      glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_FALSE)
      glDepthMask(GL_TRUE)
      glDisable(GL_BLEND)
    
      glPopMatrix()
      glPopAttrib()

   def _render_opaque_surfaces(self, dataItem):
      glDisable(GL_CULL_FACE)

      if self.showSurface and not self.surfaceTransparent:
         self._render_earth(dataItem)

      if self.showOuterCore and not self.outerCoreTransparent:
         setMaterial(self.outerCoreMaterial)
         glCallList(dataItem.displayListIdBase+2)

      if self.showInnerCore and not self.innerCoreTransparent:
         setMaterial(self.innerCoreMaterial)
         glCallList(dataItem.displayListIdBase+3)

      glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_FALSE)

   def _render_transparent_surfaces(self, dataItem):
      glEnable(GL_CULL_FACE)

      # Enable lighting to render transparent surfaces
      glEnable(GL_LIGHTING)

      # Render transparent surfaces in back-to-front order
      glEnable(GL_BLEND)
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
      glDepthMask(GL_FALSE)
      glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE)

      # Render back parts of surfaces
      glCullFace(GL_FRONT)

      if self.showSurface and self.surfaceTransparent:
         self._render_earth(dataItem)
                 
      if self.showGrid:
         glDisable(GL_LIGHTING)
         glBlendFunc(GL_SRC_ALPHA, GL_ONE)
         glColor4f(0.0, 1.0, 0.0, 0.1)

         # Call the lat/lon display list
         glCallList(dataItem.displayListIdBase+1)

         glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
         glEnable(GL_LIGHTING)

      if self.showOuterCore and self.outerCoreTransparent:
         setMaterial(self.outerCoreMaterial)
         glCallList(dataItem.displayListIdBase+2)

      if self.showInnerCore and self.innerCoreTransparent:
         setMaterial(self.innerCoreMaterial)
         glCallList(dataItem.displayListIdBase+3)

      #Render front parts of surfaces
      glCullFace(GL_BACK)

      if self.showInnerCore and self.innerCoreTransparent:
         setMaterial(self.innerCoreMaterial)
         glCallList(dataItem.displayListIdBase+3)

      if self.showOuterCore and self.outerCoreTransparent:
         setMaterial(self.outerCoreMaterial)
         glCallList(dataItem.displayListIdBase+2)

      if self.showSurface and self.surfaceTransparent:
         self._render_earth(dataItem)

   def _render_earth(self, dataItem):
      # Set up rendering state to render Earth's surface
      glEnable(GL_TEXTURE_2D)
      glBindTexture(GL_TEXTURE_2D, dataItem.surfaceTextureObjectId)
      glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE)
      glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL,GL_SEPARATE_SPECULAR_COLOR)

      setMaterial(self.surfaceMaterial) 

      # Call the Earth's surface display list
      glCallList(dataItem.displayListIdBase+0)
      
      # Reset rendering state
      glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SINGLE_COLOR)
      glBindTexture(GL_TEXTURE_2D, 0)
      glDisable(GL_TEXTURE_2D)

   ############################################################   
   # UI methods
   #
   ############################################################   

   def createMainMenu(self):
      mainMenuPopup = pyvrui.PopupMenu('MainMenuPopup', pyvrui.getWidgetManager())
      mainMenuPopup.setTitle('Interactive Globe')

      mainMenu = pyvrui.Menu('MainMenu', mainMenuPopup, False)

      renderTogglesCascade = pyvrui.CascadeButton('RenderTogglesCascade', mainMenu, 'Rendering Modes')
      renderTogglesCascade.setPopup(self.createRenderTogglesMenu())

      rotateEarthToggle = pyvrui.ToggleButton('RotateEarthToggle', mainMenu, 'Rotate Earth')
      rotateEarthToggle.setToggle(self.rotateEarth)
      rotateEarthToggle.getValueChangedCallbacks().add(self.menuToggleSelectCallback)
   
      centerDisplayButton = pyvrui.Button('CenterDisplayButton', mainMenu, 'Center Display')
      centerDisplayButton.getSelectCallbacks().add(self.centerDisplayCallback)

      showRenderDialogToggle = pyvrui.ToggleButton('ShowRenderDialogToggle', mainMenu, 'Show Render Dialag')
      showRenderDialogToggle.setToggle(False)
      showRenderDialogToggle.getValueChangedCallbacks().add(self.menuToggleSelectCallback)

      mainMenu.manageChild()

      return mainMenuPopup

   def createRenderTogglesMenu(self):
      renderTogglesMenuPopup = pyvrui.Popup('RenderTogglesMenuPopup', pyvrui.getWidgetManager())

      renderTogglesMenu = pyvrui.SubMenu('RenderTogglesMenu', renderTogglesMenuPopup, False)

      showSurfaceToggle = pyvrui.ToggleButton('ShowSurfaceToggle', renderTogglesMenu, 'Show Surface')
      showSurfaceToggle.setToggle(self.showSurface)
      showSurfaceToggle.getValueChangedCallbacks().add(self.menuToggleSelectCallback)

      surfaceTransparentToggle = pyvrui.ToggleButton('SurfaceTransparentToggle', renderTogglesMenu, 'Surface Transparent')
      surfaceTransparentToggle.setToggle(self.surfaceTransparent)
      surfaceTransparentToggle.getValueChangedCallbacks().add(self.menuToggleSelectCallback)

      showGridToggle = pyvrui.ToggleButton('ShowGridToggle', renderTogglesMenu, 'Show Grid')
      showGridToggle.setToggle(self.showGrid)
      showGridToggle.getValueChangedCallbacks().add(self.menuToggleSelectCallback)

      renderTogglesMenu.manageChild()

      return renderTogglesMenuPopup

   def createRenderDialog(self):

      def createCustomToggle(name, parent, label):
         toggle = pyvrui.ToggleButton(name, parent, label)
         toggle.setBorderWidth(0.0)
         toggle.setMarginWidth(0.0)
         #TODO: toggle.setHAlignment(...)
         return toggle
         
      print 'Application.createRenderDialog'
      ss = pyvrui.getWidgetManager().getStyleSheet()
     
      renderDialogPopup = pyvrui.PopupWindow('RenderDialogPopup', pyvrui.getWidgetManager(), 'Display Settings')
      
      renderDialog = pyvrui.RowColumn('RenderDialog', renderDialogPopup, False)
      renderDialog.setOrientation(pyvrui.RowColumn.VERTICAL)
      renderDialog.setPacking(pyvrui.RowColumn.PACK_TIGHT)
      renderDialog.setNumMinorWidgets(2)

      showSurfaceToggle = createCustomToggle('ShowSurfaceToggle', renderDialog, 'Show Surface')
      showSurfaceToggle.setToggle(self.showSurface)
      showSurfaceToggle.getValueChangedCallbacks().add(self.menuToggleSelectCallback)

      pyvrui.Blind('Blind1', renderDialog)

      pyvrui.Label('SurfaceTransparencyLabel', renderDialog, 'Surface Transparency')
     
      print ' -- ss.fontHeight={0}'.format(ss.fontHeight)

      surfaceTransparencySlider = pyvrui.Slider('SurfaceTransparencySlider', renderDialog, pyvrui.Slider.HORIZONTAL, 2.0)
      surfaceTransparencySlider.setValueRange(0.0, 1.0, 0.001)
      surfaceTransparencySlider.setValue(self.surfaceMaterial[0][3])
      surfaceTransparencySlider.getValueChangedCallbacks().add(self.sliderCallback)

      pyvrui.Label('GridTransparencyLabel', renderDialog, 'Grid Transparency')

      gridTransparencySlider = pyvrui.Slider('GridTransparencySlider', renderDialog, pyvrui.Slider.HORIZONTAL, 2.0)
      gridTransparencySlider.setValueRange(0.0, 1.0, 0.001)
      gridTransparencySlider.setValue(0.1)
      gridTransparencySlider.getValueChangedCallbacks().add(self.sliderCallback)

      showOuterCoreToggle = createCustomToggle('ShowOuterCoreToggle', renderDialog, 'Show Outer Core')
      showOuterCoreToggle.setToggle(self.showOuterCore)
      showOuterCoreToggle.getValueChangedCallbacks().add(self.menuToggleSelectCallback)

      pyvrui.Blind('Blind2', renderDialog)

      pyvrui.Label('OuterCoreTransparencyLabel', renderDialog, 'Outer Core Transparency')

      outerCoreTransparencySlider = pyvrui.Slider('OuterCoreTransparencySlider', renderDialog, pyvrui.Slider.HORIZONTAL, 2.0)
      outerCoreTransparencySlider.setValueRange(0.0, 1.0, 0.001)
      outerCoreTransparencySlider.setValue(self.outerCoreMaterial[0][3])
      outerCoreTransparencySlider.getValueChangedCallbacks().add(self.sliderCallback)
      
      showInnerCoreToggle = createCustomToggle('ShowInnerCoreToggle', renderDialog, 'Show Inner Core')
      showInnerCoreToggle.setToggle(self.showInnerCore)
      showInnerCoreToggle.getValueChangedCallbacks().add(self.menuToggleSelectCallback)

      pyvrui.Blind('Blind2', renderDialog)

      pyvrui.Label('InnerCoreTransparencyLabel', renderDialog, 'Inner Core Transparency')

      innerCoreTransparencySlider = pyvrui.Slider('InnerCoreTransparencySlider', renderDialog, pyvrui.Slider.HORIZONTAL, 2.0)
      innerCoreTransparencySlider.setValueRange(0.0, 1.0, 0.001)
      innerCoreTransparencySlider.setValue(self.innerCoreMaterial[0][3])
      innerCoreTransparencySlider.getValueChangedCallbacks().add(self.sliderCallback)

      renderDialog.manageChild()

      return renderDialogPopup

   ############################################################   
   # Callback methods
   #
   ############################################################   

   @pyvrui.Button.SelectCallback
   def centerDisplayCallback(self, cbdata):
      print 'Application.centerDisplayCallback'
      pyvrui.setNavigationTransformation([0.0, 0.0, 0.0], 3.0*6.4e3)

   @pyvrui.ToggleButton.ValueChangedCallback
   def menuToggleSelectCallback(self, cbdata):
      print 'Application.menuToggleSelectCallback'
      print ' -- toggle name={0}'.format(cbdata.toggle.getName())
   
      name = cbdata.toggle.getName()
   
      if name == 'ShowSurfaceToggle':
         self.showSurface = cbdata.set
      elif name == 'ShowGridToggle':
         self.showGrid = cbdata.set
      elif name == 'SurfaceTransparentToggle':
         self.surfaceTransparent = cbdata.set
      elif name == 'ShowOuterCoreToggle':
         self.showOuterCore = cbdata.set
      elif name == 'ShowOuterCoreTransparentToggle':
         self.outerCoreTransparent = cbdata.set
      elif name == 'ShowInnerCoreToggle':
         self.showInnerCore = cbdata.set
      elif name == 'ShowInnerCoreTransparentToggle':
         self.innerCoreTransparent = cbdata.set
      elif name == 'RotateEarthToggle':
         self.rotateEarth = cbdata.set
         if self.rotateEarth:
            self.lastFrameTime = pyvrui.getApplicationTime()
         print ' -- self.rotateEarth={0}'.format(self.rotateEarth)
      elif name == 'ShowRenderDialogToggle':
         if cbdata.set:
            print ' -- pop up dialog'
            pyvrui.getWidgetManager().popupPrimaryWidget(
                                       self.renderDialog,
                                       pyvrui.getWidgetManager().calcWidgetTransformation(self.mainMenu))
         else:
            print ' -- pop down dialog'
            pyvrui.popdownPrimaryWidget(self.renderDialog)

   @pyvrui.Slider.ValueChangedCallback
   def sliderCallback(self, cbdata):
      print 'Application.sliderCallback'

      name = cbdata.slider.getName()

      print ' -- name={0}'.format(name)
      print ' -- alpha={0}'.format(cbdata.value)

      if name == 'SurfaceTransparencySlider':
         self.surfaceTransparent = cbdata.value < 1.0
         self.surfaceMaterial[0][3] = cbdata.value
      elif name == 'GridTransparencySlider':
         pass
      elif name == 'OuterCoreTransparencySlider':
         self.outerCoreTransparent = cbdata.value < 1.0
         self.outerCoreMaterial[0][3] = cbdata.value
      elif name == 'InnerCoreTransparencySlider':
         self.innerCoreTransparent = cbdata.value < 1.0
         self.innerCoreMaterial[0][3] = cbdata.value
   
if __name__ == '__main__':
   app = Application()
   app.run()
