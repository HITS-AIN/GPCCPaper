# GPCCPaper

Results obtained with [GPCC.jl](https://github.com/ngiann/GPCC.jl) using data available in [GPCCData.jl](https://github.com/ngiann/GPCCData.jl).

## Experiments

### ▶ Experiment with synthetic data

We generate synthetic data  that conform to the model with increasing noise levels. Note how spurious peaks arise with increasing noise. In the presence of low noise), the true peak at 2 days is the incontestable winner. Beyond that, other peaks start to appear as potential candidates.

![exp1_lightcurves](plots/Synthetic/Synthetic_lightcurves.svg)
![exp1_delays_vs_prob](plots/Synthetic/Synthetic_delays_vs_prob.svg)


Let us look closer the case $\sigma=0.2$. We see that there are two peaks: the true peak at $\sim 2$ and a second higher peak at $\sim 13.8$
We align the light curves according to these two candidate delays. We note that the second peak, which is not the true peak, does lead to a plausible alignment.

![exp1_peak_2](plots/Synthetic/Synthetic_sigma_0.2_peak_2.0.svg)
![exp1_peak_13.8](plots/Synthetic/Synthetic_sigma_0.2_peak_13.8.svg)

### ▶ Virial datasets


#object   | v   |  ev |  mass | emass |  delay|edelay | z     |
| ------- | --- | --- | ----- | ----- | ----- | ----- | ----- |
Mrk335	  |1293 | 64  | 4.6e6 | 0.5e6 | 14.0  |  0.9  | 0.0258| 
Mrk1501   |3321 | 107 | 33.4e6| 4.9e6 | 13.8  |  5.4  | 0.0893|
3C120     |1514 | 65  | 12.2e6| 1.2e6 | 25.6  |  2.4  | 0.0330|
Mrk6      |3714 | 68  | 24.8e6| 2.3e6 | 10.2  |  1.2  | 0.0188|
PG2130099 |1825 | 65  | 8.3e6 | 0.7e6 | 9.7   |  1.3  | 0.0630|



- [Mrk335 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/9dd173fde3bf9330eede4dbe0b85202b5a3f4e67/plots/Virial/results_GPCCv0.1.23_Mrk335_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html) ([zoom 0-50](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/4edc82089228f3f93810d5c34cb6fa817188afc0/plots/Virial/results_globalnoiseterm_0_50_Mrk335_rho_1000_K_OU_Dt_0.2_R_15.jld2_delays_vs_prob.html))

- [Mrk1501 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/bfeef3154cbde25832a4c0ed42ee529a95a20574/plots/Virial/results_GPCCv0.1.23_Mrk1501_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html)
([zoom 0-50](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/4edc82089228f3f93810d5c34cb6fa817188afc0/plots/Virial/results_globalnoiseterm_0_50_Mrk1501_rho_1000_K_OU_Dt_0.2_R_15.jld2_delays_vs_prob.html))


- [3C120 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/9dd173fde3bf9330eede4dbe0b85202b5a3f4e67/plots/Virial/results_GPCCv0.1.23_3C120_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html)
([zoom 0-50](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/4edc82089228f3f93810d5c34cb6fa817188afc0/plots/Virial/results_globalnoiseterm_0_50_3C120_rho_1000_K_OU_Dt_0.2_R_15.jld2_delays_vs_prob.html))


- [Mrk6 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/9dd173fde3bf9330eede4dbe0b85202b5a3f4e67/plots/Virial/results_GPCCv0.1.23_Mrk6_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html)
([zoom 0-50](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/dff05f430c5372ba6bdfb58492970fb0130a1919/plots/Virial/results_globalnoiseterm_0_50_Mrk6_rho_1000_K_OU_Dt_0.2_R_15.jld2_delays_vs_prob.html))


- [PG2130099 with OU kernel](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/9dd173fde3bf9330eede4dbe0b85202b5a3f4e67/plots/Virial/results_GPCCv0.1.23_PG2130099_rho_10000_K_OU_Dt_0.2_R_13.jld2_delays_vs_prob.html) ([zoom 0-50](https://rawcdn.githack.com/HITS-AIN/GPCCPaper/4edc82089228f3f93810d5c34cb6fa817188afc0/plots/Virial/results_globalnoiseterm_0_50_PG2130099_rho_1000_K_OU_Dt_0.2_R_15.jld2_delays_vs_prob.html))
