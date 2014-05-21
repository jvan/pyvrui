%{
   #include <Geometry/Geoid.h>
   #include <Geometry/OrthogonalTransformation.h>
   #include <Geometry/Vector.h>
%}

//------------------------------------------------------------------------------
// Geometry::ComponentArray Class Interface
//
//------------------------------------------------------------------------------
%ignore Geometry::ComponentArray::operator[](int);
%ignore Geometry::ComponentArray::operator[](int) const;
%include <Geometry/ComponentArray.h>
%template(ComponentArray3) Geometry::ComponentArray<double, 3>;


//------------------------------------------------------------------------------
// Geometry::Vector Class Interface
//
//------------------------------------------------------------------------------
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


//------------------------------------------------------------------------------
// Geometry::OrthogonalTransformation Class Interface
//
//------------------------------------------------------------------------------
namespace Geometry
{
   template <class ScalarParam,int dimensionParam>
   class OrthogonalTransformation
   {
      public:
         OrthogonalTransformation(void);
         const Vector<double,3>& getTranslation(void) const;
         Vector<double,3> getDirection(int j) const;
   };
}

%template(OrthogonalTransformationd) Geometry::OrthogonalTransformation<double,3>;


//------------------------------------------------------------------------------
// Geometry::Geoid Class Interface
//
//------------------------------------------------------------------------------
%include <Geometry/Geoid.h>

%template(Geoidd) Geometry::Geoid<double>;

%pythoncode {
   Geoid = Geoidd
}

