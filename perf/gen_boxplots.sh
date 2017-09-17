#!/bin/bash

# 1st plot: nopatch

./plot_box.py "Performances comparison (unpatched)" plot_out/01_nopatch.pdf data_out/nopatch-plain-64:Plain data_out/nopatch-inline-64:Inline data_out/nopatch-encap-64:Encap

# 2nd plot: patched

./plot_box.py "Performances comparison (patched)" plot_out/02_patch.pdf data_out/plain-64:Plain data_out/inline-64:Inline data_out/encap-64:Encap

# 3rd plot: 1000 bytes

./plot_box.py "Performances comparison (1000B packets)" plot_out/03_1000B.pdf 'data_out/plain:Plain (1000)' 'data_out/plain-64:Plain (64)' 'data_out/inline:Inline (1000)' 'data_out/inline-64:Inline (64)' 'data_out/encap:Encap (1000)' 'data_out/encap-64:Encap (64)'

# 4th plot: hmac

./plot_box.py "Performances comparison (HMAC)" plot_out/04_hmac.pdf data_out/encap-64:Encap 'data_out/encap-hmac-generic-64:HMAC (generic)' 'data_out/encap-hmac-ssse3-64:HMAC (ssse3)'

# 5th plot is avg barplot

# 6th plot: multiflow
./plot_box.py "Performances comparison (multi-flow)" plot_out/06_mflows.pdf data_out/mflows-plain-64:Plain data_out/mflows-inline-64:Inline data_out/mflows-encap-64:Encap data_out/mflows-encap-hmac-ssse3-64:HMAC

# cd plot_out && for i in *.eps; do ps2pdf $i; done; cd ..
