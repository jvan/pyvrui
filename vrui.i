//------------------------------------------------------------------------------
// Interface file for the Vrui directory.
//
//------------------------------------------------------------------------------

/* Includes for generated wrapper code */
%{
   #include <Vrui/Vrui.h>
   #include <Vrui/Geometry.h>
   #include <Vrui/Application.h>
%}

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

/* Import typedefs used in Vrui namespace */
%import <Vrui/Geometry.h>

/* Interface */

/* Expose Vrui functions (Vrui/Vrui.h) */
%rename(VruiApplication) Vrui::Application;
namespace Vrui {

   /* Rendering functions */ 
   void setBackgroundColor(const GLColor<float,4>& newBackgroundColor);
   const GLColor<float,4>& getBackgroundColor(void);

   /* Widget functions */
   void setMainMenu(GLMotif::PopupMenu* newMainMenu);
   GLMotif::WidgetManager* getWidgetManager(void);

   /* Navigation functions */
   void setNavigationTransformation(const Point& center, Scalar radius);

   /* Time management functions */
   double getCurrentFrameTime(void);
   void requestUpdate(void);

   class Application
   {
      public:
         Application(int& argc, char**& argv, char**& appDefaults);
         virtual ~Application(void);
         void run(void);
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
