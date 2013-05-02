%{
   #include <GLMotif/Widget.h>
   #include <GLMotif/WidgetManager.h>
   #include <GLMotif/Container.h>
   #include <GLMotif/StyleSheet.h>
   #include <GLMotif/Label.h>

   #include <GLMotif/DragWidget.h>
   #include <GLMotif/CascadeButton.h>
   #include <GLMotif/Blind.h>

   #include <GLMotif/Popup.h>
   #include <GLMotif/PopupWindow.h>
   #include <GLMotif/Menu.h>
   #include <GLMotif/SubMenu.h>
   #include <GLMotif/PopupMenu.h>
   #include <GLMotif/Button.h>
   #include <GLMotif/Slider.h>

   #include <GLMotif/Types.h>
   #include <GLMotif/RowColumn.h>
%}

%import <GLMotif/Types.h>
%import <GLMotif/Alignment.h>

//------------------------------------------------------------------------------
// DataItem Class Interface
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// GLMotif::WidgetManager Class Interface
//
//------------------------------------------------------------------------------
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::CallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::WidgetPopCallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::WidgetMoveCallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::PoppedWidgetIterator;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::WidgetManager::EventProcessingLocker;
%include <GLMotif/WidgetManager.h>


//------------------------------------------------------------------------------
// GLMotif::StyleSheet Class Interface
//
//------------------------------------------------------------------------------
%include <GLMotif/StyleSheet.h>


//------------------------------------------------------------------------------
// GLMotif::Widget Class Interface
//
//------------------------------------------------------------------------------
%feature("director") GLMotif::Widget;
%feature("nodirector") GLMotif::Widget::getManager;
%include <GLMotif/Widget.h>


//------------------------------------------------------------------------------
// GLMotif::Blind Class Interface
// 
//------------------------------------------------------------------------------
DISABLE_GARBAGE_COLLECTION(GLMotif, Blind);
%include <GLMotif/Blind.h>


//------------------------------------------------------------------------------
// GLMotif::Container Class Interface
// GLMotif::RowColumn Class Interface
// 
//------------------------------------------------------------------------------
DISABLE_GARBAGE_COLLECTION(GLMotif, RowColumn);
%include <GLMotif/Container.h>
%include <GLMotif/RowColumn.h>


//------------------------------------------------------------------------------
// GLMotif::Popup Class Interface
// GLMotif::PopupMenu Class Interface
// GLMotif::Label Class Interface
// 
//------------------------------------------------------------------------------
DISABLE_GARBAGE_COLLECTION(GLMotif, Popup);
DISABLE_GARBAGE_COLLECTION(GLMotif, PopupWindow);
DISABLE_GARBAGE_COLLECTION(GLMotif, PopupMenu);
DISABLE_GARBAGE_COLLECTION(GLMotif, Label);

%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::PopupWindow::CallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::PopupWindow::CloseCallbackData;

%include <GLMotif/Popup.h>
%include <GLMotif/PopupMenu.h>
%include <GLMotif/PopupWindow.h>
%include <GLMotif/Label.h>


//------------------------------------------------------------------------------
// GLMotif::Button Class Interface
// 
//------------------------------------------------------------------------------
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::Button::ArmCallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::Button::CallbackData;
NESTED_CALLBACK_DATA_HELPER(GLMotif, Button, SelectCallbackData);
DISABLE_GARBAGE_COLLECTION(GLMotif, Button);
%include <GLMotif/Button.h>

class ButtonSelectCallbackData : public Misc::CallbackData
{
   public:
   GLMotif::Button* button;
   ButtonSelectCallbackData(GLMotif::Button* sButton); 
};


//------------------------------------------------------------------------------
// GLMotif::DecoratedButton Class Interface
// 
//------------------------------------------------------------------------------
%ignore GLMotif::DecoratedButton::setDecorationPosition;
%include <GLMotif/DecoratedButton.h>


//------------------------------------------------------------------------------
// GLMotif::ToggleButton Class Interface
// 
//------------------------------------------------------------------------------
NESTED_CALLBACK_DATA_HELPER(GLMotif, ToggleButton, ValueChangedCallbackData);
DISABLE_GARBAGE_COLLECTION(GLMotif, ToggleButton);
%include <GLMotif/ToggleButton.h>

class ToggleButtonValueChangedCallbackData : public Misc::CallbackData
{
   public:
      GLMotif::ToggleButton* toggle;
      bool set;

      ToggleButtonValueChangedCallbackData(GLMotif::ToggleButton* sToggle, bool sSet);
};


//------------------------------------------------------------------------------
// GLMotif::CascadeButton Class Interface
// 
//------------------------------------------------------------------------------
DISABLE_GARBAGE_COLLECTION(GLMotif, CascadeButton);
%include <GLMotif/CascadeButton.h>


//------------------------------------------------------------------------------
// GLMotif::Slider Class Interface
// 
//------------------------------------------------------------------------------
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::DragWidget::CallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::DragWidget::DraggingCallbackData;
%include <GLMotif/DragWidget.h>

NESTED_CALLBACK_DATA_HELPER(GLMotif, Slider, ValueChangedCallbackData);
DISABLE_GARBAGE_COLLECTION(GLMotif, Slider);
%ignore GLMotif::Slider::Slider(const char* sName,Container* sParent,Orientation sOrientation,GLfloat sSliderWidth,GLfloat sShaftLength,bool sManageChild =true);
%include <GLMotif/Slider.h>

class SliderValueChangedCallbackData:public Misc::CallbackData
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
   

//------------------------------------------------------------------------------
// GLMotif::Menu Class Interface
// 
//------------------------------------------------------------------------------
DISABLE_GARBAGE_COLLECTION(GLMotif, Menu);
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::Menu::CallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::Menu::EntrySelectCallbackData;
%ignore GLMotif::Menu::Menu(char const *,GLMotif::Container *,bool);
%include <GLMotif/Menu.h>


//------------------------------------------------------------------------------
// GLMotif::SubMenu Class Interface
// 
//------------------------------------------------------------------------------
DISABLE_GARBAGE_COLLECTION(GLMotif, SubMenu);
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::SubMenu::CallbackData;
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLMotif::SubMenu::EntrySelectCallbackData;
%include <GLMotif/SubMenu.h>

%pythoncode %{

Button.SelectCallback = Callback('ButtonSelect')
ToggleButton.ValueChangedCallback = Callback('ToggleButtonValueChanged')
Slider.ValueChangedCallback = Callback('SliderValueChanged')

%}

