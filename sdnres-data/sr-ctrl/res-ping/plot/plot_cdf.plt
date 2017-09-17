set title "Observed ping round-trip time"
set xlabel "Round-trip time (milliseconds)"
set ylabel "Measurements"
set term postscript enhanced color "Helvetica" 19
set output "ping_flap_cdf.eps"

set style line 1 lc rgb "green" pt 2 pi 800 ps 1.5

set xrange [0:30]
set xtics 2

plot "pingflapcdf.dat" using ($1):($2/8006) w lp ls 1 title "RTT"
