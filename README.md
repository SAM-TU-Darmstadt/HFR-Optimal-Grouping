# HFR-Optimal-Groupings

This repository contains research results on efficient groupings for the Hybrid FAST RBD (HFR) method in sensitivity analysis. The goal is to minimize the number of samples required in Design of Experiments (DoE) by discovering new optimal groupings using a brute-force algorithm.

## Contents

- `brute_force_hfr.m`  
  Matlab implementation of the brute-force algorithm to search for valid groupings in HFR sensitivity analysis.

- `results_q4.mat`  
  Found optimal groupings and performance data for q = 4 (i.e., 16 input parameters).

- `results_q8.mat`  
  Found optimal groupings and performance data for q = 8 (i.e., 64 input parameters).

## Summary

The algorithm searches for valid groupings of input parameters in HFR, especially for non-prime square values of q, where no optimal groupings were previously documented. This can reduce the number of required samples by up to 36% without losing evidence.

## Citation

If you use this code or data, please cite the following research:  
S. Wenzel, E. Slomski-Vetter and T. Melz, *An Efficient Design of Experiments Using RBD-Fast*, in: WCCM-ECCOMAS2020.  
URL: https://www.scipedia.com/public/Wenzel_et_al_2021a

## License

MIT License
