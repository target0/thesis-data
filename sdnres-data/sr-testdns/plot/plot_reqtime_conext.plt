set title "Conversation request completion time over 1,000 requests"
set xlabel "Time (milliseconds)"
set ylabel "Requests"
set term postscript enhanced color "Helvetica" 30
set output "srdns_reqtime.eps"

set xrange [0:150]
set xtics 0,15,90
set key right center opaque box

set style line 1 lc rgb "dark-green" pt 2 pi 100 ps 3
set style line 2 lc rgb "blue" pt 4 pi 100 ps 3
set style line 3 lc rgb "red" pt 6 pi 100 ps 3
set style line 4 lc rgb "orange" pt 8 pi 100 ps 3
set style line 5 lc rgb "purple" pt 10 pi 100 ps 3

plot "testdns-res-dns-1ms.dat" using ($1):($2/1000) w lp ls 1 title "DNS (6ms)", "testdns-res-sr-1ms.dat" using ($1):($2/1000) w lp ls 2 title "SRDNS (6ms)", "testdns-res-dns-5ms.dat" using ($1):($2/1000) w lp ls 3 title "DNS (30ms)", "testdns-res-sr-5ms.dat" using ($1):($2/1000) w lp ls 4 title "SRDNS (30ms)"
