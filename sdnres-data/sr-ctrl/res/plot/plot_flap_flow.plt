set title "Flow recomputation time over 1,000 random link flaps"
set xlabel "Time (milliseconds)"
set ylabel "Recomputations"
set term postscript enhanced color "Helvetica" 19
set output "flap_flow.eps"

set logscale x

set style line 1 lc rgb "green" pt 2 pi 8950 ps 1.5
set style line 2 lc rgb "blue" pt 4 pi 28920 ps 1.5
set style line 3 lc rgb "red" pt 6 pi 34028 ps 1.5
set style line 4 lc rgb "orange" pt 8 pi 429253 ps 1.5
set style line 5 lc rgb "purple" pt 10 pi 911623 ps 1.5

plot "flap_flow_01k.dat" using ($1):($2/89507) w lp ls 1 title "1,000 flows", "flap_flow_05k.dat" using ($1):($2/289201) w lp ls 2 title "5,000 flows", "flap_flow_10k.dat" using ($1):($2/340282) w lp ls 3 title "10,000 flows", "flap_flow_50k.dat" using ($1):($2/4292530) w lp ls 4 title "50,000 flows", "flap_flow_100k.dat" using ($1):($2/9116234) w lp ls 5 title "100,000 flows"
