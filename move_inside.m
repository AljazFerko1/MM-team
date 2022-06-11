%Function move_inside for each x in Xs
%checks if it's inside the surface
%if yes it leaves it as is
%if no it moves it inside using
%newtow iteration
%
%Inputs:
%Xs ... matrix, each row is a vector
%       coresponding to position of one X
%       shape is Nx3
%func ... function defining the surface
%grad ... gradiant of function
%max_iter ... max number of iteration for newton
%tol ... early stoping threshold for newton
%outside_test ... that given a point,
%                 returns true if the point is
%                 outside the surface
%Outputs:
%Xs_new ... matrix, each row is a new position
%           of X, shape is Nx3
%Example input:
%func = @(x,y,z) [x.^2 + y.^2 + z.^2 - 1]
%grad = @(x,y,z) [2*x, 2*y, 2*z]
%Xs = [[3,2,1];[0,0,3];[0,0,2];[1,1,1]; [2,2,2]; [5,-2,3]]
%Xs_new = move_inside(Xs, func, grad, max_iter=3, tol=1e-10, outside_test=@out_sphere)
function [Xs_new] = move_inside(Xs, func, grad, outside_test, max_iter=3, tol=1e-10)
  Xs_new = [];
  for i=1:rows(Xs)
    x = Xs(i,:);
    if (outside_test(x(1), x(2), x(3)))
      n = grad(Xs(i,1),Xs(i,2),Xs(i,3));
      % begin newton
      t = 0;
      for j=1:max_iter
        % using equation r(t) = x + t*n
        % for newton iteration
        r = x + t*n;        
        % compute function and grad value
        f_val = func(r(1), r(2), r(3)) + 1e-10;
        grad_val = dot(grad(r(1), r(2), r(3)), n);
        % solve
        t_hat = t - (grad_val\f_val);
        if(abs(t_hat - t) < tol)
          % early stop if parameter doesn't change much
		      break;
	      endif
        t = t_hat;
      endfor
      x_new = x + t_hat*n;
      % func(x_new(1),x_new(2),x_new(3))
      % for debuging purposes
      % this should be close to 0
      Xs_new = [Xs_new; x_new];
    else
      Xs_new=[Xs_new; x];
    endif
  endfor
endfunction
%tests
%!test
%! func_s = @(x,y,z) [(x.^2) + (y.^2) + (z.^2) - 1];
%! grad_s = @(x,y,z) [2*x, 2*y, 2*z];
%! Xs = [[3,0,0]; [0,3,0]; [0,0,3]; [1,1,1]; [-2,-2,-2]; [0,0,0]];
%! expected = [[1,0,0]; [0,1,0]; [0,0,1]; [0.5774,0.5774,0.5774]; [-0.5774,-0.5774,-0.5774]; [0,0,0]];
%! check_s = @(x,y,z) (x.^2) + (y.^2) + (z.^2) - 1 > 0;
%! assert(move_inside(Xs, func_s, grad_s, check_s, max_iter=10), expected, 1e-4)
%!test
%! func_e = @(x,y,z) [(x.^2)/2 + (y.^2)/2 + (z.^2)/4 - 1];
%! grad_e = @(x,y,z) [x, y, z/2];
%! check_e = @(x,y,z) (x.^2)/2 + (y.^2)/2 + (z.^2)/4 - 1 > 0;
%! Xs = [[3,0,0]; [0,3,0]; [0,0,3]; [1,1,1]; [-2,-2,-2]; [0,0,0]];
%! expected = [[1.4142,0,0]; [0,1.4142,0]; [0,0,2]; [0.8824, 0.8824,0.9412]; [-0.7307,-0.7307,-1.3654]; [0,0,0]];
%! assert(move_inside(Xs, func_e, grad_e, check_e, max_iter=10), expected, 1e-4)