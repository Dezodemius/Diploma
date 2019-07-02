## Copyright (C) 2019 Egor Gladkov
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} my_sgolayfilt (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Egor Gladkov <dez@dezodemius-lenovo>
## Created: 2019-02-22

function [y_] = my_sgolayfilt1 (y)
  a = 1;
  b = 10;
  step = 0.2;
  i = a;   

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


endfunction
