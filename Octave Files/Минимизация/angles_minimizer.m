clc; clear all; close all;

FILE = dlmread('DATA.UVT', ',');

abg = [FILE(:,  19), FILE(:,  22), FILE(:,  25), FILE(:,  20), FILE(:,  23), FILE(:,  26), FILE(:,  21), FILE(:,  24), FILE(:,  27)];

k1 = abg(:, 1);
k2 = abg(:, 4);
k3 = abg(:, 7);

kn1 = abg(:, 3);
kn2 = abg(:, 6);
kn3 = abg(:, 9);

n1 = abg(:, 2);
n2 = abg(:, 5);
n3 = abg(:, 8); 

k = [k1, k2, k3];
n = [n1, n2, n3];
kn = [kn1, kn2, kn3];

g = @(x) [dot(x(1:3), x(4:6)); dot(x(1:3), x(1:3)) - 1; dot(x(4:6), x(4:6)) - 1];

file = fopen('DATA_.csv', 'at');

for i=1:1%:10%size(k, 1)
  
  alpha0 = k(i, : )/norm(k(i, : ));
  beta_ = n(i, : ) - dot(alpha0, n(i, : ))*alpha0;
  beta0 = beta_/norm(beta_); 
  gamma0 = cross(alpha0, beta0);
  
  theta = acos(gamma0(3));
  psi = atan2(alpha0(3)/sin(theta), - beta0(3)/sin(theta));
  phi = atan2(gamma0(1)/sin(theta), gamma0(2)/sin(theta));
  x0 = [alpha0 beta0];
  
  A = @(x)[cos(x(1))*cos(x(2)) - cos(x(3))*sin(x(2))*sin(x(1)); ...
          -sin(x(1))*cos(x(2)) - cos(x(3))*sin(x(2))*cos(x(1)); ...
          sin(x(3))*sin(x(2))];
  B = @(x)[cos(x(1))*sin(x(2)) + cos(x(3))*cos(x(2))*sin(x(1)); ...
          -sin(x(1))*sin(x(2)) + cos(x(3))*cos(x(2))*cos(x(1)); ...
          -sin(x(3))*cos(x(2))];
  G = @(x)[sin(x(1))*sin(x(3)); ...
           cos(x(1))*sin(x(3)); ...
           cos(x(3))];
%  f = @(x) norm(cross(x(1:3)', k(i, : ) / norm(k(i, : )))) + ...
%           norm(cross(x(4:6)', n(i, : ) / norm(n(i, : )))) + ...
%           norm(cross(cross(x(1:3)', x(4:6)'), kn(i, : ) / norm(kn(i, : ))));
  f = @(x) norm(x(1:3)'-k(i, : ) / norm(k(i, : )))^2 + ...
           norm(x(4:6)'-n(i, : ) / norm(n(i, : )))^2 + ...
           norm(cross(x(1:3)', x(4:6)')-cross(k(i, : ), n(i, :)) / norm(cross(k(i, : ), n(i, :))))^2;
  fcn = @(x) norm(A(x)'-k(i, : ) / norm(k(i, : )))^2 + ...
         norm(B(x)'-n(i, : ) / norm(n(i, : )))^2 + ...
         norm(G(x)'-cross(k(i, : ), n(i, :)) / norm(cross(k(i, : ), n(i, :))))^2;
  
  [x, obj, info, iter]=sqp(x0, f, g);    
  [x_, fval, info_, output, grad, hess] = fminunc (fcn, [phi, psi, theta]);
  
  x_ = x_';
  
%  printf('_________________%g_________________\n', i);
%  
%  for i=1:1:size(x, 1)
%    x(1:3) 
%    A(x_)
%    printf('SQP\t(%g\t| %g)\nfminunc\t(%g\t| %g)\n\n', x(i), x0(i), x_(i), x0(i));
%    fprintf(file, '%g\t%g\n', x(i), x_(i));    
%  endfor
  hold on; 
  plot3( [0 k(i, 1)], [0 k(i, 2)], [0 k(i, 3)], 'r', 'marker', '^');
  plot3( [0 n(i, 1)], [0 n(i, 2)], [0 n(i, 3)], 'g', 'marker', '^');
  plot3( [0 kn(i, 1)], [0 kn(i, 2)], [0 kn(i, 3)], 'b', 'marker', '^');
  
  plot3( [0 x(1)], [0 x(2)], [0 x(3)], 'r', "linewidth", 2, 'marker', '^');
  plot3( [0 x(4)], [0 x(5)], [0 x(6)], 'g', "linewidth", 2, 'marker', '^');
  plot3( [0 cross(x(1:3), x(4:6))(1)], [0 cross(x(1:3), x(4:6))(2)], [0 cross(x(1:3), x(4:6))(3)], 'b', "linewidth", 2, 'marker', '^');  
  
%  plot3( [0 x_(1)], [0 x_(2)], [0 x_(3)], 'r', "linewidth", 2, 'marker', '^');
%  plot3( [0 x_(4)], [0 x_(5)], [0 x_(6)], 'g', "linewidth", 2, 'marker', '^');
%  plot3( [0 cross(x_(1:3), x_(4:6))(1)], [0 cross(x_(1:3), x_(4:6))(2)], [0 cross(x_(1:3), x_(4:6))(3)], 'b', "linewidth", 2, 'marker', '^');  
  
  plot3( [0 A(x_)(1)], [0 A(x_)(2)], [0 A(x_)(3)], 'k--', "linewidth", 2, 'marker', '^');
  plot3( [0 B(x_)(1)], [0 B(x_)(2)], [0 B(x_)(3)], 'y--', "linewidth", 2, 'marker', '^');
  plot3( [0 G(x_)(1)], [0 G(x_)(2)], [0 G(x_)(3)], 'c--', "linewidth", 2, 'marker', '^');  
endfor

fclose(file);