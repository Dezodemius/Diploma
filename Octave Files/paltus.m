## Copyright (C) 2018 Yegor Gladkov
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
## @deftypefn {Function File} {@var{retval} =} paltus (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Yegor Gladkov <dezodemius@Dezodemius>
## Created: 2018-09-05

function [] = paltus (path, file_name, delimeter, save_path, save_format, saved)  
  FILE = dlmread(path, delimeter);

  FILE = sgolayfilt(FILE, 3, 41);

  M1 = [FILE(:,  1), FILE(:,  2), FILE(:,  3)];
  M2 = [FILE(:,  5), FILE(:,  6), FILE(:,  7)];
  M3 = [FILE(:,  9), FILE(:, 10), FILE(:, 11)];
  M4 = [FILE(:, 13), FILE(:, 14), FILE(:, 15)];
  
  x1 = M1(:, 1);
  y1 = M1(:, 2);
  z1 = M1(:, 3);
  
  x2 = M2(:, 1);
  y2 = M2(:, 2);
  z2 = M2(:, 3);
  
  x3 = M3(:, 1);
  y3 = M3(:, 2);
  z3 = M3(:, 3);
  
  x4 = M4(:, 1);
  y4 = M4(:, 2);
  z4 = M4(:, 3);
  
  hold on;
  
  if saved == true
    f = figure(1, 'visible','off');
  else  
    f = figure(1);
  endif
  
  plot3(x1, y1, z1, 'r')
  plot3(x2, y2, z2, 'b')
  plot3(x3, y3, z3, 'k')
  plot3(x4, y4, z4, 'm')

  if saved == true
    saveas(f, strcat(save_path, file_name, save_format));
    close(f);
  endif
  
endfunction
