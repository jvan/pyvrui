%{
   #include <Geometry/Geoid.h>
   #include <Geometry/OrthogonalTransformation.h>
%}


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

   };
}

%template(OrthogonalTransformationd) Geometry::OrthogonalTransformation<double,3>;
