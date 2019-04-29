clc; clear all; close all;

a = 0;
b = 10;
N = 501;
t = linspace(a, b, N);
step = t(2) - t(1);
i = a;

for i = 1 : N
  x(i) = exp(sin(2*t(i) - 5));
endfor

x_n = x + (rand(1, N) - 0.5) * 0.05;

for i = 1 : 500
x_n = sgolayfilt(x_n, 4, 7);
end
%plot(t, x);
%return 

dx = sgolayfilt(x_n, 4, 7, 1) / step;
f = sgolayfilt(x_n, 4, 7, 2) / step^2;

x1 = zeros(1, N);
dx1 = zeros(1, N);
x1(1) = x_n(1);
dx1(1) = dx(1);

%for n=a:size(x, 2)-1
for n=1 : N-1
  x_ = x1(n) + step * dx1(n);
  y_ = dx1(n) + step * f(n);
  
  x1(n+1) = x1(n) + step / 2 * (dx1(n)+y_);
  dx1(n+1) = dx1(n) + step / 2 * (f(n)+f(n+1));
endfor;

plot(t, x);
hold on;
plot(t, x1, 'r');
plot(t, x_n, 'b');
return;
t = a:step:size(x, 2);
subplot(2, 1, 1)
hold on;
plot(t, 4.*exp(sin(2.*t-5)).*((cos(2.*t-5)).^2-sin(2.*t-5)), 'linewidth', 2, 'b');
plot(f, 'linewidth', 2, 'r');
title('d2y & rep y');
legend('d2y', 'new_y');

subplot(2,1,2)
hold on;
plot(t, 2.*exp(sin(2.*t-5)).*cos(2.*t-5), 'linewidth', 2, 'b');
plot(y, 'linewidth', 2, 'r');
title('dy & rep y');
legend('dy', 'new_y');
