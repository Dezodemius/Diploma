clc; clear all; close all;

pkg load signal

d = dlmread('database.csv', ',');

for i=1:1000
  d = sgolayfilt(d, 4, 11);
endfor

dlmwrite('database_smoothed.csv', d);