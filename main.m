function main = main(t, n, I=100, nI=5, r=1, R=5, a=1, b=2, c=1)
% function plots 2 figures for the chosen surface with the given parameters
% t -> 1:Sphere, 2:Ellipsoid, 3:Torus
% n -> number of charges
% I -> iterations, nI -> newton iterations
% r,R,a,b,c -> parameters needed for surfaces

flag = t;

%spherical angles
t = pi*rand(1,n);
fi = 2*pi*rand(1,n);

%generate points
switch flag
    %spherical to cartezian
    case 1
      X = r*sin(t).*cos(fi);
      Y = r*sin(t).*sin(fi);
      Z = r*cos(t);
      Xs = [X;Y;Z]';
    case 2
      X = r*a*sin(t).*cos(fi);
      Y = r*b*sin(t).*sin(fi);
      Z = r*c*cos(t);
      Xs = [X;Y;Z]';
    case 3
      t = 2*t;
      X = (R+r.*cos(t)).*cos(fi);
      Y = (R+r.*cos(t)).*sin(fi);
      Z = r*sin(t);
      Xs = [X;Y;Z]';
endswitch

%temp for ploting
Xs_new = Xs;
XsO = Xs;

%main function
switch flag
  case 1
    %Sfera
    func_s = @(x,y,z) (x.^2) + (y.^2) + (z.^2) - r^2;
    grad_s = @(x,y,z) [2*x, 2*y, 2*z];
    check_s = @(x,y,z) (x.^2) + (y.^2) + (z.^2) - r^2 > 0;
    for i=1:I
      Xs_new = forces(Xs_new);
      Xs_new = move_inside(Xs_new, func_s, grad_s, check_s, max_iter=nI);
    endfor
    XsU = Xs_new;
  case 2
    %Elipsa
    func_e = @(x,y,z) (x.^2)/a^2 + (y.^2)/b^2 + (z.^2)/c^2 - r^2;
    grad_e = @(x,y,z) [2*x/a^2, 2*y/b^2, 2*z/c^2];
    check_e = @(x,y,z) (x.^2)/a^2 + (y.^2)/b^2 + (z.^2)/c^2 - r^2 > 0;
    for i=1:I
      Xs_new = forces(Xs_new);
      Xs_new = move_inside(Xs_new, func_e, grad_e, check_e, max_iter=nI);
    endfor
    XsU = Xs_new;
  case 3
    %Torus
    func_t = @(x,y,z) (R - sqrt(x^2+y^2))^2 + z^2 - r^2;
    %temp = @(x,y)(2-(2*R./(sqrt(x.^2+y.^2))));
    grad_t = @(x,y,z) [x.*(2-(2*R./(sqrt(x.^2+y.^2)))),y.*(2-(2*R./(sqrt(x.^2+y.^2)))),2*z];
    check_t = @(x,y,z) 1;
    for i=1:I
      Xs_new = forces(Xs_new);
      Xs_new = move_inside(Xs_new, func_t, grad_t, check_t, max_iter=nI);
    endfor
    XsU = Xs_new;
endswitch

%Xs_new = XsU;

switch flag
  case 1
    [x, y, z] = sphere (40);
    mesh(r*x, r*y, r*z,"facecolor", "none","edgecolor", "c");
  case 2
    [x, y, z] = ellipsoid(0,0,0,a,b,c,40);
    mesh(r*x, r*y, r*z,"facecolor", "none","edgecolor", "c");
  case 3
    u=linspace(0,2*pi,40);
    v=linspace(0,2*pi,40);
    [u,v]=meshgrid(u,v);
    x=(R+r*cos(v)).*cos(u);
    y=(R+r*cos(v)).*sin(u);
    z=r*sin(v);
    mesh(x, y, z,"facecolor", "none","edgecolor", "c");
endswitch
hold on

%ploting new points
X = Xs(:,1)';
Y = Xs(:,2)';
Z = Xs(:,3)';
plot3(X,Y,Z,'bo','markersize',10)
axis equal vis3d
figure;

switch flag
  case 1
    [x, y, z] = sphere (40);
    mesh(r*x, r*y, r*z,"facecolor", "none","edgecolor", "c");
  case 2
    [x, y, z] = ellipsoid(0,0,0,a,b,c,40);
    mesh(r*x, r*y, r*z,"facecolor", "none","edgecolor", "c");
  case 3
    u=linspace(0,2*pi,40);
    v=linspace(0,2*pi,40);
    [u,v]=meshgrid(u,v);
    x=(R+r*cos(v)).*cos(u);
    y=(R+r*cos(v)).*sin(u);
    z=r*sin(v);
    mesh(x, y, z,"facecolor", "none","edgecolor", "c");
endswitch
hold on

X = XsU(:,1)';
Y = XsU(:,2)';
Z = XsU(:,3)';
plot3(X,Y,Z,'bo','markersize',10)
axis equal vis3d

%if needed lines between positions
%for i=1:rows(Xs_new)
%  plot3([Xs(i,1) XsU(i,1)], [Xs(i,2) XsU(i,2)], [Xs(i,3) XsU(i,3)], 'k-')
%endfor
