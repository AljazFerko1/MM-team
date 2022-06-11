%function checks if point is inside
%of ellipsoid defined by eqution
%(x^2)/2 + (y^2)/2 + (z^2)/4 - 1 = 0
function [check] = out_ellipsoid(x, y, z)
  check = (x.^2)/2 + (y.^2)/2 + (z.^2)/4 - 1 > 0;
endfunction