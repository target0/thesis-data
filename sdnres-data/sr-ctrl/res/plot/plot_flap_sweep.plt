set title "Conversation states sweep time over 1,000 random link flaps"
set xlabel "Time (milliseconds)"
set ylabel "Sweeps"
set term postscript enhanced color "Helvetica" 19
set output "flap_sweep.eps"

set style line 1 lc rgb "dark-green" pt 2 pi 85 ps 1.5
set style line 2 lc rgb "blue" pt 4 pi 85 ps 1.5
set style line 3 lc rgb "red" pt 6 pi 86 ps 1.5
set style line 4 lc rgb "orange" pt 8 pi 84 ps 1.5
set style line 5 lc rgb "purple" pt 10 pi 85 ps 1.5

plot "flap_sweep_01k.dat" using ($1):($2/858) w lp ls 1 title "1,000 conv.", "flap_sweep_05k.dat" using ($1):($2/852) w lp ls 2 title "5,000 conv.", "flap_sweep_10k.dat" using ($1):($2/860) w lp ls 3 title "10,000 conv.", "flap_sweep_50k.dat" using ($1):($2/847) w lp ls 4 title "50,000 conv.", "flap_sweep_100k.dat" using ($1):($2/851) w lp ls 5 title "100,000 conv."
