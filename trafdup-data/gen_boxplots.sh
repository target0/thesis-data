#!/bin/bash

# 1st plot: 5_5

./plot_box.py "RTT1=10ms, RTT2=10ms" dl_plot_out/dl01_5_5.pdf dl_data_out/01_01_5_5_L1.dat:1 dl_data_out/01_02_5_5_L2.dat:2 dl_data_out/01_03_5_5_L3.dat:3 dl_data_out/01_04_5_5_L4.dat:4 dl_data_out/01_05_5_5_L5.dat:5 dl_data_out/01_06_5_5_L10.dat:10

./plot_box.py "RTT1=10ms, RTT2=20ms" dl_plot_out/dl02_10_20.pdf dl_data_out/02_01_10_20_L1.dat:1 dl_data_out/02_02_10_20_L2.dat:2 dl_data_out/02_03_10_20_L3.dat:3 dl_data_out/02_04_10_20_L4.dat:4 dl_data_out/02_05_10_20_L5.dat:5 dl_data_out/02_06_10_20_L10.dat:10

./plot_box.py "RTT1=10ms, RTT2=50ms" dl_plot_out/dl03_10_50.pdf dl_data_out/03_01_10_50_L1.dat:1 dl_data_out/03_02_10_50_L2.dat:2 dl_data_out/03_03_10_50_L3.dat:3 dl_data_out/03_04_10_50_L4.dat:4 dl_data_out/03_05_10_50_L5.dat:5 dl_data_out/03_06_10_50_L10.dat:10

./plot_box.py "RTT1=10ms, RTT2=100ms" dl_plot_out/dl04_10_100.pdf dl_data_out/04_01_10_100_L1.dat:1 dl_data_out/04_02_10_100_L2.dat:2 dl_data_out/04_03_10_100_L3.dat:3 dl_data_out/04_04_10_100_L4.dat:4 dl_data_out/04_05_10_100_L5.dat:5 dl_data_out/04_06_10_100_L10.dat:10
