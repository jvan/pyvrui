// Convert python list to Vrui::Application constructor args
//    python input type: list
//    expected c++ type: (int&, char**&)
%typemap(in) (int& argc, char**& argv) {
   /* Check if input is a list */
   if (PyList_Check($input)) {
      int i;
      int num_args = (int)PyList_Size($input);
      char** args = (char**)malloc((num_args+1)*sizeof(char*));
      for (i=0; i<num_args; i++) {
         PyObject* o = PyList_GetItem($input, i);
         if (PyString_Check(o)) {
            args[i] = PyString_AsString(PyList_GetItem($input, i));
         } else {
            PyErr_SetString(PyExc_TypeError, "list must contain strings");
            free(args);
            return NULL;
         }
      }
      args[i] = 0;
      $1 = &num_args;
      $2 = &args;
      /*free(args);*/
   } else {
      PyErr_SetString(PyExc_TypeError, "not a list");
      return NULL;
   }
}

// Convert python list to Geometry::Vector object
/%typemap(in) const Geometry::Vector<double, 3>& {
   PyObject* x = PyList_GetItem($input, 0);
   PyObject* y = PyList_GetItem($input, 1);
   PyObject* z = PyList_GetItem($input, 2);
   double px = PyFloat_AsDouble(x);
   double py = PyFloat_AsDouble(y);
   double pz = PyFloat_AsDouble(z);
   $1 = new Geometry::Vector<double, 3>(px, py, pz);
}

%typemap(free) const Geometry::Vector<double, 3>& {
   delete $1;
}


// Convert python list to Vrui::Point object
%typemap(in) const Vrui::Point& {
   PyObject* x = PyList_GetItem($input, 0);
   PyObject* y = PyList_GetItem($input, 1);
   PyObject* z = PyList_GetItem($input, 2);
   double px = PyFloat_AsDouble(x);
   double py = PyFloat_AsDouble(y);
   double pz = PyFloat_AsDouble(z);
   $1 = new Vrui::Point(px, py, pz);
}

%typemap(free) const Vrui::Point& {
   delete $1;
}

%typemap(in) GLfloat {
   $1 = PyFloat_AsDouble($input);
}

%typemap(out) GLfloat {
   $result = PyFloat_FromDouble($1);
}

%typemap(typecheck) GLfloat = float;

%typemap(in) GLsizei {
   $1 = PyLong_AsLong($input);
}

