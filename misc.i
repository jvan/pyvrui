/******************************************************************************/
/* Interface file for the Misc directory.                                     */
/*                                                                            */
/******************************************************************************/

/* Includes for generated wrapper code */
%{
   #include <Misc/CallbackData.h>
   #include <GLMotif/Button.h>
   #include <GLMotif/ToggleButton.h>
   #include <Vrui/ToolManager.h>
   #include <Vrui/LocatorTool.h>
   #include <Vrui/DraggingTool.h>
   #include <typeinfo>
%}

%feature("director") Misc::CallbackData;
%feature("director") Misc::CallbackList;


/* Interface */

%include <Misc/CallbackData.h>

%inline %{

class LocatorToolCreationCallbackData : public Misc::CallbackData
{
   public:
   Vrui::LocatorTool* tool;
   LocatorToolCreationCallbackData(Vrui::LocatorTool* sTool) : tool(sTool) { }
};

class DraggingToolCreationCallbackData : public Misc::CallbackData
{
   public:
   Vrui::DraggingTool* tool;
   DraggingToolCreationCallbackData(Vrui::DraggingTool* sTool) : tool(sTool) { }
};

%}


/* Insert wrapper code for re-routing python callbacks */
%{

   struct CallbackTypeData
   {
      PyObject* func;
      swig_type_info* type_info;
      PyObject* additional_data;
   };

   /* I think it's safe to say that I am not 100% pleased with this solution. */
   PyObject* shenanigans(Misc::CallbackData* cbData, CallbackTypeData* typeData)
   {
      PyObject* obj = NULL;
      if (strcmp(typeData->type_info->str, "ToolManagerToolCreationCallbackData *") == 0)
      {
         /* Cast the callback data to ToolCreationCallbakData type */
         Vrui::ToolManager::ToolCreationCallbackData* data = dynamic_cast<Vrui::ToolManager::ToolCreationCallbackData*>(cbData);
         
         /* Determine the type of tool being created */
         std::string toolName(typeid(*(data->tool)).name());
         if (toolName.find("LocatorTool") != -1)
         {
            LocatorToolCreationCallbackData* cbd = new LocatorToolCreationCallbackData((Vrui::LocatorTool*)data->tool);
            swig_type_info* ti = SWIG_TypeQueryModule(&swig_module, &swig_module,"LocatorToolCreationCallbackData *");
            obj = SWIG_NewPointerObj(SWIG_as_voidptr(cbd), ti, 0);
         }
         else if (toolName.find("DraggingTool") != -1)
         {
            DraggingToolCreationCallbackData* cbd = new DraggingToolCreationCallbackData((Vrui::DraggingTool*)data->tool);
            swig_type_info* ti = SWIG_TypeQueryModule(&swig_module, &swig_module, "DraggingToolCreationCallbackData *");
            obj = SWIG_NewPointerObj(SWIG_as_voidptr(cbd), ti, 0);
         }
      
      }
      else if (strcmp(typeData->type_info->str, "ToolManagerToolDestructionCallbackData *") == 0)
      {
         /* Tool desctruction  */
      }
      else { }

      return obj; 
   }

   /* Callback with signature required by CallbackList::add() method */
   static void add_PythonCallback(Misc::CallbackData* cbData, void* userData)
   {
      PyObject* obj;

      CallbackTypeData* type_data = reinterpret_cast<CallbackTypeData*>(userData);
         
      obj = shenanigans(cbData, type_data);
      if (obj == NULL)
      {
         obj = SWIG_NewPointerObj(SWIG_as_voidptr(cbData), type_data->type_info, 0);
      }
      
      /* Create the arguments list */
      PyObject* arglist; /* = Py_BuildValue("(O)", obj);*/

      /*char* data = PyString_AsString(type_data->additional_data);*/
      if (type_data->additional_data != NULL)
      {
         arglist = Py_BuildValue("(OO)", obj, type_data->additional_data);
      }
      else
      {
         arglist = Py_BuildValue("(O)", obj);
      }

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
         void python_add(PyObject* PyFunc, PyObject* data=NULL)
         {
            Py_XINCREF(PyFunc);

            PyObject* callbackClassAttr = PyObject_GetAttrString(PyFunc, "__cbclass__");
            char* callbackClassName = PyString_AsString(callbackClassAttr);
            
            CallbackTypeData* type_data = new CallbackTypeData;
            type_data->func = PyFunc;
            type_data->type_info = SWIG_TypeQueryModule(&swig_module, &swig_module, callbackClassName);
            type_data->additional_data = data;

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
      print 'Callback.cb={0}'.format(cb)

   def __call__(self, f):
      def wrapper(self, *args):
         return f(self, *args)
      wrapper.__cbclass__ = self.cbclass + 'CallbackData *'
      return wrapper

%}
