set title "Observed ping round-trip time"
set xlabel "Time (seconds)"
set ylabel "Round-trip time (milliseconds)"
set term postscript enhanced color "Helvetica" 19
set output "ping_flap_zoom3.eps"

set xrange [0:2.1]
set xtics 0.2

set yrange [0:25]
set ytics 2

set style line 1 lc rgb "green"

plot "pingflap_zoom3.dat" using ($1/100):($2) w lp ls 1 title "RTT"
