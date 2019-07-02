set terminal eps enhanced size 10cm,10cm font 'Times-Roman,12'
set style line 12 dashtype 2 lc 'black'
set grid xtics, ytics ls 12
set output 'sigmoid.eps'
set xlabel 'x'
set ylabel 'f(x)'
set key top left
set xrange [-5:5]
plot 1/(1+0.5 * exp(-x)) title '{/Symbol a} = 0.5' w l lw 2 lc 'black',\
    1/(1+exp(-x)) title '{/Symbol a} = 1.0' w l lw 2 lc 'red',\
    1/(1+2*exp(-x)) title '{/Symbol a} = 2.0' w l lw 2 lc 'blue'
set output 'tanh.eps'
set xlabel 'x'
set ylabel 'f(x)'
set key top left
set xrange [-3:3]
plot tanh(x) title '{/Symbol a} = 1' w l lw 2 lc 'black',\
    tanh(2*x) title '{/Symbol a} = 2' w l lw 2 lc 'red',\
    tanh(5*x) title '{/Symbol a} = 5' w l lw 2 lc 'blue'
set output 'relu.eps'
set xlabel 'x'
set ylabel 'f(x)'
set key top left
set xrange [-1:1]
set yrange [-1:1]
f(x) = x<=0 ? 0 : x
plot f(x) notitle w l lw 2 lc 'black'

