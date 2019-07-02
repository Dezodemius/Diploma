clc; clear all; close all;

pkg load signal;

%FILE = dlmread('DATA.UVT', ',');
%FILE = dlmread('abg.csv', ',');
r = dlmread('cmXYZ.csv', '\t');

to_meters = 0.01;

t = r(:, 1);
x = r(:, 2) * to_meters;
y = r(:, 3) * to_meters;
z = r(:, 4) * to_meters;

step = t(2) - t(1);

N = size(t, 1);

dx = sgolayfilt(x, 4, 11, 1) / step;
dy = sgolayfilt(y, 4, 11, 1) / step;
dz = sgolayfilt(z, 4, 11, 1) / step;

abg = dlmread('abg.csv', '\t');

k1 = abg(:, 1);%alpha1
k2 = abg(:, 4);%alpha2
k3 = abg(:, 7);%alpha3

kn1 = abg(:, 3);
kn2 = abg(:, 6);
kn3 = abg(:, 9);

n1 = abg(:, 2);
n2 = abg(:, 5);
n3 = abg(:, 8); 

h = k1(2) - k1(1);

e1 = [k1, k2, k3];
e2 = [n1, n2, n3];
e3 = [kn1, kn2, kn3];
%e3 = e3/norm(e3);
ab = zeros(size(e1, 1), 6);
abe = zeros(size(e1, 1), 6);

g = @(x) [dot(x(1:3), x(4:6)); dot(x(1:3), x(1:3)) - 1; dot(x(4:6), x(4:6)) - 1];

file = fopen('DATA_.csv', 'at');

for i=5:5%size(k, 1)
  
  alpha0 = e1(i, : );
  alpha0 = alpha0/norm(alpha0);
  beta0 = e2(i, : ) - dot(e2(i, : ), alpha0)*alpha0/norm(alpha0);
  beta0 = beta0/norm(beta0); 
