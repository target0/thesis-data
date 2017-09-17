set title "Observed ping latency"
set xlabel "Time"
set ylabel "Latency (milliseconds)"
set term postscript enhanced color "Helvetica" 19
set output "ping_flap.eps"

set style line 1 lc rgb "green"

plot "pingflap100.dat" w lp ls 1
