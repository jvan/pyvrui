//------------------------------------------------------------------------------
// SWIG interface file for pyvrui project.
//
//------------------------------------------------------------------------------

%module(directors="1") pyvrui

%feature("director:except") {
   if ($error != NULL) {
      throw Swig::DirectorMethodException();
   }
}

%exception {
   try { $action }
   catch (Swig::DirectorException& e) { SWIG_fail; }
}

/* Enable directors for all exposed classes */
/*%feature("director");*/

/* Include global typemaps */
%include "typemaps.i"

/* Include interface modules */
%include "vrui.i"
%include "gl.i"
%include "misc.i"
%include "glmotif.i"
