set title "Transaction time over heterogeneous paths"
set xlabel "Time (milliseconds)"
set ylabel "Requests"
set term postscript enhanced color "Helvetica" 19
set output "plot_out/dup_cdf.eps"

# set term png enhanced font "Helvetica" 12
# set output "plot_out/dup_cdf.png"

set logscale x

set style line 1 lc rgb "dark-green" pt 2 pi 1000 ps 1.5
set style line 2 lc rgb "blue" pt 4 pi 1000 ps 1.5
set style line 3 lc rgb "red" pt 6 pi 1000 ps 1.5

plot "data_out/nodup_delay5.dat" using ($1/1000):($2/10000) w lp ls 2 title "RTT=20ms, Loss=0%", "data_out/nodup_loss10.dat" using ($1/1000):($2/10000) w lp ls 3 title "RTT=10ms, Loss=10%", "data_out/dup_loss10_delay5.dat" using ($1/1000):($2/10000) w lp ls 1 title "Duplication"
