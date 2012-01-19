/******************************************************************************/
/* Interface file for the GLMotif directory.                                  */
/*                                                                            */
/******************************************************************************/

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

%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::CallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::WidgetPopCallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::WidgetMoveCallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::PoppedWidgetIterator;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::EventProcessingLocker;

%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::PopupWindow::CallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::PopupWindow::CloseCallbackData;


/* GLMotif objects are managed by their parent container objects. 
   Therefore the thisown property on each class should be automatically
   set to False when constructed. */
%pythonappend GLMotif::Button::Button %{
   self.thisown = False
%}
%pythonappend GLMotif::ToggleButton::ToggleButton %{
   self.thisown = False
%}
%pythonappend GLMotif::CascadeButton::CascadeButton %{
   self.thisown = False
%}
%pythonappend GLMotif::Slider::Slider %{
   self.thisown = False
%}
%pythonappend GLMotif::Popup::Popup %{
   self.thisown = False
%}
%pythonappend GLMotif::PopupMenu::PopupMenu %{
   self.thisown = False
%}
%pythonappend GLMotif::PopupWindow::PopupWindow %{
   self.thisown = False
%}
%pythonappend GLMotif::RowColumn::RowColumn %{
   self.thisown = False
%}
%pythonappend GLMotif::Blind::Blind %{
   self.thisown = False
%}
%pythonappend GLMotif::Label::Label %{
   self.thisown = False
%}
%pythonappend GLMotif::Menu::Menu %{
   self.thisown = False
%}
%pythonappend GLMotif::SubMenu::SubMenu %{
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

class SliderValueChangedCallbackData : public Misc::CallbackData
{
   public:
      enum ChangeReason 
      {
         CLICKED,DRAGGED
      };

      GLMotif::Slider* slider;
      ChangeReason reason;
      GLfloat value;

      SliderValueChangedCallbackData(GLMotif::Slider* sSlider,ChangeReason sReason,GLfloat sValue);
};


%nestedworkaround GLMotif::Button::CallbackData;
%nestedworkaround GLMotif::ToggleButton::ValueChangedCallbackData;
%nestedworkaround GLMotif::Slider::ValueChangedCallbackData;

%{
   typedef GLMotif::Button::CallbackData ButtonCallbackData;
   typedef GLMotif::ToggleButton::ValueChangedCallbackData ToggleButtonValueChangedCallbackData;
   typedef GLMotif::Slider::ValueChangedCallbackData SliderValueChangedCallbackData;
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

         virtual void setBorderWidth(GLfloat newBorderWidth);
         virtual void setBorderType(BorderType newBorderType);
         virtual void setBorderColor(const Color& newBorderColor);
         virtual void setBackgroundColor(const Color& newBackgroundColor);
         virtual void setForegroundColor(const Color& newForegroundColor);

         const char* getName(void) const;
   };

   class Container : public Widget
   {
      public:
         Container(const char* sName,Container* sParent,bool manageChild=true);
         virtual void addChild(Widget* newChild) =0;
   };

}

%include <GLMotif/WidgetManager.h>
%include <GLMotif/StyleSheet.h>
%include <GLMotif/RowColumn.h>
%include <GLMotif/Popup.h>
%include <GLMotif/Blind.h>
%include <GLMotif/Label.h>

namespace GLMotif {

class SubMenu : public RowColumn
{
   public:
      SubMenu(const char* sName,Container* sParent,bool manageChild =true);
};

class Button : public Label
{
   public:
      Button(const char* sName,Container* sParent,const char* sLabel,bool manageChild=true);

      GLfloat getMarginWidth(void) const;
      void setMarginWidth(GLfloat newMarginWidth);
      void setHAlignment(GLFont::HAlignment newHAlignment);
      void setVAlignment(GLFont::VAlignment newVAlignment);
      /*const char* getLabel(void) const;*/
      /*virtual void setLabel(const char* newLabel); */

      Misc::CallbackList& getSelectCallbacks(void); 
};

class DecoratedButton : public Button { };

class ToggleButton : public DecoratedButton
{
   public:
      ToggleButton(const char* sName,Container* sParent,const char* sLabel,bool manageChild =true);
      Misc::CallbackList& getValueChangedCallbacks(void);

      void setToggle(bool newSet);
      bool getToggle() const;
};

class CascadeButton : public DecoratedButton
{
   public:
      CascadeButton(const char* sName,Container* sParent,const char* sLabel,bool manageChild =true);

      void setPopup(Popup* newPopup);
};

class DragWidget : public Widget { };

}

%include <GLMotif/Menu.h>
%include <GLMotif/PopupMenu.h>
%include <GLMotif/PopupWindow.h>

%ignore GLMotif::Slider::Slider(const char* sName,Container* sParent,Orientation sOrientation,GLfloat sSliderWidth,GLfloat sShaftLength,bool sManageChild =true);
%include <GLMotif/Slider.h>

%pythoncode %{

Button.SelectCallback = Callback('Button')
ToggleButton.ValueChangedCallback = Callback('ToggleButtonValueChanged')
Slider.ValueChangedCallback = Callback('SliderValueChanged')

%}
