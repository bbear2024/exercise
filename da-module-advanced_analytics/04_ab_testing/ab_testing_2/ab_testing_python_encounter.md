# AB testing with python
The second part of the AB testing topic is more hands on. Currently it consists of:
- test statistic selection 
- an example of comparing conversion rates with z-test and statsmodels
- an example of comparing means with t-test and scipy
- t-test online calculators with exercises
- sample size with an online calculator and exercises
As this is probably too much for a single encounter, it's probably not enough time to cover the sample size calculator during an encounter.

Come back to the example from the first part of the AB testing module - optimizing tips for a waitressing job. 
In the first part we focused on measuring the conversion rate for the tips - knowing if customers were willing to give a tip or not.
 
## Test statistics

*In hypothesis testing we always work with the same concept but depending on the metric we're testing and the population characteristics we might be using different test statistics.*
*Test statistics refer to different distribution functions and will have different assumptions about the data.*

***t-test***
*T-test, also named Student's test,and it's used when:*
*- the observations are normally distributed (or the sample size is large)*
*- the sampling distributions have similar variances*
*- appropriate for comparing means*

***z-test***
*- the sample is normally distributed*
*- we know the true characteristics of the populations (mean & standard deviation)*
*- appropriate for comparing means*

*Note: if the samples are large enough, even if not all the conditions are met, we go for z-test instead of t-test statistics*

***chi$^2$-test***
*- categorical values to compare*

***Welch's t-test***
*- similar to regular t-test but doesn't hold the requirement on the similar variances*

***Fisher's exact test***
*- used when comparing two binomial distributions such as a click-through rate*

*And many more...*

![test_statistics](../../../static/images/test_statistics.png)

*## Python packages in hypothesis testing*
*Besides the online calculators and other dedicated software we can also find supporting libraries in python. The two main libraries that share different hypothesis testing tools are: **statsmodels** and **scipy**.*

*### statsmodels*

*Statsmodels is heavily statistic oriented python module including an implementation of different statistical models, statistical testing tools and others.*

*#### Example - A/B test comparing conversion rates*

*Using the `proportions_ztest` function from the `statsmodels.stats.proportions` we can compare two conversion rates. The code below presents how to perform such a test for a dataset where you have two variants and a conversion column. Note that in order to perform this kind of a test we have to make sure that we meet the conditions.*

In the teaching materials you can find two datasets with conversion rates - tips_success.csv and tips_too_small_diff.csv that you could use for testing the hypothesis. The first one will give you a p-value that is small and the difference between the conversion rates will be bigger than 5 %. The second one brings a p-value bigger than 5% and a smaller diff in the conversion rates.

```python
import pandas as pd
from statsmodels.stats.proportion import proportions_ztest

tips = pd.read_csv('tips_success.csv')

tips_night = tips[tips['version'] == 'night']
tips_day = tips[tips['version'] == 'day']

n_night = len(tips_night)
n_day = len(tips_day)
successes = [tips_night.conversion.sum(), tips_day.conversion.sum()]
nobs = [n_night, n_day]

z_stat, pval = proportions_ztest(successes, nobs=nobs)

print(f'z statistic: {z_stat:.2f}')
print(f'p-value: {pval:.3f}')

```


*### Scipy package*

*This is gonna be a short python presentation of the t test that is comparing means.*

*Using the `ttest_ind` function from the `stats` module in the [scipy python package](https://scipy.org/)*

## Example - comparing means 
Imagine that instead of conversion rates for tips we measured how many tips on average in euros we are getting per day. In this case a t-test will be a perfect toll for us.

*The example below shows an independent two sided T-test from the stats module in the scipy package. It assumes a 95% significance value, i.e. if p-value > 0.05 we can not reject the null hypothesis that e.g. different penguin species have the same bill length, but if it is less, we can reject the null hypothesis and conclude that the two species of data have different true means. Note that in our case we have three species of penguins in the dataset which means that if we want to perform hypothesis testing we can only do it with two species at a time.*


```python
import scipy.stats as sps

tips = pd.read_csv('data/tips_means.csv')

tips_night = tips['night']
tips_day = tips['day']

test_statistic, pvalue = sps.ttest_ind(tips_day, tips_night)
print(f'average tips for day shift: {tips_day.mean()}')
print(f'average tips for night shift {tips_night.mean()}')
print (test_statistic, pvalue)
```
p value is showing us if the variants are significantly different and we still have to consider MEI (if the change is good enough for us).

#### Online calculators

During this encounter we will focus only on the t-test statistic so one calculator as well. You can mention that when they start searching for online calculators and formulas for performing hypothesis testing they might see that they require different inputs. That is related to the statistic that is used for the calculation. They still follow the same thinking process with the hypotheses and p value though.

*As we are not gonna perform any calculations by ourselves we will see two options how to calculate p value - online calculators and python scipy library.*

*This is an examples of an online calculator that uses t statistics:*
*- [t-test online calculator](https://www.medcalc.org/calc/comparison_of_means.php)*

This is probably a good time for a break ;)

## Exercise: Parameters changes in a statistical test

Divide the students into 3 or 6 groups (6 if the group is big and you can give the same question to two groups). Assign every group a question from the list below. Give them a few mins to experiment and discuss the results together:

*- How is the **p-value** in a t-test affected by (hint: use this [online calculator](https://www.medcalc.org/calc/comparison_of_means.php) to help you)*
  *1. the difference between the means of the two groups*
  A: the bigger the diff, the smaller p value is
  *2. the variance (or the standard deviation) of the two samples*
  A: the bigger the variance, the bigger the p value is
  *3. the size of the samples*
  A: the bigger sample size, the smaller p value is



## Collection of Samples

You can just very briefly mention that if you have already designed the experiment you can start the measurement part of it. 

*In this step, we set up the A/B test and collect the samples of the two groups. The amount of data that is needed to collect depends on all, the **significance level** and the **test power**, and the **MEI** we decide upon before running the A/B test. The smaller the difference between the two groups we aim to detect, the more data we need to collect.*

### Online calculators for sample size

Explain the sample size calculation.

*Similarly to the test statistics, there are also online calculators for computing sample size of datapoints that you should gether:*
*- [abtestguide sample size online calculator](https://abtestguide.com/abtestsize/)*

*Parameters changes in a statistical test part 2*

*- How is the sample size needed for the test affected by (hint use this [online calculator](https://abtestguide.com/abtestsize/) to help you):*
  *1. relative MEI*
  A: the bigger MEI the smaller sample size
  *2. test power*
  A: the bigger test power, the bigger sample size
  *3. significance level*
  A: the bigger significance level, the bigger sample size

  *How can you estimate number of weeks needed to run the experiment?*


