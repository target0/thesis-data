set title "Transaction time over homogeneous lossless paths"
set xlabel "Time (milliseconds)"
set ylabel "Requests"
set term postscript enhanced color "Helvetica" 19
set output "plot_out/dup_cdf_clean.eps"

# set term png enhanced font "Helvetica" 12
# set output "plot_out/dup_cdf.png"

# set logscale x

set style line 1 lc rgb "dark-green" pt 2 pi 1000 ps 1.5
set style line 2 lc rgb "blue" pt 4 pi 1000 ps 1.5
set style line 3 lc rgb "red" pt 6 pi 1000 ps 1.5

plot "data_out/nodup_clean.dat" using ($1/1000):($2/10000) w lp ls 1 title "No duplication", "data_out/dup_clean.dat" using ($1/1000):($2/10000) w lp ls 2 title "Duplication"
