clc; clear all; close all;

a = 1;
b = 10;
step = 0.2;
i = a;

for x=a:step:b
  dy(i) = 2*exp(sin(2*x-5))*cos(2*x-5);
  y(i) = exp(sin(2*x - 5));
  i = i + 1;
endfor  
  
sg_filt_dy = sgolayfilt(y, 3, 7, 1) / step;

a0 = -257;
a1 = 122;
a2 = 185;
a3 = 72;
a4 = -77;
a5 = -122;
a6 = 77;
h = 1/(252*step);

for i=a:a+3
  my_filt_dy(i) = h*(a0*y(i)+a1*y(i+1)+a2*y(i+2)+a3*y(i+3)+a4*y(i+4)+a5*y(i+5)+a6*y(i+6)); 
endfor

a0 = -77;
a1 = 122;
a2 = 77;
a3 = -72;
a4 = -185;
a5 = -122;
a6 = 257;
h = 1/(252*step);
for i=size(y, 2):-1:size(y, 2)-3
  my_filt_dy(i) = h*(a0*y(i-6)+a1*y(i-5)+a2*y(i-4)+a3*y(i-3)+a4*y(i-2)+a5*y(i-1)+a6*y(i)); 
endfor


a0 = 22;
a1 = -67;
a2 = -58;
a3 = 0;
a4 = 58;
a5 = 67;
a6 = -22;
h = 1/(252*step);
for i=a+3:size(y, 2)-3
  my_filt_dy(i) = h*(a0*y(i-3)+a1*y(i-2)+a2*y(i-1)+a3*y(i)+a4*y(i+1)+a5*y(i+2)+a6*y(i+3)); 
endfor

subplot(2, 2, 1);
hold on;
plot(dy, 'linewidth', 2, 'b');
plot(sg_filt_dy, 'linewidth', 2, 'r');
title('dy & sg\_filt(dy)');
legend('dy', 'sg\_filt dy');

subplot(2, 2, 2);
hold on;
plot(dy, 'linewidth', 2, 'b');
plot(my_filt_dy, 'linewidth', 2, 'k');
title('dy & my\_filt(dy)');
legend('dy', 'my\_filt dy');

subplot(2, 2, 3);
hold on;
plot(sg_filt_dy, 'linewidth', 2, 'r');
plot(my_filt_dy, 'linewidth', 2, 'k');
title('sg\_filt(dy) & my\_filt(dy)');
legend('sg\_filt dy', 'my\_filt dy');
