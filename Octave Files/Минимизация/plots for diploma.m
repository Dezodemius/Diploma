clc; clear all; close all;

pkg load signal;

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

t = 0:0.02:3.04;
y = sgolayfilt(k1, 3, 5);


for i=1:90
  y =  sgolayfilt(y, 3, 5);
endfor

y_ = sgolayfilt(k1, 4, 11);


for i=1:90
  y_ =  sgolayfilt(y_, 4, 11);
endfor

hold on;
plot(t, k1, 'k');
plot(t, y, 'r');
plot(t, y_, 'b');
axis([1.5, 2, -0.15, -0.10])
%csvwrite('/home/dez/Documents/Diploma/Octave Files/filtDATA.csv', [y, t']);