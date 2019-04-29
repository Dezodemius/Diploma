function res = ge(x)
  res = [dot(x(1):x(3), x(4):x(6)), dot(x(1):x(3), x(1):x(3)) - 1, dot(x(4):x(6), x(4):x(6)) - 1];
endfunction