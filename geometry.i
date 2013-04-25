%{
   #include <Geometry/Geoid.h>
%}

%include <Geometry/Geoid.h>

%template(Geoidd) Geometry::Geoid<double>;

%pythoncode {
   Geoid = Geoidd
}

