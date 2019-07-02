clc; clear all; close all;

pkg load signal;

r = dlmread('cmXYZ.csv', '\t');
abg = dlmread('abg.csv', '\t');

abg = abg(:, [2:4, 8:10, 14:16]);

to_meters = 0.01;

t = r(:, 1);
x = r(:, 2) * to_meters;
y = r(:, 3) * to_meters;
z = r(:, 4) * to_meters;

step = t(2) - t(1);

N = size(t, 1);

plot3(x, y, z, 'k');
hold on;
s = 10;
l = 0.1;
axis('square', [-0.3, 0.3, 0.4, 1, 0, 1.2])
xlabel('x');
ylabel('y');
zlabel('z');
for i = 1 : s : N
  plot3([x(i), x(i) + l * abg(i, 1)], [y(i), y(i) + l * abg(i, 4)], [z(i), z(i) + l * abg(i, 7)], 'r', 'linewidth', 2);
  plot3([x(i), x(i) + l * abg(i, 2)], [y(i), y(i) + l * abg(i, 5)], [z(i), z(i) + l * abg(i, 8)], 'g', 'linewidth', 2);
  plot3([x(i), x(i) + l * abg(i, 3)], [y(i), y(i) + l * abg(i, 6)], [z(i), z(i) + l * abg(i, 9)], 'b', 'linewidth', 2);
end


return 
dx = sgolayfilt(x, 4, 11, 1) / step;
dy = sgolayfilt(y, 4, 11, 1) / step;
dz = sgolayfilt(z, 4, 11, 1) / step;


%alpha
k1 = abg(:, 1);
k2 = abg(:, 4);
k3 = abg(:, 7);
%beta
kn1 = abg(:, 3);
kn2 = abg(:, 6);
kn3 = abg(:, 9);
%gamma
n1 = abg(:, 2);
n2 = abg(:, 5);
n3 = abg(:, 8); 

h = k1(2) - k1(1);

k = [k1, k2, k3];
n = [n1, n2, n3];
kn = [kn1, kn2, kn3];

ab = zeros(size(k, 1), 6);

g_ = @(x_) [dot(x_(1:3), x_(4:6)); dot(x_(1:3), x_(1:3)) - 1; dot(x_(4:6), x_(4:6)) - 1];

Q = cell(1,size(FILE, 1));
dQ = cell(1,size(FILE, 1));
invQ = cell(1,size(FILE, 1));
omega = cell(1,size(FILE, 1));
W = cell(1,size(FILE, 1));

for i=1:size(FILE, 1)  
  alpha0 = k(i, : ) / norm(k(i, : ));
  beta_ = n(i, : ) - dot(alpha0, n(i, : )) * alpha0;
  beta0 = beta_ / norm(beta_); 
  
  x0 = [alpha0 beta0];
  
  f = @(x_)norm(x_(1:3)'-k(i, : ) / norm(k(i, : )))^2 + ...
           norm(x_(4:6)'-n(i, : ) / norm(n(i, : )))^2 + ...
           norm(cross(x_(1:3)', x_(4:6)')-cross(k(i, : ), n(i, :)) / norm(cross(k(i, : ), n(i, :))))^2;
           
  [_x_, obj, info, iter] = sqp(x0', f, g_);    
    
  ab(i, :) = [_x_'];  
  
%  a1 = ab(:, 1);
%  a2 = ab(:, 2);
%  a3 = ab(:, 3);
%  
%  g1 = ab(:, 4);
%  g2 = ab(:, 5);
%  g3 = ab(:, 6);
%  
%  b1 = cross(ab(:, 1:3), ab(:, 4:6))(:, 1);
%  b2 = cross(ab(:, 1:3), ab(:, 4:6))(:, 2);
%  b3 = cross(ab(:, 1:3), ab(:, 4:6))(:, 3);
 
endfor 

a = ab(:, 1:3);
g = ab(:, 4:6);
b = cross(a, g);

dA1 = sgolayfilt(ab(:,1), 4, 11, 1) / h;
dA2 = sgolayfilt(ab(:,2), 4, 11, 1) / h;
dA3 = sgolayfilt(ab(:,3), 4, 11, 1) / h;

dG1 = sgolayfilt(ab(:,4), 4, 11, 1) / h;
dG2 = sgolayfilt(ab(:,5), 4, 11, 1) / h;
dG3 = sgolayfilt(ab(:,6), 4, 11, 1) / h;

dB1 = sgolayfilt(cross(ab(:,1:3), ab(:,4:6))(:,1), 4, 11, 1) / h;
dB2 = sgolayfilt(cross(ab(:,1:3), ab(:,4:6))(:,2), 4, 11, 1) / h;
dB3 = sgolayfilt(cross(ab(:,1:3), ab(:,4:6))(:,3), 4, 11, 1) / h;

Vx = ab(:, 1) .* dx + ab(:, 2) .* dy + ab(:, 3) .* dz;
Vz = ab(:, 4) .* dx + ab(:, 5) .* dy + ab(:, 6) .* dz;
Vy =  cross(ab(:,1:3), ab(:,4:6))(:,1) .* dx +  cross(ab(:,1:3), ab(:,4:6))(:,2) .* dy +  cross(ab(:,1:3), ab(:,4:6))(:,3) .* dz; 
Omega = zeros(N, 1);
for i=1:size(FILE, 1) 
  Q{i} = [a(i,:)' b(i,:)' g(i,:)'];
  dQ{i} = [[dA1(i) dB1(i) dG1(i)]; [dA2(i) dB2(i) dG2(i)]; [dA3(i) dB3(i) dG3(i)]];
  invQ{i} = inverse(Q{i});
  omega{i} = dQ{i} * invQ{i};
  Omega(i, :) = 0.5 * [omega{i}(1, 2)-omega{i}(2, 1); omega{i}(2, 3)-omega{i}(3, 2); omega{i}(1, 3)-omega{i}(3, 1)]';
  
endfor 
dOmega{i} = sgolayfilt(W{i}', 4, 11, 1) / h;
