#ifndef PYVRUI_APPLICATION_H
#define PYVRUI_APPLICATION_H

#include <Vrui/Application.h>
#include <GL/GLObject.h>
#include <GL/GLContextData.h>


class Application : public Vrui::Application, public GLObject
{
private:
   char** appDefaults;

public:
   Application(int argc, char** argv);
   virtual ~Application(void);

   virtual void initContext(GLContextData& contextData) const;
   virtual void display(GLContextData& contextData) const;
   virtual void frame(void);
};

#endif
