set boxwidth 0.5
set style fill solid
set xtics ("Plain IPv6" 0.25, "Encap" 1.75, "HMAC" 3.25)
set title "SRH insertion performances for 64-byte packets"
set ylabel "Average throughput (Kpps)"
set term png enhanced font "Helvetica" 12
set output "07_avg_mflows_noinline.png"

plot '07_avg_mflows_noinline.data' every 2 using 1:2 with boxes ls 6 title 'Multi-flows, 8 CPUs', '07_avg_mflows_noinline.data' every 2::1 using 1:2 with boxes lt 1 lc rgb "dark-red" title 'Single-flow, single CPU'
