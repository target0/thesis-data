set title "Request completion time with 4 worker threads"
set xlabel "Time (milliseconds)"
set ylabel "Requests"
set term postscript enhanced color "Helvetica" 19
set output "bench_4t.eps"

set logscale x

set style line 1 lc rgb "dark-green" pt 2 pi 1000 ps 1.5
set style line 2 lc rgb "blue" pt 4 pi 1000 ps 1.5
set style line 3 lc rgb "red" pt 6 pi 1000 ps 1.5
set style line 4 lc rgb "orange" pt 8 pi 1000 ps 1.5

plot "bench_02k_4t.dat" using ($1):($2/10000) w lp ls 1 title "2,000 req/s", "bench_04k_4t.dat" using ($1):($2/10000) w lp ls 2 title "4,000 req/s", "bench_10k_4t.dat" using ($1):($2/10000) w lp ls 3 title "10,000 req/s"
