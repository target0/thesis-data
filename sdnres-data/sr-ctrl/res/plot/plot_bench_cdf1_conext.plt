set title "Request completion time with 1 worker thread"
set xlabel "Time (milliseconds)"
set ylabel "Requests"
set term postscript enhanced color "Helvetica" 30
set output "bench_1t.eps"

set logscale x
set key center center opaque box

set style line 1 lc rgb "dark-green" pt 2 pi 1000 ps 3
set style line 2 lc rgb "blue" pt 4 pi 1000 ps 3
set style line 3 lc rgb "red" pt 6 pi 1000 ps 3
set style line 4 lc rgb "orange" pt 8 pi 1000 ps 3

plot "bench_02k_1t.dat" using ($1):($2/10000) w lp ls 1 title "2k req/s", "bench_04k_1t.dat" using ($1):($2/10000) w lp ls 2 title "4k req/s", "bench_10k_1t.dat" using ($1):($2/10000) w lp ls 3 title "10k req/s"
