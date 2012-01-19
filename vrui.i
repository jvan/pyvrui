/******************************************************************************/
/* Interface file for the Vrui directory.                                     */
/*                                                                            */
/******************************************************************************/

/* Includes for generated wrapper code */
%{
   #include <Vrui/Vrui.h>
   #include <Vrui/Geometry.h>
   #include <Vrui/Application.h>
   #include <Vrui/Tool.h>
   #include <Vrui/LocatorTool.h> 
   /*#include <Vrui/LocatorToolAdapter.h>*/
   #include <Vrui/DraggingTool.h>
   #include <Vrui/InputDeviceFeature.h>
   #include <Misc/ConfigurationFile.h>
   #include <Misc/FunctionCalls.h>
%}

%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::InputDevice::CallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::InputDevice::ButtonCallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::InputDevice::ValuatorCallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::ToolInputAssignment::Slot;

/* Typemaps */

/* Use a python list in place of a Vrui::Point object */
%typemap(in) const Vrui::Point& {
   PyObject* x = PyList_GetItem($input, 0);
   PyObject* y = PyList_GetItem($input, 1);
   PyObject* z = PyList_GetItem($input, 2);
   double px = PyFloat_AsDouble(x);
   double py = PyFloat_AsDouble(y);
   double pz = PyFloat_AsDouble(z);
   Vrui::Point* pt = new Vrui::Point(px, py, pz);
   $1 = pt;
}

/* Free memory allocated in list -> Vrui::Point typemap */
%typemap(free) const Vrui::Point& {
   delete $1;
}

%typemap(in) const GLColor<float,4>& {
   PyObject* x = PyList_GetItem($input, 0);
   PyObject* y = PyList_GetItem($input, 1);
   PyObject* z = PyList_GetItem($input, 2);
   PyObject* a = PyList_GetItem($input, 3);
   double cx = PyFloat_AsDouble(x);
   double cy = PyFloat_AsDouble(y);
   double cz = PyFloat_AsDouble(z);
   double ca = PyFloat_AsDouble(a);
   GLColor<float,4>* color = new GLColor<float,4>(cx, cy, cz, ca);
   $1 = color;
}

%typemap(free) const GLColor<float,4>& {
   delete $1;
}


/* Import typedefs used in Vrui namespace */
%import <Vrui/Geometry.h>

/* Interface */

/* Expose Vrui functions (Vrui/Vrui.h) */
namespace Vrui {
   class ToolManager;

   /* Rendering functions */ 
   void setBackgroundColor(const GLColor<float,4>& newBackgroundColor);
   const GLColor<float,4>& getBackgroundColor(void);

   /* Widget functions */
   void setMainMenu(GLMotif::PopupMenu* newMainMenu);
   GLMotif::WidgetManager* getWidgetManager(void);
   void popdownPrimaryWidget(GLMotif::Widget* topLevel);

   /* Navigation functions */
   void setNavigationTransformation(const Point& center, Scalar radius);

   ToolManager* getToolManager(void); // Returns pointer to the tool manager

   /* Time management functions */
   double getCurrentFrameTime(void);
   double getApplicationTime(void);
   void requestUpdate(void);
}

/* Nested classes and structures */
/*%import(module="pyvrui") <Misc/CallbackData.h>*/
class ToolManagerToolCreationCallbackData : public Misc::CallbackData
{
   public:
      Vrui::Tool* tool;
      Misc::ConfigurationFileSection* cfg;
      ToolManagerToolCreationCallbackData(Vrui::Tool* tool, Misc::ConfigurationFileSection* cfg);
};

class ToolManagerToolDestructionCallbackData : public Misc::CallbackData
{
 public:
      Vrui::Tool* tool;
      ToolManagerToolDestructionCallbackData(Vrui::Tool* tool);
};

%nestedworkaround Vrui::ToolManager::ToolCreationCallbackData;
%nestedworkaround Vrui::ToolManager::ToolDestructionCallbackData;

%{
   typedef Vrui::ToolManager::ToolCreationCallbackData ToolManagerToolCreationCallbackData;
   typedef Vrui::ToolManager::ToolDestructionCallbackData ToolManagerToolDestructionCallbackData;
%}

%include <Vrui/ToolInputAssignment.h>

%template() Plugins::FactoryManager<Vrui::ToolFactory>;

%feature("director") Vrui::Tool;

%ignore Vrui::Tool::getFactory;
%include <Vrui/Tool.h>

%include <Vrui/ToolManager.h>



class LocatorToolMotionCallbackData : public Misc::CallbackData 
{ 
public:
   Vrui::LocatorTool* tool;
   const Vrui::NavTrackerState& currentTransformation;
   LocatorToolMotionCallbackData(Vrui::LocatorTool* sTool,const Vrui::NavTrackerState& sCurrentTransformation);
};
class LocatorToolButtonPressCallbackData : public Misc::CallbackData 
{ 
public:
   Vrui::LocatorTool* tool;
   const Vrui::NavTrackerState& currentTransformation;
   LocatorToolButtonPressCallbackData(Vrui::LocatorTool* sTool,const Vrui::NavTrackerState& sCurrentTransformation);

};

class LocatorToolButtonReleaseCallbackData : public Misc::CallbackData 
{ 
public:
   Vrui::LocatorTool* tool;
   const Vrui::NavTrackerState& currentTransformation;
   LocatorToolButtonReleaseCallbackData(Vrui::LocatorTool* sTool,const Vrui::NavTrackerState& sCurrentTransformation);

};

