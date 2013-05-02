%{
   #include <Vrui/Application.h>
   #include <Vrui/Vrui.h>
   #include <Vrui/Tool.h>
   #include <Vrui/ToolManager.h>
   #include <Vrui/LocatorTool.h>

   #include <Vrui/InputDeviceFeature.h>
   #include <Vrui/ToolInputAssignment.h>
   #include <Misc/ConfigurationFile.h>
   #include <Misc/FunctionCalls.h>
%}

%import <Vrui/Geometry.h>

%template(PluginsFactoryManager) Plugins::FactoryManager<Vrui::ToolFactory>;

%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::ToolInputAssignment::Slot;
%include <Vrui/ToolInputAssignment.h>


//------------------------------------------------------------------------------
// Vrui::Tool Class Interface
//
//------------------------------------------------------------------------------
%ignore Vrui::Tool::getFactory;
%feature("director") Vrui::Tool;
%include <Vrui/Tool.h>


//------------------------------------------------------------------------------
// Vrui::ToolManager Class Interface
//
//------------------------------------------------------------------------------
%ignore Vrui::ToolManager::addClass;
%ignore Vrui::ToolManager::addAbstractClass;
%ignore Vrui::ToolManager::releaseClass;

NESTED_CALLBACK_DATA_HELPER(Vrui, ToolManager, ToolCreationCallbackData);
NESTED_CALLBACK_DATA_HELPER(Vrui, ToolManager, ToolDestructionCallbackData);

%include <Vrui/ToolManager.h>

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

%pythoncode %{

ToolManager.ToolCreationCallback = Callback('ToolManagerToolCreation')
ToolManager.ToolDestructionCallback = Callback('ToolManagerToolDestruction')

%}


//------------------------------------------------------------------------------
// Vrui::LocatorTool Class Interface
//
//------------------------------------------------------------------------------
NESTED_CALLBACK_DATA_HELPER(Vrui, LocatorTool, ButtonPressCallbackData);
NESTED_CALLBACK_DATA_HELPER(Vrui, LocatorTool, ButtonReleaseCallbackData);
NESTED_CALLBACK_DATA_HELPER(Vrui, LocatorTool, MotionCallbackData);

%include <Vrui/LocatorTool.h>

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

class LocatorToolMotionCallbackData : public Misc::CallbackData 
{ 
public:
   Vrui::LocatorTool* tool;
   const Vrui::NavTrackerState& currentTransformation;
   LocatorToolMotionCallbackData(Vrui::LocatorTool* sTool,const Vrui::NavTrackerState& sCurrentTransformation);
};

%pythoncode %{
   LocatorTool.ButtonPressCallback = Callback('LocatorToolButtonPress')
   LocatorTool.ButtonReleaseCallback = Callback('LocatorToolButtonRelease')
   LocatorTool.MotionCallback = Callback('LocatorToolMotion')
%}


//------------------------------------------------------------------------------
// Vrui::Application Class Interface
//
//------------------------------------------------------------------------------
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::Application::Tool;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::Application::ToolBase;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::Application::EventTool;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::Application::EventToolFactory;

%ignore Vrui::Application::Application(int&, char**&, char**&);
%ignore Vrui::Application::toolCreationCallback(ToolManager::ToolCreationCallbackData* cbData);
%ignore Vrui::Application::toolDestructionCallback(ToolManager::ToolDestructionCallbackData* cbData); 

%feature("director") Vrui::Application;

%include <Vrui/Application.h>


//------------------------------------------------------------------------------
// Vrui.h Function Interface
//
//------------------------------------------------------------------------------
namespace Vrui {
   GLMotif::WidgetManager* getWidgetManager(void);
   void setMainMenu(GLMotif::PopupMenu* newMainMenu); 

   ToolManager* getToolManager(void);

   double getApplicationTime(void);
   double getFrameTime(void);
   double getCurrentFrameTime(void);

   void updateContinuously(void);
   void requestUpdate(void);
   void scheduleUpdate(double nextFrameTime);

   void setNavigationTransformation(const Point& center,Scalar radius);
}

