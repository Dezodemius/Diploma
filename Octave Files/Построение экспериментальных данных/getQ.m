function Q = getQ(alpha, gamma)

      if(norm(alpha) > 1e-10)
        a = alpha / norm(alpha);
      endif
      
      if(norm(alpha) > 1e-10)
        g = gamma / norm(gamma);
      endif 
      
      b = cross(gamma, alpha); 
      
      Q = [ a' b' g' ];

end