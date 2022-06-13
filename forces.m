%Function forces calculates
%the new position of Xs
%by calculating the force acting on them
%and then scaling that force by h
%then moving them in the directiong of the force
%
%Inputs:
%Xs ... matrix, each row is a vector
%       coresponding to position of one X
%       shape is Nx3
%h ... scaling factor
%
%Outputs:
%Xs_new ... matrix, each row is a new position
%           of X, shape is Nx3
%Example input:
%Xs_new = forces([[1,2,3];[4,5,6];[7,8,9]], 1)
function [Xs_new] = forces(Xs, h=0.1)
	Fs = [];
	for i=1:rows(Xs)
	  F = 0;
	  for j=1:rows(Xs)
      if(i != j)
        diff = Xs(i,:) - Xs(j,:);
        F += diff / (norm(diff).^3);
      endif
	  endfor
	  Fs = [Fs; F];
	endfor 
	Xs_new = Xs + h*Fs;
endfunction
%tests
%!test
%! Xs = [[0,0,0];[1,1,1];[3,3,3];[6,6,6]];
%! expected = [[-0.2192,-0.2192,-0.2192];[1.1366,1.1366,1.1366];[3.0481,3.0481,3.0481];[6.0344,6.0344,6.0344]];
%! assert(forces(Xs, 1), expected, 1e-4)
%!test
%! Xs = [[1,2,3];[4,4,4];[5,6,7]];
%! expected = [[0.9307,1.9498,2.9689];[4.0382,4,3.9618];[5.0311,6.0502,7.0693]];
%! assert(forces(Xs, 1), expected, 1e-4)
%!test
%! Xs = [[1,2,3];[4,4,4];[5,6,7]];
%! expected = [[0.9931,1.9950,2.9969];[4.0038,4,3.9962];[5.0031,6.0050,7.0069]];
%! assert(forces(Xs), expected, 1e-4)
%!test
%! Xs = [[0,0,1];[0,0,-1]];
%! expected = [[0,0,1.0025];[0,0,-1.0025]];
%! assert(forces(Xs, 0.01), expected, 1e-4)