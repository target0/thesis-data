set title "SRH insertion performances for 64-byte packets"
set ylabel "Average throughput (Kpps)"
set term postscript color "Helvetica" 19
set output "07_avg_mflows.eps"

set xtics ("Plain IPv6" 0.25, "Inline" 1.75, "Encap" 3.25, "HMAC" 4.75)

set boxwidth 0.5
set style fill pattern border

plot '07_avg_mflows.data' every 2 using 1:2 with boxes fill pattern 1 lc rgb "dark-red" title 'Multi-flows, 8 CPUs', '07_avg_mflows.data' every 2::1 using 1:2 with boxes fill pattern 2 lc rgb "blue" title 'Single-flow, single CPU'
