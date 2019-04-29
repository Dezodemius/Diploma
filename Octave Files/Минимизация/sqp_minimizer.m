clc;
clear all;
close all;

%[x y] = meshgrid(-2:0.1:2, -2:0.1:2);
%
%a=1;
%
%f = x.^2 - y.^2;
%h = x+2.*y-a;
%hold on;
%mesh(x, y, f);
%mesh(x, y, h);
f = @(x)x(1)^2 - x(2)^2;
for a=1:0.1:2
  x0 = [a/3 a/3];
  h = @(x)x(1)+2*x(2)-a;
  [x, obj, info, iter]=sqp(x0, f, h);
  
  printf('sqp: %g | %g (%g | %g)\n', x(1), x(2), -a/3, 2*a/3);
endfor
