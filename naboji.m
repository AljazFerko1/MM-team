function naboji
  r=3;
  R=5;
  a=1;
  b=2;
  c=1;
  flag = 3;
  switch flag
    case 1
      %sfera
      F = @(X) [X(1).^2+X(2).^2+X(3).^2-r^2];
      JF = @(X) [2*X(1),2*X(2),2*X(3)];
    case 2
      %elipsa
      F = @(X) [(X(1).^2/a^2)+(X(2).^2/b^2)+(X(3).^2/c^2)-r^2];
      JF = @(X) [2*X(1)/a^2,2*X(2)/b^2,2*X(3)/c^2];
    case 3
      %torus
      F = @(X) [(sqrt(X(1).^2+X(2).^2)-R).^2+X(3).^2-r^2];
      temp = @(X)[2-(2*R./(sqrt(X(1).^2+X(2).^2)))];
      JF = @(X) [X(1).*temp(X),X(2).*temp(X),2*X(3)];
  endswitch

  %construct 20 random point on sphere using spherical coordinates
  %theta = 2*pi*rand(1,20);
  %phi = asin(-1+2*rand(1,20));
  t = pi*rand(1,20);
  fi = 2*pi*rand(1,20);

  %theta = (rand(1,20)-0.5)*pi/16;
  %phi = (rand(1,20)-0.5)*pi/32;

  switch flag
    case 1
      %transform them into cartezian
      %[X,Y,Z] = sph2cart(theta,phi,r);
      X = r*sin(t).*cos(fi);
      Y = r*sin(t).*sin(fi);
      Z = r*cos(t);
      Xs = [X;Y;Z]';
    case 2
      X = a*sin(t).*cos(fi);
      Y = b*sin(t).*sin(fi);
      Z = c*cos(t);
      Xs = [X;Y;Z]';
    case 3
      t = 2*pi*rand(1,20);
      X = (R+r.*cos(t)).*cos(fi);
      Y = (R+r.*cos(t)).*sin(fi);
      Z = r*sin(t);
      Xs = [X;Y;Z]';
  endswitch
  #{
  %sphere
  theta=linspace(0,pi,20);
  fi=linspace(0,2*pi,20);
  r=1

  x = r*sin(theta).*cos(fi);
  y = r*sin(theta).*sin(fi);
  z = r*cos(theta);
  #}


  #{
  %ploting old points
  XsO = Xs;
  X0 = XsO(:,1)';
  Y0 = XsO(:,2)';
  Z0 = XsO(:,3)';
  plot3(X,Y,Z,'rx','markersize',10)
  axis equal vis3d
  hold on
  #}


  h = 0.1;

  %20-20, 30-1000
  for i=1:10000
    Fs = [];
    for i=1:rows(Xs)
      sum = 0;
      for j=1:rows(Xs)
        if(i != j)
          diff = Xs(i,:) - Xs(j,:);
          sum += diff / (norm(diff).^3);
        endif
      endfor
      Fs = [Fs; sum];
    endfor

    Xs_M = Xs + h*Fs;
    %Xs_M = forces(Xs);
    %unitsphere

    #{
    NORMIRANA
    for i=1:rows(Xs_M)
      %[1;2;3]/norm([1;2;3],1)
      Xs_M(i,:) = Xs_M(i,:)/norm(Xs_M(i,:));
    endfor
    #}

    for i=1:rows(Xs_M)
      Xs_M(i,:) = newton(F,JF,Xs_M(i,:)');
    endfor

    Xs=Xs_M;
  endfor

  %mesh for sphere
  switch flag
    case 1
      [x, y, z] = sphere (40);
      mesh(r*x, r*y, r*z,"facecolor", "none","edgecolor", "c");
    case 2
      [x, y, z] = ellipsoid(0,0,0,a,b,c,40);
      mesh(x, y, z,"facecolor", "none","edgecolor", "c");
    case 3
      u=linspace(0,2*pi,40);
      v=linspace(0,2*pi,40);
      [u,v]=meshgrid(u,v);
      x=(R+r*cos(v)).*cos(u);
      y=(R+r*cos(v)).*sin(u);
      z=r*sin(v);
      mesh(x, y, z,"facecolor", "none","edgecolor", "c");
  endswitch
  %surf(x,y,z,'FaceAlpha',.1,'EdgeColor','none')
  hold on

  %ploting new points
  X = Xs_M(:,1)';
  Y = Xs_M(:,2)';
  Z = Xs_M(:,3)';
  plot3(X,Y,Z,'bo','markersize',10)
  axis equal vis3d


  #{
  %ploting lines inbetween
  for i=1:rows(Xs_M)
    plot3([Xs_M(i,1) XsO(i,1)], [Xs_M(i,2) XsO(i,2)], [Xs_M(i,3) XsO(i,3)], 'k-')
  endfor
  #}


  %plot3(XsO, Xs_M, "linestyle", "--", "color", "g");

  %sfera
  %F = @(X) [X(1).^2+X(2).^2+X(3)^2-1];
  %JF = @(X) [2*X(1),2*X(2),2*X(3)];

  %elipsoid
  %F = @(X) [X(1)^2+X(2).^2+X(3)^2-1];
  %torus

