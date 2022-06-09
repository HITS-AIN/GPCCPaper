# GPCCPaper

Results obtained with [GPCC.jl](https://github.com/ngiann/GPCC.jl) using data available in [GPCCData.jl](https://github.com/ngiann/GPCCData.jl).

## Experiments

### Experiment with synthetic data

We generate synthetic data  that conform to the model with increasing noise levels. Note how spurious peaks arise with increasing noise. In the presence of low noise (up to about σ=1.0), the true peak at 2 days is the incontestable winner. Beyond that, other peaks start to appear as potential candidates.

![exp1](plots/Synthetic/exp1_results.svg)

### Virial datasets


#object   | v   |  ev |  mass | emass |  delay|edelay | z     |
| ------- | --- | --- | ----- | ----- | ----- | ----- | ----- |
Mrk335	  |1293 | 64  | 4.6e6 | 0.5e6 | 14.0  |  0.9  | 0.0258| 
Mrk1501   |3321 | 107 | 33.4e6| 4.9e6 | 13.8  |  5.4  | 0.0893|
3C120     |1514 | 65  | 12.2e6| 1.2e6 | 25.6  |  2.4  | 0.0330|
Mrk6      |3714 | 68  | 24.8e6| 2.3e6 | 10.2  |  1.2  | 0.0188|
PG2130099 |1825 | 65  | 8.3e6 | 0.7e6 | 9.7   |  1.3  | 0.0630|



- [Mrk335 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/9dd173fde3bf9330eede4dbe0b85202b5a3f4e67/plots/Virial/results_GPCCv0.1.23_Mrk335_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html)

- [Mrk1501 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/bfeef3154cbde25832a4c0ed42ee529a95a20574/plots/Virial/results_GPCCv0.1.23_Mrk1501_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html)

- [3C120 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/9dd173fde3bf9330eede4dbe0b85202b5a3f4e67/plots/Virial/results_GPCCv0.1.23_3C120_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html)

- [Mrk6 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/9dd173fde3bf9330eede4dbe0b85202b5a3f4e67/plots/Virial/results_GPCCv0.1.23_Mrk6_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html)

- [PG2130099 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/9dd173fde3bf9330eede4dbe0b85202b5a3f4e67/plots/Virial/results_GPCCv0.1.23_PG2130099_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html)
