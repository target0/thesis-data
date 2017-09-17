set title "Observed ping latency"
set xlabel "Time"
set ylabel "Latency (milliseconds)"
set term postscript enhanced color "Helvetica" 19
set output "ping_flap_zoom.eps"

set style line 1 lc rgb "green"

plot "pingflap_zoom.dat" w lp ls 1
