%define DISABLE_GARBAGE_COLLECTION(namespace, classname)
%pythonappend namespace::classname::classname %{
   self.thisown = False
%}
%enddef

%define NESTED_WORKAROUND_HELPER(parentclass, classname)
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) parentclass::classname;
%nestedworkaround parentclass::classname;
%{
   typedef parentclass::classname classname;
%}
%enddef

%define NESTED_CALLBACK_DATA_HELPER(namespace, parentclass, classname)
%warnfilter(SWIGWARN_PARSE_NAMED_NESTED_CLASS) namespace::parentclass::classname;
%nestedworkaround namespace::parentclass::classname;
%{
   typedef namespace::parentclass::classname parentclass##classname;
%}
%enddef
