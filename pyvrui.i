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

%include "typemaps.i"
%include "macros.i"

%include "gl.i"
%include "misc.i"
%include "geometry.i"
%include "plugins.i"
%include "glmotif.i"
%include "vrui.i"
