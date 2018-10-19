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

function [] = paltusC (path, file_name, delimeter, save_path, save_format, saved)  
  FILE = dlmread(path, delimeter);

  %FILE = sgolayfilt(FILE, 3, 41);

  C = [FILE(:,  17), FILE(:,  18), FILE(:,  19)];

  t = linspace(1, 0, length(C));
  
  var = ['X'; 'Y'; 'Z'];
  
  m = 3;
  n = 1;
  
  hold on;
  
  if saved == true
    f = figure(1, 'visible','off');
  else  
    f = figure(1);
  endif
  
  for i=1:size(C, 2)
    subplot(m, n, i);
    
    plot(t, C(:, i), "-ob", "markersize", 0.5, "linewidth", 2);
    
    plot(t, C(:, i), "-ok", "markersize", 2, "linewidth", 1);
  
    xlabel("t");
 
    ylabel(var(i, :)); 
  endfor    
  
    if saved == true
      saveas(f, strcat(save_path, strcat('Center', file_name), save_format));

      close(f);
    endif
endfunction