%  alpha0 = alpha0/norm(alpha0);
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
  f = @(x) norm(x(1:3)'-e1(i, : ) / norm(e1(i, : )))^2 + ...
           norm(x(4:6)'-e2(i, : ) / norm(e2(i, : )))^2 + ...
           norm(cross(x(1:3)', x(4:6)')-cross(e1(i, :), e2(i, :)) / norm(cross(e1(i, :), e2(i, :))))^2;
  [x, obj, info, iter]=sqp(x0, f, g);          
  fcn = @(x) norm(A(x)'-e1(i, : ) / norm(e1(i, : )))^2 + ...
         norm(B(x)'-e2(i, : ) / norm(e2(i, : )))^2 + ...
         norm(G(x)'-cross(e1(i, : ), e2(i, :)) / norm(cross(e1(i, : ), e2(i, :))))^2;
  
    
  [x_, fval, info_, output, grad, hess] = fminunc (fcn, [phi, psi, theta]);
  
  x_ = x_';
  
%  printf('_________________%g_________________\n', i);
  
%  for i=1:1:size(x, 1)
%    x(1:3) 
%    A(x_)
%    printf('SQP\t(%g\t| %g)\nfminunc\t(%g\t| %g)\n\n', x(i), x0(i), x_(i), x0(i));
%    fprintf(file, '%g\t%g\n', x(i), x_(i));    
%  endfor
  hold on; 

%  plot([0 e1(i, 1)], [0 e1(i, 2)], 'r', 'marker', '^')
%  plot([0 e2(i, 1)], [0 e2(i, 2)], 'b', 'marker', '^')
%  
%  plot([0 x(1)], [0 x(2)], 'r', "linewidth", 2, 'marker', '^')
%  plot([0 x(5)], [0 x(6)], 'b', "linewidth", 2, 'marker', '^')
%  
%  plot([0 A(x_)(1)], [0 A(x_)(2)], 'k', "linewidth", 2, 'marker', '^')
%  plot([0 B(x_)(1)], [0 B(x_)(2)], 'c', "linewidth", 2, 'marker', '^')
  plot3( [0 e1(i, 1)], [0 e1(i, 2)], [0 e1(i, 3)], 'r', 'marker', '^');
  plot3( [0 e2(i, 1)], [0 e2(i, 2)], [0 e2(i, 3)], 'g', 'marker', '^');
%  plot3( [0 e3(i, 1)], [0 e3(i, 2)], [0 e3(i, 3)], 'b', 'marker', '^');
  plot3( [0 cross(e1(i, :), e2(i, :))(1)], [0 cross(e1(i, :), e2(i, :))(2)], [0 cross(e1(i, :), e2(i, :))(3)], 'b', 'marker', '^');

%
  plot3( [0 x(1)], [0 x(2)], [0 x(3)], 'r', "linewidth", 2, 'marker', '^');
  plot3( [0 x(4)], [0 x(5)], [0 x(6)], 'g', "linewidth", 2, 'marker', '^');
  plot3( [0 cross(x(1:3), x(4:6))(1)], [0 cross(x(1:3), x(4:6))(2)], [0 cross(x(1:3), x(4:6))(3)], 'b', "linewidth", 2, 'marker', '^');  

%  figure(3)
%  plot3( [0 x_(1)], [0 x_(2)], [0 x_(3)], 'r', "linewidth", 2, 'marker', '^');
%  plot3( [0 x_(4)], [0 x_(5)], [0 x_(6)], 'g', "linewidth", 2, 'marker', '^');
%  plot3( [0 cross(x_(1:3), x_(4:6))(1)], [0 cross(x_(1:3), x_(4:6))(2)], [0 cross(x_(1:3), x_(4:6))(3)], 'b', "linewidth", 2, 'marker', '^');  
%
%  figure(4)
%  plot3( [0 A(x_)(1)], [0 A(x_)(2)], [0 A(x_)(3)], 'k--', "linewidth", 2, 'marker', '^');
%  plot3( [0 B(x_)(1)], [0 B(x_)(2)], [0 B(x_)(3)], 'y--', "linewidth", 2, 'marker', '^');
%  plot3( [0 G(x_)(1)], [0 G(x_)(2)], [0 G(x_)(3)], 'c--', "linewidth", 2, 'marker', '^');

  ab(i, :) = [x'];  
%  ab(i, :) = [A(x_)', B(x_)'];
endfor

fclose(file);
%
%dA1 = ab(:,1) .* sgolayfilt(ab(:,1), 4, 11, 1) / h;
%dA2 = ab(:,2) .* sgolayfilt(ab(:,2), 4, 11, 1) / h;
%dA3 = ab(:,3) .* sgolayfilt(ab(:,3), 4, 11, 1) / h;
%
%dB1 = ab(:,4) .* sgolayfilt(ab(:,4), 4, 11, 1) / h;
%dB2 = ab(:,5) .* sgolayfilt(ab(:,5), 4, 11, 1) / h;
%dB3 = ab(:,6) .* sgolayfilt(ab(:,6), 4, 11, 1) / h;
%
%dG1 = cross(ab(:,1:3), ab(:,4:6))(:,1) .* sgolayfilt(cross(ab(:,1:3), ab(:,4:6))(:,1), 4, 11, 1) / h;
%dG2 = cross(ab(:,1:3), ab(:,4:6))(:,2) .* sgolayfilt(cross(ab(:,1:3), ab(:,4:6))(:,2), 4, 11, 1) / h;
%dG3 = cross(ab(:,1:3), ab(:,4:6))(:,3) .* sgolayfilt(cross(ab(:,1:3), ab(:,4:6))(:,3), 4, 11, 1) / h;
%
%Vx = ab(:, 1) .* dx + ab(:, 2) .* dy + ab(:, 3) .* dz;
%Vz = ab(:, 4) .* dx + ab(:, 5) .* dy + ab(:, 6) .* dz;
%Vy =  cross(ab(:,1:3), ab(:,4:6))(:,1) .* dx +  cross(ab(:,1:3), ab(:,4:6))(:,2) .* dy +  cross(ab(:,1:3), ab(:,4:6))(:,3) .* dz;  