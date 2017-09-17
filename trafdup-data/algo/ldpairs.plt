set title "Possible disjoint paths in real network topologies"
set xlabel "Number of link disjoint paths"
set ylabel "Pairs of nodes"
set term postscript enhanced color "Helvetica" 19
set output "ldpairs.eps"

set xrange [-1:12]
set xtics ("1" 0.375, "2" 2.375, "3" 4.375, "4" 6.375, "5" 8.375, "6" 10.375)

set boxwidth 0.25
set style fill pattern border

plot "ldpairs_rf1239.dat" w boxes fill pattern 1 lc rgb "dark-green" title "RF1239", "ldpairs_rf1755.dat" w boxes fill pattern 2 lc rgb "blue" title "RF1755", "ldpairs_rf3257.dat" w boxes fill pattern 4 lc rgb "red" title "RF3257", "ldpairs_rf3967.dat" w boxes fill pattern 6 lc rgb "orange" title "RF3967"
