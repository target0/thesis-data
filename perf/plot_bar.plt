set title "SRH insertion performances for 64-byte packets"
set ylabel "Average throughput (Kpps)"
set term postscript color "Helvetica" 19
set output "05_avg.eps"

set boxwidth 0.5
set style fill pattern border

set xtics ("Plain IPv6" 0, "Inline" 1, "Encap" 2, "HMAC" 3)

plot '05_avg.data' using 1:2 with boxes fill pattern 1 lc rgb "blue" title 'Single-flow, single CPU'
