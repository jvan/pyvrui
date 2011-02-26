import pyvrui
import math
from OpenGL.GL import *
from OpenGL.arrays.vbo import VBO
import numpy

def drawEarth(numStrips, numQuads, scaleFactor, dataItem):

   wgs84 = pyvrui.Geoidd()

   vertices = numpy.zeros(((numStrips+1)*(numQuads+1)*8), dtype=numpy.float32)
   indices =  numpy.zeros((numStrips*(numQuads+1)*2), dtype=numpy.uint16)
   
   index = 0
   for i in range(numStrips+1):
      texY = float(i)/numStrips
      lat = (float(i)/numStrips-0.5)*math.pi
      s = math.sin(lat)
      c = math.cos(lat)
      chi = math.sqrt(1.0-wgs84.e2*s*s)
      xy = wgs84.radius/chi*c*scaleFactor
      z = wgs84.radius*(1.0-wgs84.e2)/chi*s*scaleFactor
      
      for j in range(numQuads+1):
         texX = float(j)/numQuads+0.5
         lng = (2.0*math.pi*j)/numQuads
         sl = math.sin(lng)
         cl = math.cos(lng)
           
         # Texture coordinates
         vertices[index+0] = texX
         vertices[index+1] = texY
         # Normal coordinates
         vertices[index+2] = c*cl
         vertices[index+3] = c*sl
         vertices[index+4] = s
         # Position coordinates
         vertices[index+5] = xy*cl
         vertices[index+6] = xy*sl
         vertices[index+7] = z
         
         index += 8

   index = 0
   for i in range(numStrips):
      for j in range(numQuads+1):
         indices[index+0] = (i+1)*(numQuads+1)+j
         indices[index+1] = (i+0)*(numQuads+1)+j

         index += 2

   dataItem.vertexBufferObjectId = VBO(vertices)
   dataItem.indexBufferObjectId = VBO(indices, target='GL_ELEMENT_ARRAY_BUFFER')

   dataItem.vertexBufferObjectId.bind()

   glPushClientAttrib(GL_CLIENT_VERTEX_ARRAY_BIT)
   glEnableClientState(GL_VERTEX_ARRAY)
   glEnableClientState(GL_NORMAL_ARRAY)
   glEnableClientState(GL_TEXTURE_COORD_ARRAY)

   float_size = int(32 / 8)
   uint_size = int(16 / 8)
   stride = 8*float_size

   glTexCoordPointer(2, GL_FLOAT, stride, dataItem.vertexBufferObjectId+0)
   glNormalPointer  (   GL_FLOAT, stride, dataItem.vertexBufferObjectId+(2*float_size))
   glVertexPointer  (3, GL_FLOAT, stride, dataItem.vertexBufferObjectId+(5*float_size))

   dataItem.indexBufferObjectId.bind()

   shift = 0
   for i in range(numStrips):
      glDrawElements(GL_QUAD_STRIP, (numQuads+1)*2, GL_UNSIGNED_SHORT, dataItem.indexBufferObjectId+(shift*uint_size))
      shift += (numQuads+1)*2

   dataItem.vertexBufferObjectId.unbind()
   dataItem.indexBufferObjectId.unbind()

   glPopClientAttrib()

def drawGrid(numStrips, numQuads, overSample, scaleFactor):

   wgs84 = pyvrui.Geoidd()

   # Draw parallels
   for i in range(numStrips-1):
      lat = (math.pi*i)/numStrips-0.5*math.pi

      s = math.sin(lat)
      c = math.cos(lat)
      chi = math.sqrt(1.0-wgs84.e2*s*s)
      xy = wgs84.radius/chi*c*scaleFactor
      z = wgs84.radius*(1.0-wgs84.e2)/chi*s*scaleFactor
      
      glBegin(GL_LINE_LOOP)
      for j in range(numQuads*overSample):
         lng = (2.0*math.pi*j)/(numQuads*overSample)
         cl = math.cos(lng)
         sl = math.sin(lng)
         glVertex(xy*cl, xy*sl, z)
      glEnd()

   # Draw meridians
   for i in range(numQuads):
      lng = (2.0*math.pi*i)/numQuads
      cl = math.cos(lng)
      sl = math.sin(lng)

      glBegin(GL_LINE_STRIP)
      glVertex(0.0, 0.0, -wgs84.b*scaleFactor)
      for j in range(numStrips*overSample-1):
         lat = (math.pi*j)/(numStrips*overSample)-0.5*math.pi;
         s = math.sin(lat)
         c = math.cos(lat)
         chi = math.sqrt(1.0-wgs84.e2*s*s)
         xy = wgs84.radius/chi*c*scaleFactor
         z = wgs84.radius*(1.0-wgs84.e2)/chi*s*scaleFactor
         glVertex(xy*cl,xy*sl,z)
      glVertex(0.0,0.0,wgs84.b*scaleFactor)
      glEnd()