%nestedworkaround Vrui::LocatorTool::MotionCallbackData;
%nestedworkaround Vrui::LocatorTool::ButtonPressCallbackData;
%nestedworkaround Vrui::LocatorTool::ButtonReleaseCallbackData;

%{
   typedef Vrui::LocatorTool::MotionCallbackData LocatorToolMotionCallbackData;
   typedef Vrui::LocatorTool::ButtonPressCallbackData LocatorToolButtonPressCallbackData;
   typedef Vrui::LocatorTool::ButtonReleaseCallbackData LocatorToolButtonReleaseCallbackData;
%}

/*class DraggingToolDragStartCallbackData : public Misc::CallbackData */
/*{ */
   /*public:*/
      /*Vrui::DraggingTool* tool;*/
		/*const Vrui::NavTrackerState& startTransformation;*/
		/*bool rayBased;*/
		/*Vrui::Ray ray; */
      /*DraggingToolDragStartCallbackData(Vrui::DraggingTool* sTool, const Vrui::NavTrackerState& sStartTransformation);*/
/*};*/
/*class DraggingToolDragCallbackData : public Misc::CallbackData */
/*{*/
   /*public:*/
      /*Vrui::DraggingTool* tool;*/
      /*const Vrui::NavTrackerState& currentTransformation;*/
      /*const Vrui::NavTrackerState& incrementTransformation;*/
      /*DraggingToolDragCallbackData(Vrui::DraggingTool* sTool, const Vrui::NavTrackerState& sCurrentTransformation, const Vrui::NavTrackerState& sIncrementTransformation);*/
/*};*/
/*class DraggingToolDragEndCallbackData : public Misc::CallbackData */
/*{ */
   /*public:*/
      /*Vrui::DraggingTool* tool;*/
		/*const Vrui::NavTrackerState& finalTransformation;*/
		/*const Vrui::NavTrackerState& incrementTransformation;*/
      /*DraggingToolDragEndCallbackData(Vrui::DraggingTool* sTool, const Vrui::NavTrackerState& sFinalTransformation, const Vrui::NavTrackerState& sIncrementTransformation);*/
/*};*/
/*class DraggingToolIdleMotionCallbackData : public Misc::CallbackData */
/*{*/
   /*public:*/
      /*Vrui::DraggingTool* tool;*/
      /*const Vrui::NavTrackerState& currentTransformation;*/
      /*DraggingToolIdleMotionCallbackData(Vrui::DraggingTool* sTool, const Vrui::NavTrackerState& sCurrentTransformation);*/
   
/*};*/

/*%nestedworkaround Vrui::DraggingTool::DragStartCallbackData;*/
/*%nestedworkaround Vrui::DraggingTool::DragCallbackData;*/
/*%nestedworkaround Vrui::DraggingTool::DragEndCallbackData;*/
/*%nestedworkaround Vrui::DraggingTool::IdleMotionCallbackData;*/

/*%{*/
   /*typedef Vrui::DraggingTool::DragStartCallbackData DraggingToolDragStartCallbackData;*/
   /*typedef Vrui::DraggingTool::DragCallbackData DraggingToolDragCallbackData;*/
   /*typedef Vrui::DraggingTool::DragEndCallbackData DraggingToolDragEndCallbackData;*/
   /*typedef Vrui::DraggingTool::IdleMotionCallbackData DraggingToolIdleMotionCallbackData;*/
/*%}*/


%include <Vrui/LocatorTool.h>

/*%ignore Vrui::DraggingTool::StoreStateFunction;*/
/*%ignore Vrui::DraggingTool::GetNameFunction;*/
/*%include <Vrui/DraggingTool.h>*/

/* ERROR: related to private typedefs in DraggingTool */

%pythoncode %{

ToolManager.ToolCreationCallback = Callback('ToolManagerToolCreation')
ToolManager.ToolDestructionCallback = Callback('ToolManagerToolDestruction')

%}

%typemap(in) ToolManager::ToolCreationCallbackData* {
   printf("***** typemap ToolCreationCallbackData *****\n");
   $1=$input;
}


%rename(VruiApplication) Vrui::Application;
namespace Vrui
{
   class Application
   {
      public:
         Application(int& argc, char**& argv, char**& appDefaults);
         virtual ~Application(void);
         void run(void);
         /*virtual void toolCreationCallback(ToolManagerToolCreationCallbackData* cbData);*/
         /*virtual void toolDestructionCallback(ToolManagerToolDestructionCallbackData* cbData);*/
         virtual void frame(void);
         virtual void display(GLContextData& ContextData) const;
   };
}

%feature("director") Application;
%inline {
   class Application : public Vrui::Application
   {
      char** appDefaults;

      public:
         Application(int argc, char** argv)
            : appDefaults(0),
            Vrui::Application(argc, argv, appDefaults)
         { }
         virtual ~Application(void)
         { }
   };
}


%pythoncode %{
   LocatorTool.MotionCallback = Callback('LocatorToolMotion')
   LocatorTool.ButtonPressCallback = Callback('LocatorToolButtonPress')
   LocatorTool.ButtonReleaseCallback = Callback('LocatorToolButtonRelease')

   #DraggingTool.DragStartCallback = Callback('DraggingToolDragStart')
   #DraggingTool.DragCallback = Callback('DraggingToolDrag')
   #DraggingTool.DragEndCallback = Callback('DraggingToolDragEnd')
   #DraggingTool.IdleMotionCallback = Callback('DraggingToolIdleMotion')
%}
