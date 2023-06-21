# ClusterCV
# Language: R
# Input: TXT
# Output: PREFIX
# Tested with: PluMA 2.0, R 4.0.0
# Dependencies: [1] clusterGeneration_1.3.7 plotly_4.10.1           mixOmics_6.14.1
# [4] ggplot2_3.4.0           lattice_0.20-45         MASS_7.3-58.1


PluMA plugin that tests PLSDA performance.

Input is a tab-delimited file of keyword-value pairs:

ncomp   number of components
nSSFrom nonsignal from
nSSTo   nonsignal to
nSSInc  nonsignal increment
sSSFrom signal from
sSSTo   signal to
sSSInc  signal increment
nRepetitions    number of repetitions
nSignals        number of signals

Output will be a CSV file of PLSDA performance across all repetitions
