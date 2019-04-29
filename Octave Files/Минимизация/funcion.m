function res = funcion(x)
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
  
  res = dot(x(1:3), k(1, : )) / norm(k(1, : )) + dot(x(4:6), n(1, : )) / norm(n(1, : )) + dot(cross(x(1:3), x(4:6)), kn(1, : )) / norm(kn(1, : ));
endfunction