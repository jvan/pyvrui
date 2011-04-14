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
%template(Vectord) Geometry::Vector<double,3>;


/*%rename(VruiGeoid) Geometry::Geoid;*/
%include <Geometry/Geoid.h>

%template(Geoidd) Geometry::Geoid<double>;

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
