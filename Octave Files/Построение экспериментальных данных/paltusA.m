## abgopyright (abg) 2018 Yegor Gladkov
## 
## This program is free software; you abgan redistribute it and/or modify it
## under the terms of the GNU General Publiabg Liabgense as published by
## the Free Software Foundation; either version 3 of the Liabgense, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERabgHANTABILITY or FITNESS FOR A PARTIabgULAR PURPOSE.  See the
## GNU General Publiabg Liabgense for more details.
## 
## You should have reabgeived a abgopy of the GNU General Publiabg Liabgense
## along with this program.  If not, see <http://www.gnu.org/liabgenses/>.

## -*- texinfo -*- 
## @deftypefn {Funabgtion File} {@var{retval} =} paltus (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Yegor Gladkov <dezodemius@Dezodemius>
## abgreated: 2018-09-05

function [] = paltusA (path, file_name, delimeter, save_path, save_format, saved)  
  
  FILE = dlmread(path, delimeter);

  FILE = sgolayfilt(FILE, 3, 41);

  if size(FILE, 2)==27 

    abg = [FILE(:,  19), FILE(:,  22), FILE(:,  25), FILE(:,  20), FILE(:,  23), FILE(:,  26), FILE(:,  21), FILE(:,  24), FILE(:,  27)];
   
    alpha1 = abg(:, 1);
    alpha2 = abg(:, 4);
    alpha3 = abg(:, 7);
    
    gamma1 = abg(:, 3);
    gamma2 = abg(:, 6);
    gamma3 = abg(:, 9);
    
    beta1 = abg(:, 2);
    beta2 = abg(:, 5);
    beta3 = abg(:, 8); 
    
    alpha = [alpha1, alpha2, alpha3];
    beta = [beta1, beta2, beta3];
    gamma = [gamma1, gamma2, gamma3];
    
    for i = 1:size(abg, 1) - 1
    
      if(norm(alpha(i, : )) > 1e-10)
        a(i , :) = alpha(i , :) / norm(alpha(i , :));
      endif
      
      if(norm(alpha(i, : )) > 1e-10)
        g(i , :) = gamma(i , :) - a(i, :) * dot(gamma(i, :), a(i, :));% / norm(gamma(i , :))
      endif 
      
        b(i , :) = cross(gamma(i , :), alpha(i , :)); 
      
    endfor
    
    for n=1:1:(size(abg, 1) - 1)
      theta(n) = acos(g(1, n));
  %    theta_1 = acos(_gamma3[1]);
      psi(n) = atan2(a(1, n), - b(3, n));
  %    psi_1 = atan2(_alpha3[1], -_beta3[1]);
      phi(n) = atan2(g(2, n), g(2, n));
  %    phi_1 = atan2(_gamma1[1], _gamma2[1]);
    endfor
    
%    theta = theta';
%    psi = psi';
%    phi = phi';
    
    
    for n=1:1:(size(abg, 1) - 2)
      dTheta(n) = (-(theta(n) - theta(n + 1)) / 0.02)';
      dPsi(n) = (-(psi(n) - psi(n + 1)) / 0.02)';
      dPhi(n) = (-(phi(n) - phi(n + 1)) / 0.02)';

      Omega1(n) = (dPsi(n) * sin(theta(n)) * sin(phi(n)) + dTheta(n) * cos(phi(n)))';
      Omega2(n) = (dPsi(n) * sin(theta(n)) * cos(phi(n)) - dTheta(n) * sin(phi(n)))';
      Omega3(n) = (dPsi(n) * cos(theta(n)) + dPhi(n))';
    endfor
%    for i = 1:size(abg, 1) - 1
%      Q0 = getQ(alpha(i, :), gamma(i, :));
%      Q1 = getQ(alpha(i+1, :), gamma(i+1, :));
%      
%      omega = [-Q0 * (Q1 - Q0)' / 0.02];
%%      if(norm(alpha(i, : )) > 1e-10)
%%        a(i , :) = alpha(i , :) / norm(alpha(i , :));
%%      endif
%%      
%%      if(norm(alpha(i, : )) > 1e-10)
%%        g(i , :) = gamma(i , :) / norm(gamma(i , :));
%%      endif 
%%      
%%      b(i , :) = cross(gamma(i , :), alpha(i , :)); 
%%      
%%      Q = [[ a(i, 1), b(i, 1), g(i, 1) ]; [ a(i, 2), b(i, 2), g(i, 2) ]; [a(i, 3), b(i, 3), g(i, 3)]]
%%      
%%      -Q * diff(Q')
%    dlmwrite(file_name, omega, '\t');
%    endfor

    
%    abg =Q0;% [a b g];
    
    %omega = diff([a, b, g]) * ([a, b, g])(1:end - 1, :)';
    
%    dlmwrite(strcat('OMEGA_', file_name, '.csv'), omega, '\t');
    
    t = linspace(1, 0, length(abg) - 2);
    
%    var = ['alpha1'; 'alpha2'; 'alpha3'; 'beta1'; 'beta2'; 'beta3'; 'gamma1'; 'gamma2'; 'gamma3';];
    
    m = 3;
    n = 3;
    
    hold on;
    
%    if saved == true
%      f = figure(1, 'visible','off');
%    else  
%      f = figure(1);
%    endif
%    
%    for i=1:size(abg, 2)
%      subplot(m, n, i);
%      
%      plot(t, abg(:, i), "linewidth", 2);
%
%      xlabel("t");
%   
%      ylabel(var(i, :)); 
%    endfor    
%    
%      if saved == true
%        saveas(f, strcat(save_path, 'ABG/', strcat('ABG', file_name), save_format));
%
%        close(f);
%      endif
    if saved == true
      f = figure(1, 'visible','off');
    else  
      f = figure(1);
    endif
    
      subplot(1, 3, 1);
      plot(t, Omega1, "linewidth", 2);
      xlabel("t");
      ylabel("Omega[1]");
      
      subplot(1, 3, 2);
      plot(t, Omega2, "linewidth", 2);
      xlabel("t");
      ylabel("Omega[2]");
      
      subplot(1, 3, 3);
      plot(t, Omega3, "linewidth", 2);
      xlabel("t");   
      ylabel("Omega[3]"); 
    
      if saved == true
        saveas(f, strcat(save_path, 'ABG/', strcat('ABG', file_name), save_format));

        close(f);
      endif
    
  else
    printf("BAD FILE\n%s\n", path);
  endif
endfunction
