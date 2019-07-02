clc; clear all; close all;

pkg load signal;

data = dlmread('Torus_100.3TD', ',');

h = 0.02;

N = length(data);

t = [0:h:N];

t_ = [0:N-1];

data = spline(t_, data, t)';

N = length(data);

to_meters = 0.01;

m1 = [data(:, 1), data(:, 2), data(:, 3)] * to_meters;
m2 = [data(:, 5), data(:, 6), data(:, 7)] * to_meters;
m3 = [data(:, 9), data(:, 10), data(:, 11)] * to_meters;
m4 = [data(:, 13), data(:, 14), data(:, 15)] * to_meters;
tcm = [data(:, 17), data(:, 18), data(:, 19)] * to_meters;

for i=1:100
  m1 = sgolayfilt(m1, 4, 11);
  m2 = sgolayfilt(m2, 4, 11);
  m3 = sgolayfilt(m3, 4, 11);
  m4 = sgolayfilt(m4, 4, 11);
endfor

cm = (m1 + m2 + m3 + m4) / 4;

e1 = m3 - m1;
e1 = e1 ./ sqrt(dot(e1, e1, 2)); 
e2 = m4 - m2;
e2 = e2 ./ sqrt(dot(e2, e2, 2));
e3 = cross(e1, e2);
e3 = e3 ./ sqrt(dot(e3, e3, 2));

e10 = e1;
e20 = e2 - e1 .* dot(e2, e1, 2);
e20 = e20 ./ sqrt(dot(e20, e20, 2));
e30 = cross(e10, e20);

e = zeros(size(data, 1), 9);

g = @(x) [dot(x(1:3), x(4:6)); dot(x(1:3), x(1:3)) - 1; dot(x(4:6), x(4:6)) - 1];

for i=1:size(data, 1)
  theta = acos(e30(3));
  psi = atan2(e10(3)/sin(theta), - e20(3)/sin(theta));
  phi = atan2(e30(1)/sin(theta), e30(2)/sin(theta));
  
  x0 = [e10(i, : ) e20(i, : )];

  A = @(x)[cos(x(1))*cos(x(2)) - cos(x(3))*sin(x(2))*sin(x(1)); ...
          -sin(x(1))*cos(x(2)) - cos(x(3))*sin(x(2))*cos(x(1)); ...
          sin(x(3))*sin(x(2))];
  B = @(x)[cos(x(1))*sin(x(2)) + cos(x(3))*cos(x(2))*sin(x(1)); ...
          -sin(x(1))*sin(x(2)) + cos(x(3))*cos(x(2))*cos(x(1)); ...
          -sin(x(3))*cos(x(2))];
  G = @(x)[sin(x(1))*sin(x(3)); ...
           cos(x(1))*sin(x(3)); ...
           cos(x(3))];

  f = @(x) norm(x(1:3)'-e1(i, : ))^2 + ...
         norm(x(4:6)'-e2(i, : ))^2 + ...
         norm(cross(x(1:3)', x(4:6)')-e30(i, :))^2;
         
  fcn = @(x) norm((A(x)'-e10(i, : )) / norm(e10(i, : )))^2 + ...
         norm((B(x)'-e20(i, : )) / norm(e20(i, : )))^2 + ...
         norm((G(x)'-e30(i, :)) / norm(e30(i, :)))^2;   

  [_x, obj, info, iter]=sqp(x0, f, g);    
  
  [x_, fval, info_, output, grad, hess] = fminunc (fcn, [phi, psi, theta]);
  
  e(i, 1:6) = [A(x_)', B(x_)'];  
endfor

e(:, 7:9) = cross(e(:, 1:3), e(:, 4:6));

de11 = sgolayfilt(e(:, 1), 4, 11, 1) / h;%alpha1
de12 = sgolayfilt(e(:, 2), 4, 11, 1) / h;%beta1
de13 = sgolayfilt(e(:, 3), 4, 11, 1) / h;%gamma1

de21 = sgolayfilt(e(:, 4), 4, 11, 1) / h;%alpha2
de22 = sgolayfilt(e(:, 5), 4, 11, 1) / h;%beta2
de23 = sgolayfilt(e(:, 6), 4, 11, 1) / h;%gamma2

de31 = sgolayfilt(e(:, 7), 4, 11, 1) / h;%alpha3
de32 = sgolayfilt(e(:, 8), 4, 11, 1) / h;%beta3
de33 = sgolayfilt(e(:, 9), 4, 11, 1) / h;%gamma3

Q = cell(1,size(data, 1));
dQ = cell(1,size(data, 1));
invQ = cell(1,size(data, 1));
omega = cell(1,size(data, 1));

Omega = zeros(size(data, 1), 3);

for i=1:size(data, 1) 
  Q{i} = [e(i, 1:3); e(i,4:6); e(i,7:9)];
  dQ{i} = [[de11(i) de21(i) de31(i)]; [de12(i) de22(i) de32(i)]; [de13(i) de23(i) de33(i)]]';
  invQ{i} = inverse(Q{i});
  omega{i} = dQ{i} * invQ{i};
  Omega(i, :) = 0.5 * [omega{i}(2, 3)-omega{i}(3, 2); omega{i}(3, 1)-omega{i}(1, 3); omega{i}(1, 2)-omega{i}(2, 1);]';
endfor 

Vx = sgolayfilt(cm(:, 1), 4, 11, 1) / h;
Vy = sgolayfilt(cm(:, 2), 4, 11, 1) / h;
Vz = sgolayfilt(cm(:, 3), 4, 11, 1) / h;

V = zeros(size(data, 1), 3);

for i=1:size(data, 1)
V(i, :) = [ dot([ Vx(i) ; Vy(i) ; Vz(i)], e(i, 1:3)) ;...
         dot([ Vx(i) ; Vy(i) ; Vz(i)], e(i, 4:6)) ;...
         dot([ Vx(i) ; Vy(i) ; Vz(i)], e(i, 7:9)) ];
endfor

dV = sgolayfilt(V, 4, 11, 1) / h;
dOmega = sgolayfilt(Omega, 4, 11, 1) / h;

m = 0.155;
J = diag([1.119 1.119 2.058] * 10^(-4));
Lv = diag([0.06249, 0.06249, 0.15903]);
Lw = diag([7.4113 7.4113 0] * 10^(-5));
rhoB = 1100;
rhoL = 1000;
Vol = 1.409 * 10^(-4);
g = 9.81;

_I = J + Lw;
C = m * diag([1 1 1]) + Lv;

mu = (rhoB - rhoL) * Vol * g;

F = zeros(size(data, 1), 3);
G = zeros(size(data, 1), 3);

for i=1:N
F(i, :) = (cross(C * V(i, :)',  Omega(i,:)') - mu * e(i, 3:3:9)' - C * dV(i, :)')';
G(i, :) = (cross(_I * Omega(i, :)', Omega(i, :)') + cross(C * V(i, :)', V(i, :)') - _I * dOmega(i, :)')';
endfor

d = [V Omega dV dOmega e F G]; 