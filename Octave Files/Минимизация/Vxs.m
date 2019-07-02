clc;
clear all;
close all;

r = dlmread('cmXYZ.csv', '\t');
abg = dlmread('abg.csv', '\t');

a = [abg(:, 5), abg(:, 11), abg(:, 17)];
b = [abg(:, 6), abg(:, 12), abg(:, 18)];
g = [abg(:, 7), abg(:, 13), abg(:, 19)];

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

Vx = a(:, 1) .* dx + a(:, 2) .* dx + a(:, 3) .* dx;
Vy = b(:, 1) .* dy + b(:, 2) .* dy + b(:, 3) .* dy;
Vz = g(:, 1) .* dz + g(:, 2) .* dz + g(:, 3) .* dz;  

hold on;
plot(dx, t, 'k');
plot(Vx, t, 'b');

legend({'dx', 'Vx'})

%ПРОВЕРКА ПРОИЗВОДНОЙ.
%x1 = zeros(1, N);
%dx1 = zeros(1, N);
%x1(1) = x(1);
%dx1(1) = dx(1);
%
%%for n=a:size(x, 2)-1
%for n=1 : N-1
%  x_ = x1(n) + step * dx1(n);
%  y_ = dx1(n) + step * d2x(n);
%  
%  x1(n+1) = x1(n) + step / 2 * (dx1(n)+y_);
%  dx1(n+1) = dx1(n) + step / 2 * (d2x(n)+d2x(n+1));
%endfor;
%
%hold on;
%plot(t, x, 'r');
%plot(t, x1, 'k');