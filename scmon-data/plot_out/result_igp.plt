set title "Time to detect blackhole"
set xlabel "Time (milliseconds)"
set ylabel "Links"
set term postscript color "Helvetica" 19
set output "result_igp.eps"

set xrange [0:180]
set xtics 0,20,180
# set key at 171,0.8

set style line 1 lc rgb "dark-green" pt 2 pi 50 ps 1.5
set style line 2 lc rgb "blue" pt 4 pi 11 ps 1.5
set style line 3 lc rgb "red" pt 6 pi 24 ps 1.5
set style line 4 lc rgb "orange" pt 8 pi 10 ps 1.5
set style line 5 lc rgb "purple" pt 10 pi 19 ps 1.5

plot "rf1239_igp_result_cycle_plot.dat" using ($1*1000):($2/505) w lp ls 1 title "RF1239", "rf1755_igp_result_cycle_plot.dat" using ($1*1000):($2/118) w lp ls 2 title "RF1755", "rf3257_igp_result_cycle_plot.dat" using ($1*1000):($2/242) w lp ls 3 title "RF3257", "rf3967_igp_result_cycle_plot.dat" using ($1*1000):($2/103) w lp ls 4 title "RF3967", "ovh_result_cycle_plot.dat" using ($1*1000):($2/196) w lp ls 5 title "OVH-EUR"
