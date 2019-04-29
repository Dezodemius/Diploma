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

function [] = paltusV (path, file_name, delimeter, save_path, save_format, saved)  
  FILE = dlmread(path, delimeter);

  %FILE = sgolayfilt(FILE, 3, 41);

  C = [FILE(:,  17), FILE(:,  18), FILE(:,  19)];
  
  maxSeqValue = 1.0;
  minSeqValue = 0.0;
  
  x = C(:, 1);
  y = C(:, 2);
  z = C(:, 3);
  
  var = ['Vx'; 'Vy'; 'Vz'];
  
  h = (maxSeqValue + minSeqValue) / (length(C) - 2);

  for i=2:length(x) - 1
    v_x(i) = (x(i + 1) - x(i - 1)) / (2.0 * h);
    
    v_y(i) = (y(i + 1) - y(i - 1)) / (2.0 * h);
    
    v_z(i) = (z(i + 1) - z(i - 1)) / (2.0 * h);
  endfor
  
  V = [v_x', v_y', v_z'];
  C = [x y z];
  m = 3;
  n = 1;
  
  hold on;
  
  if saved == true
    f = figure(1, 'visible','off');
  else  
    f = figure(1);
  endif
  
  t = (0:length(v_x) - 1) * h;
  
  
  for i = 1:size(C, 2)
    subplot(m, n, i);
    
    plot(t', sgolayfilt(V(:, i), 3, 41), "linewidth", 2);
  
    xlabel("t");
 
    ylabel(var(i, :))
  endfor    
  
    if saved == true
      saveas(f, strcat(save_path, 'Velocities/' ,strcat("Velocities", file_name), save_format));

      close(f);
    endif
endfunction