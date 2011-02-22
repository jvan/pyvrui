//------------------------------------------------------------------------------
// Interface file for the GLMotif directory.
//
//------------------------------------------------------------------------------

/* Includes for generated wrapper code */
%{
   #include <VruiSupport/GLMotif/GLMotif>
%}

%import <GLMotif/Types.h>
%import <GLMotif/Alignment.h>

%feature("director") GLMotif::Widget;

/* Disable nested class warning messages */
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::Button::ArmCallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::Button::SelectCallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::Menu::CallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::Menu::EntrySelectCallbackData;

/* GLMotif objects are managed by their parent container objects. 
   Therefore the thisown property on each class should be automatically
   set to False when constructed. */
%pythonappend GLMotif::Button::Button %{
   self.thisown = False
%}
%pythonappend GLMotif::ToggleButton::ToggleButton %{
   self.thisown = False
%}
%pythonappend GLMotif::PopupMenu::PopupMenu %{
   self.thisown = False
%}
%pythonappend GLMotif::Menu::Menu %{
   self.thisown = False
%}


/* Nested classes and structures */

class ButtonCallbackData : public Misc::CallbackData
{
   public:
   GLMotif::Button* button;
   ButtonCallbackData(GLMotif::Button* sButton); /* : button(sButton) { }*/
};

class ToggleButtonValueChangedCallbackData : public Misc::CallbackData
{
   public:
      GLMotif::ToggleButton* toggle;
      bool set;

      ToggleButtonValueChangedCallbackData(GLMotif::ToggleButton* sToggle, bool sSet);
};


%nestedworkaround GLMotif::Button::CallbackData;
%nestedworkaround GLMotif::ToggleButton::ValueChangedCallback;

%{
   typedef GLMotif::Button::CallbackData ButtonCallbackData;
   typedef GLMotif::ToggleButton::ValueChangedCallbackData ToggleButtonValueChangedCallbackData;
%}

/* Interface */

namespace GLMotif {

   class Container;
   
   class Widget
   {
      public:
         enum BorderType
         {
            PLAIN,RAISED,LOWERED
         };
         Widget(const char* sName, Container* sParent, bool sManageChild=true);
         virtual ~Widget(void);
         void manageChild();
         virtual Vector calcNaturalSize(void) const=0;
   };

   class Container : public Widget
   {
      public:
         Container(const char* sName,Container* sParent,bool manageChild=true);
         virtual void addChild(Widget* newChild) =0;
   };

}


%include <GLMotif/WidgetManager.h>
%include <GLMotif/RowColumn.h>
%include <GLMotif/Popup.h>
%include <GLMotif/Label.h>

namespace GLMotif {

class Button
{
   public:
      Button(const char* sName,Container* sParent,const char* sLabel,bool manageChild=true);

      Misc::CallbackList& getSelectCallbacks(void); 
};

class ToggleButton
{
   public:
      ToggleButton(const char* sName,Container* sParent,const char* sLabel,bool manageChild =true);
      Misc::CallbackList& getValueChangedCallbacks(void);

      void setToggle(bool newSet);
      bool getToggle() const;
};

}

%include <GLMotif/Menu.h>
%include <GLMotif/PopupMenu.h>

%pythoncode %{

Button.SelectCallback = Callback('ButtonSelect')
ToggleButton.ValueChangedCallback = Callback('ToggleButtonValueChanged')

%}
