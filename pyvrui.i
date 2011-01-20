%module pyvrui

%typemap(in) char** {
   // Check if input is a list
   if (PyList_Check($input)) {
      int size = PyList_Size($input);
      int i = 0;
      $1 = (char**)malloc((size+1)*sizeof(char*));
      for (i=0; i<size; i++) {
         PyObject* o = PyList_GetItem($input, i);
         if (PyString_Check(o)) {
            $1[i] = PyString_AsString(PyList_GetItem($input, i));
         } else {
            PyErr_SetString(PyExc_TypeError, "List must contain strings");
            free($1);
            return NULL;
         }
      }
      $1[i] = 0;
   } else {
      PyErr_SetString(PyExc_TypeError, "not a list");
      return NULL;
   }
}

%typemap(freearg) char** {
   free((char*) $1);
}

%typemap(in) (int argc, char** argv) {
   // Check if input is a list
   if (PyList_Check($input)) {
      int i;
      $1 = PyList_Size($input);
      $2 = (char**)malloc(($1+1)*sizeof(char*));
      for (i=0; i<$1; i++) {
         PyObject* o = PyList_GetItem($input, i);
         if (PyString_Check(o)) {
            $2[i] = PyString_AsString(PyList_GetItem($input, i));
         } else {
            PyErr_SetString(PyExc_TypeError, "list must contain strings");
            free($2);
            return NULL;
         }
      }
      $2[i] = 0;
   } else {
      PyErr_SetString(PyExc_TypeError, "not a list");
      return NULL;
   }
}

%typemap(freearg) (int argc, char** argv) {
   free((char*) $2);
}

%{
#include "Application.h"
%}

%include "Application.h"

