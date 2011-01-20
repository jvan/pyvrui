#include "Application.h"

Application::Application(int argc, char** argv)
   : appDefaults(0),
   Vrui::Application(argc, argv, appDefaults)
{
}

Application::~Application(void)
{
}

void Application::run(void)
{
   Vrui::Application::run();
}

void Application::initContext(GLContextData& contextData) const
{
}

void Application::display(GLContextData& contextData) const
{
}

void Application::frame(void)
{
}

