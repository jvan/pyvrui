%{
   #include <GL/GLObject.h>
   #include <GL/GLContextData.h>
   #include <GL/GLModels.h>
%}

/***********************************************************
 * DataItem Class Interface
 *
 **********************************************************/
%feature("director") DataItem;

struct DataItem
{
   virtual ~DataItem(void) { }
};

/***********************************************************
 * GL::GLObject Class Interface
 *
 **********************************************************/
NESTED_WORKAROUND_HELPER(GLObject, DataItem);

%feature("director") GLObject;
%include <GL/GLObject.h>

/* Automatically disable garbage collection on DataItem objects */
%pythonprepend GLContextData::addDataItem(const GLObject* thing, GLObject::DataItem* dataItem) %{
   args[1].__disown__()
%}

%import <GL/TLSHelper.h>

/***********************************************************
 * GL::GLContextData Class Interface
 *
 **********************************************************/
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) GLContextData::CurrentContextDataChangedCallbackData;
%include <GL/GLContextData.h>

%extend GLContextData {
   %template(retrieveDataItem) retrieveDataItem<DataItem>;
};


%include <GL/GLModels.h>
