# GPCCPaper


## Experiments - all use matern32 kernel

### Experiment with synthetic data

We generate synthetic data  that conform to the model with increasing noise levels. Note how spurious peaks arise with increasing noise. In the presence of low noise (up to about σ=1.0), the true peak at 2 days is the incontestable winner. Beyond that, other peaks start to appear as potential candidates.

![exp1](results/Synthetic/exp1_results.svg)


### Information for real data

#object   | v   |  ev |  mass | emass |  delay|edelay | z     |
| ------- | --- | --- | ----- | ----- | ----- | ----- | ----- |
Mrk335	  |1293 | 64  | 4.6e6 | 0.5e6 | 14.0  |  0.9  | 0.0258| 
Mrk1501   |3321 | 107 | 33.4e6| 4.9e6 | 13.8  |  5.4  | 0.0893|
3C120     |1514 | 65  | 12.2e6| 1.2e6 | 25.6  |  2.4  | 0.0330|
Mrk6      |3714 | 68  | 24.8e6| 2.3e6 | 10.2  |  1.2  | 0.0188|
PG2130099 |1825 | 65  | 8.3e6 | 0.7e6 | 9.7   |  1.3  | 0.0630|


### Mrk335

![Mrk335](results/Virial/Mrk335_delays.png)

![Mrk335](results/Virial/Mrk335_align_13.15.png)

![Mrk335](results/Virial/Mrk335_align_85.42.png)

![Mrk335](results/Virial/Mrk335_align_104.7.png)


### Mrk1501

![Mrk1501](results/VirialMass/Mrk1501_results.svg)

### 3C120

![3C120](results/Virial/3C120_delays.png)

![3C120](results/Virial/3C120_align_23.39.png)

### Mrk6

![Mrk6](results/VirialMass/Mrk6_results.svg)

### PG2130099

![PG2130099](results/VirialMass/PG2130099_results.svg)
