# Bayesian Registration of Functional Data

Functional data often present a common shape, but with variation in amplitude and phase across curves. <br/>
The goal of this project is to synchronize data through curve registration in a Bayesian framework. <br/>
We propose a three-stage hierarchical model - it models both amplitude and timing of features in the individual curves in order to find a warping function that synchronizes all the data.

## Dataset 

Data are a collection of observations regarding the flexion-extension angle during one leg hoop over time. <br/>
They are divided into three groups: [healthy people](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Original%20Healthy.pdf), people who had [physiotherapy](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Original%20Physioterapy.pdf) and people who had [surgery](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Original%20Surgery.pdf). <br/>
Unfortunately, we are not allowed to upload the original data-set, since these data are medical records.  <br/> Anyway, [Here](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/Import%20data.R) is the code we used to preprocess original data.  <br/>
In order to let you run the code we developed, we built up a set of [fake-observations](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Simulated%20Functions.pdf). You can find them in [Simulated Functions](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/simulated_functions.R) code.


## Model 

We implemented a Gibbs Sampler algorithm with one step of Metropolis-Hastings for the time transformation parameters.
Consider: <br/> <br/> 
![alt text](https://github.com/PrincipeFederica/hello-world/blob/main/Schermata%202021-02-11%20alle%2021.49.54.png)  <br/>
And the composite function: <br/>
![alt text](https://github.com/PrincipeFederica/hello-world/blob/main/model2.png) <br/>
The observed value of each curve i at time t is modeled as: <br/>
![alt text](https://github.com/PrincipeFederica/hello-world/blob/main/model3.png) <br/>
We assumed the error terms to be independent and normally distributed with null mean and common variance &sigma;^2.  <br/>
In the end, we identify the i-th aligned curve at time t as: <br/>
![alt text](https://github.com/PrincipeFederica/hello-world/blob/main/Schermata%202021-02-11%20alle%2021.59.10.png) <br/>


If you are insterested in a more detailed description of the model, please rely on the [report](link) uploaded in the repository.


## Contents and structure of the codes

- *[Data preprocessing](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/Import%20data.R)*: import and visualization of the dataset
- *[Simulated Data](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/simulated_functions.R)*: <br/>
we simulated a set of smooth curves as transformations of a common Beta density function. We first checked the algorithm by applying it to data obtained from the same base function modified just via shape parameters. Secondly to data obtained from the same base function modified just via time transformation parameters. Finally we switched to the original simulated data. You can check the algorithm for the [alignment](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/aligned_curves.R) and see the application of the alignment to the fake curves [here](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Simulated%20Functions%20Aligned.pdf).
- *Metropolis-Hastings step* : <br/>
In the folder Code, specifically in [this](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/Gibbs%20sampler_one%20step%20Metropolis.R) file you can find the implementation of the Metropolis-Hastings step for the setting of proposal variance for the time transformation parameters;
- *Gibbs Sampler* : <br/>
application of the [Gibbs sampler algorithm](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/Gibbs%20sampler_one%20step%20Metropolis.R) with one step of Metropolis-Hastings to the data;
- *Chain convergence* : analysis of the chains. <br/>
In the file [Posterior Plots](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/Posterior%20Plots.R) you can see the code to plot histograms with densities, traceplots and autocorrelation for the posterior distributions.
- *Comparison* : <br/>
We are aware that you have no access to original data and in particular to the three different groups, but we thought it could be interesting to take a look at it anyway. You can find the alignment applied to the three groups' original curves in their relative plots, [Aligned Healthy](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Aligned%20Healthy.pdf), [Aligned Physioterapy](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Aligned%20Physioterapy.pdf) and [Aligned Surgery](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Aligned%20Surgery.pdf).<br/>
Do people who had surgery have less or more difficulty in jumping with respect to people who had physiotherapy? We tried to answer to this question and more.<br/>
In order to do this, we performed analysis such as the comparison of
   - the posterior shape parameter *a*, 
   - the *posterior mean derivative* of each group. You can check the derivative analysis [here](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/derivatives.R) and the relative plots for [Healthy](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Derivative%20%2B%20mean%20Healthy.pdf), [Physioterapy group](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Derivative%20%2B%20mean%20Physioterapy.pdf) and [Surgery group](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Derivative%20%2B%20mean%20Surgery.pdf).
- *[Plots](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/tree/main/Plots)* : <br/> in this folder are contained all the most significative plots derived from our analysis. In particular you will find the original curves for the [Control group](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Original%20Healthy%20%2B%20cross%20mean.pdf), the [Physioterapy group](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Original%20Physio%20%2B%20cross%20mean.pdf) and the [Surgery group](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/Original%20Surgery%20%2B%20cross%20mean.pdf) with their cross sectional mean, obtained thanks to [this](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Code/cross_sectional_and_posterior_mean_trajectory.R) code.
- *[Report](link)* : the report highlights in detail the steps of our work: model building, posterior inferences, comparisons.
- *[References](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/tree/main/References)* : this folder contains the article we consulted during our study;



## Authors
* **Paolo Bighignoli** - MSc in Mathematical Engineering, Quantitative Finance, Politecnico di Milano
* **Federica Mattina** - MSc in Mathematical Engineering, Applied Statistics, Politecnico di Milano
* **Federica Principe** - MSc in Mathematical Engineering, Applied Statistics, Politecnico di Milano


## References
* **Bayesian Hierarchical Curve Registration.** Donatello Telesca, Lurdes Y. T. Inoue. 
Journal of the American Statistical Association (2008).
* **Bayesian analysis for the social sciences.** Simon Jackman. Wiley, New York (2009).
* **An Adaptive Metropolis Algorithm.** Heikki Haario, Eero Saksman, Johanna Tamminen. Bernoulli Journal (2001).
* **Flexible Smoothing Using B–Splines and Penalized Likelihood (with discussion).** Eilers, P., and Marx, B. (1996). Statistical Science, 11, 1200–1224.
* **Bayesian P-splines.** Lang, Stefan, and Andreas Brezger. Journal of computational and graphical statistics 13.1 (2004): 183-212.
