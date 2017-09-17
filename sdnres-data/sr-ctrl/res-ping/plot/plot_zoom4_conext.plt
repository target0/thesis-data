set title "Observed ping round-trip time"
set xlabel "Time (milliseconds)"
set ylabel "Round-trip time (milliseconds)"
set term postscript enhanced color "Helvetica" 30
set output "ping_flap_zoom4.eps"

set xrange [0:800]
set xtics 100

set yrange [0:25]
set ytics 2

set style line 1 lc rgb "dark-green"

set arrow from 80,0 to 80,25 nohead lc rgb "red"
set arrow from 110,4 to 110,25 nohead lc rgb "blue"

set label "Link down" at 90,2 font "Helvetica,30"
set label "IGP conv." at 120,6 font "Helvetica,30"

set arrow from 170,20 to 200,22 backhead lc rgb "black"
set label "Controller\n update" at 205,23 font "Helvetica,30"

set arrow from 410,0 to 410,25 nohead lc rgb "red"
set arrow from 440,4 to 440,25 nohead lc rgb "blue"

set label "Link up" at 420,2 font "Helvetica,30"
set label "IGP conv." at 450,6 font "Helvetica,30"

set arrow from 490,14 to 520,16 backhead lc rgb "black"
set label "Controller\n update" at 525,17 font "Helvetica,30"

plot "pingflap_zoom4.dat" using ($1*10):($2) w lp ls 1 title "RTT"
