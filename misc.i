//------------------------------------------------------------------------------
// Interface file for the GLMotif directory.
//
//------------------------------------------------------------------------------

/* Includes for generated wrapper code */
%{
   #include <Misc/CallbackData.h>
   #include <GLMotif/Button.h>
   #include <GLMotif/ToggleButton.h>
%}

%feature("director") Misc::CallbackData;
%feature("director") Misc::CallbackList;

/* Interface */

%include <Misc/CallbackData.h>

/* Insert wrapper code for re-routing python callbacks */
%{

   struct CallbackTypeData
   {
      PyObject* func;
      swig_type_info* type_info;
   };

   /* Callback with signature required by CallbackList::add() method */
   static void add_PythonCallback(Misc::CallbackData* cbData, void* userData)
   {
      PyObject* obj;

      CallbackTypeData* type_data = reinterpret_cast<CallbackTypeData*>(userData);
      
      obj = SWIG_NewPointerObj(SWIG_as_voidptr(cbData), type_data->type_info, 0);

      /* Create the arguments list */
      PyObject* arglist = Py_BuildValue("(O)", obj);
      if (arglist == NULL)
      {
         printf("add_PythonCallback: Error building arglist\n");
         return;
      }

      /* Call the python method with the converted callback data */
      PyObject* result = PyEval_CallObject(type_data->func, arglist);
      if (result == NULL)
      {
         printf("add_PythonCallback: Error calling function\n");
         return;
      }

      Py_DECREF(arglist);
      Py_XDECREF(result);
      return;
   }

%}

namespace Misc {

class CallbackList
{
   public:
      CallbackList();
      ~CallbackList();

      void call(CallbackData* callbackData) const;

      /* Expose the add method, but rename it so the python_add method
         (defined below) can be used instead. */
      %rename(ORIGINAL_add) add;
      void add(CallbackType newCallbackFunction, void* newUserData);

      /* Add a method which takes a python method. This is method that
         will actually be called. */
      %extend {
         void python_add(PyObject* PyFunc)
         {
            Py_XINCREF(PyFunc);

            PyObject* callbackClassAttr = PyObject_GetAttrString(PyFunc, "__cbclass__");
            char* callbackClassName = PyString_AsString(callbackClassAttr);
            
            CallbackTypeData* type_data = new CallbackTypeData;
            type_data->func = PyFunc;
            type_data->type_info = SWIG_TypeQueryModule(&swig_module, &swig_module, callbackClassName);

            /* Call the original add method. With the re-routing function
               defined above. */
            $self->add(add_PythonCallback, (void*)type_data);
         }
      }
};

}

/* Rename the python callback so that the re-routing mechanism is 
   transparent to the user. */
%pythoncode %{
CallbackList.add = CallbackList.python_add
   
class Callback:

   def __init__(self, cb):
      self.cbclass = cb

   def __call__(self, f):
      def wrapper(self, data):
         return f(self, data)
      wrapper.__cbclass__ = self.cbclass + 'CallbackData *'
      return wrapper

%}
