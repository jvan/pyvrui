//------------------------------------------------------------------------------
// Interface file for the GL directory.
//
//------------------------------------------------------------------------------

/* Includes for generated wrapper code */
%{
   #include <GL/GLObject.h>
   #include <GL/GLContextData.h>
   #include <GL/GLModels.h>
%}

%feature("director") GLObject;
%feature("director") DataItem;

/* Nested classes and structures */

struct DataItem
{
   virtual ~NestedDataItem(void) { }
};

%nestedworkround GLObject::DataItem;

%{
   typedef GLObject::DataItem DataItem;
%}

/* Interface */
 
%include <GL/GLModels.h>

class GLObject
{
   public:
   GLObject(void);
   virtual ~GLObject(void);

   virtual void initContext(GLContextData& contextData) const = 0;
};

/* Automatically disable garbage collection on DataItem objects */
%pythonprepend GLContextData::addDataItem(const GLObject* thing, GLObject::DataItem* dataItem) %{
   args[1].__disown__()
%}

class GLContextData
{
   public:
   GLContextData(int sTableSize,float sWaterMark =0.9f,float sGrowRate =1.7312543);
   ~GLContextData(void);

   bool isRealized(const GLObject* thing) const;
   void addDataItem(const GLObject* thing, GLObject::DataItem* dataItem);
   template <class DataItemParam>
   DataItemParam* retrieveDataItem(const GLObject* thing);
   void removeDataItem(const GLObject* thing);
};

%extend GLContextData {
   %template(retrieveDataItem) retrieveDataItem<DataItem>;
};

