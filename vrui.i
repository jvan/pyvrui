%{
   #include <Vrui/Application.h>
   #include <Vrui/Vrui.h>
   #include <Vrui/Tool.h>
   #include <Vrui/ToolManager.h>

   #include <Misc/ConfigurationFile.h>
%}

%import <Vrui/Geometry.h>

%template(PluginsFactoryManager) Plugins::FactoryManager<Vrui::ToolFactory>;

%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::ToolInputAssignment::Slot;
%import <Vrui/ToolInputAssignment.h>

/***********************************************************
 * Vrui::Tool Class Interface
 *
 **********************************************************/
%feature("director") Vrui::Tool;
%ignore Vrui::Tool::getFactory;
%include <Vrui/Tool.h>

/***********************************************************
 * Vrui::ToolManager Class Interface
 *
 **********************************************************/
NESTED_CALLBACK_DATA_HELPER(Vrui, ToolManager, ToolCreationCallbackData);
NESTED_CALLBACK_DATA_HELPER(Vrui, ToolManager, ToolDestructionCallbackData);

%ignore Vrui::ToolManager::addClass;
%ignore Vrui::ToolManager::addAbstractClass;
%ignore Vrui::ToolManager::releaseClass;
%include <Vrui/ToolManager.h>

%pythoncode %{

ToolManager.ToolCreationCallback = Callback('ToolManagerToolCreation')
ToolManager.ToolDestructionCallback = Callback('ToolManagerToolDestruction')

%}

/***********************************************************
 * Vrui::Application Class Interface
 *
 **********************************************************/
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::Application::Tool;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::Application::ToolBase;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::Application::EventTool;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) Vrui::Application::EventToolFactory;

%ignore Vrui::Application::Application(int&, char**&, char**&);

%feature("director") Vrui::Application;

%include <Vrui/Application.h>

/***********************************************************
 * Vrui.h Function Interface
 *
 **********************************************************/
namespace Vrui {
   GLMotif::WidgetManager* getWidgetManager(void);
   void setMainMenu(GLMotif::PopupMenu* newMainMenu); 

   double getApplicationTime(void);
   double getFrameTime(void);
   double getCurrentFrameTime(void);

   void updateContinuously(void);
   void requestUpdate(void);
   void scheduleUpdate(double nextFrameTime);

   void setNavigationTransformation(const Point& center,Scalar radius);
}

