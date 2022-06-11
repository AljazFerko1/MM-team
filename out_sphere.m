%function checks if point is inside
%of sphere defined by eqution
%x^2 + y^2 + z^2 - 1 - 1 = 0
function [check] = out_sphere(x, y, z)
  check = x.^2 + y.^2 + z.^2 - 1 > 0;
endfunction