# recdevanomaly
Stock assessment methods in the face of anomalous recruitment events

A Monte Carlo simulation with [ss3sim](www.github.com/ss3sim/ss3sim) to assess the effects of anomalous recruitment events on the performance of age-structured stock assessment models. Where the results will be presented at the [Center for the Advancement of Population Assessment Methodology](http://www.capamresearch.org) workshop on [recruitment](http://www.capamresearch.org/workshops), October 30th-November 3rd, 2017, and submitted to the special issue of Fisheries Research.

Privitera-Johnson, K., and Johnson, K.F. (in prep). The effects of anomalous recruitment events on the output of age-structured stock assessment models. [Fisheries Research](https://www.elsevier.com/journals/fisheries-research/0165-7836/guide-for-authors), 00(00): 00-00.

## To do
- [ ] Look at estimated recruitment of [POP](https://github.com/CWetzel/POP_2017) and see how large in magnitude the later 201? recruitment events were. KPJ
- [ ] Document sigma_r of long- and medium lived species to see if we should look at multiple values. KPJ
- [x] get Fisheries Research csl. KFJ
- [ ] Write R code to run a single model with case files. KFJ
- [ ] Introduction. KPJ
- [ ] Abstract (due August 31st). KFJ KPJ

## Scenarios

* Fishing
    * Constant
    * Fished down and recovering
  * Life history
    * Long
    * Med
  * Sigma_r
    * high
    * medium
    * low
  * Recruitment
    * lognormal
    * single-year event - e.g., seq(125, 200, length.out = 5) % larger than the maximum simulated value, inform these values from assessment values.
    * positively autocorrelated multi-year event with same magnitude as single year
    * autocorrelated recruitment
  * Data (mainly survey data)
    * Data rich - 100 samples of age and length per year
    * Data limited - 10 samples of lengths every other year

  ## Case study - POP

  The POP assessment files will be useful if we find a method that helps estimate the large recruitment event. Then we can take the new method and apply it to the 2017 POP assessment and see if the management quantities change.


