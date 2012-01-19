%{
   #include <Geometry/Vector.h>
   #include <Geometry/Geoid.h>
   #include <Geometry/OrthogonalTransformation.h>
%}

/*%ignore Geometry::ComponentArray::operator[];*/
/*%ignore Geometry::ComponentArray::ComponentArray(double&);*/
/*%ignore Geometry::ComponentArray::ComponentArray(double&, double&);*/
/*%ignore Geometry::ComponentArray::ComponentArray(double&, double&, double&, double&);*/
/*%import <Geometry/ComponentArray.h>*/

namespace Geometry
{

template <class ScalarParam,int dimensionParam>
class ComponentArray
{
};

template <class ScalarParam>
class ComponentArray<ScalarParam,3>
{
      public:
         typedef ScalarParam Scalar;
         static const int dimension=3;

      public:
         ComponentArray(Scalar c0,Scalar c1,Scalar c2 =Scalar(0))
         {
            components[0]=c0;
            components[1]=c1;
            components[2]=c2;
         }
   };
}

%template() Geometry::ComponentArray<double, 3>;

/*%ignore Geometry::Vector::Vector(double&);*/
/*%ignore Geometry::Vector::Vector(double&, double&);*/
/*%ignore Geometry::Vector::Vector(double&, double&, double&, double&);*/
/*%include <Geometry/Vector.h>*/

namespace Geometry
{
   template <class ScalarParam,int dimensionParam>
   class Vector:public ComponentArray<ScalarParam,dimensionParam>
   {
      public:

      Vector(ScalarParam sX,ScalarParam sY,ScalarParam sZ);

      %extend {
         double __getitem__(int index)
         {
            return $self->components[index];
         }
      }
   };
}


%template(Vector3) Geometry::Vector<double,3>;

%typemap(in) const Geometry::Vector<double, 3>& {
   PyObject* x = PyList_GetItem($input, 0);
   PyObject* y = PyList_GetItem($input, 1);
   PyObject* z = PyList_GetItem($input, 2);
   double px = PyFloat_AsDouble(x);
   double py = PyFloat_AsDouble(y);
   double pz = PyFloat_AsDouble(z);
   Geometry::Vector<double, 3>* v = new Geometry::Vector<double, 3>(px, py, pz);
   $1 = v;
}

/* Free memory allocated in list -> Vrui::Point typemap */
%typemap(free) const Geometry::Vector<double, 3>& {
   delete $1;
}



/*%rename(VruiGeoid) Geometry::Geoid;*/
%include <Geometry/Geoid.h>

%template(Geoidd) Geometry::Geoid<double>;

%pythoncode {
   Geoid = Geoidd
}
/*%include <Geometry/OrthogonalTransformation.h>*/

namespace Geometry
{
   template <class ScalarParam,int dimensionParam>
   class OrthogonalTransformation
   {
      public:
         OrthogonalTransformation(void);
         const Vector<double,3>& getTranslation(void) const;
   };
}

%template(OrthogonalTransformationd) Geometry::OrthogonalTransformation<double,3>;
