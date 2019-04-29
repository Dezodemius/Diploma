clc; clear all; close all;
a=1;
b=10;
step=0.1;
i=1;
k = 1;

for x=a:step:b
  y(i) = exp(sin(x-1))+k*rand;
  i=i+1;
endfor  

y_ = sgolayfilt(y, 3);

a0 = -3;
a1 = 12;
a2 = 17;
a3 = 12;
a4 = -3;

for i=a+2:size(y,2)-2
  y__(i) = (a0*y(i-2)+a1*y(i-1)+a2*y(i)+a3*y(i+1)+a4*y(i+2)) / 35.0; 
endfor

y__(a) = y(a);
y__(a+1) = y(a+1);
y__(b-1) = y(b-1);
y__(b) = y(b);

subplot(2, 2, 1);
hold on;
plot(y, 'linewidth', 2, 'b');
plot(y_, 'linewidth', 2, 'r');
title('y & sg\_filt(y)');
legend('y', 'sg\_filt y');

subplot(2, 2, 2);
hold on;
plot(y, 'linewidth', 2, 'b');
plot(y__, 'linewidth', 2, 'k');
title('y & my\_filt(y)');
legend('y', 'my\_filt y');

subplot(2, 2, 3);
hold on;
plot(y_, 'linewidth', 2, 'r');
plot(y__, 'linewidth', 2, 'k');
title('sg\_filt(y) & my\_filt(y)');
legend('sg\_filt y', 'my\_filt y');