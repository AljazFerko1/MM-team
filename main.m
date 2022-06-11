func_s = @(x,y,z) (x.^2) + (y.^2) + (z.^2) - 1;
grad_s = @(x,y,z) [2*x, 2*y, 2*z];
check_s = @(x,y,z) (x.^2) + (y.^2) + (z.^2) - 1 > 0;

Xs = [[3,0,0]; [0,3,0]; [0,0,3]; [1,1,1]; [-2,-2,-2]; [0,0,0]];

Xs_new = Xs

for i=1:10
  Xs_new = forces(Xs_new);
  Xs_new = move_inside(Xs_new, func_s, grad_s, check_s, max_iter=10);
endfor

Xs_new

func_e = @(x,y,z) (x.^2)/2 + (y.^2)/2 + (z.^2)/4 - 1;
grad_e = @(x,y,z) [x, y, z/2];
check_e = @(x,y,z) (x.^2)/2 + (y.^2)/2 + (z.^2)/4 - 1 > 0;
  
Xs_new = Xs

for i=1:10
  Xs_new = forces(Xs_new);
  Xs_new = move_inside(Xs_new, func_e, grad_e, check_e, max_iter=10);
endfor

Xs_new