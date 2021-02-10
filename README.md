# Bayesian Registration of Functional Data

Functional data often present a common shape, but with variation in amplitude and phase across curves. <br/>
The goal of this project is to synchronize data through curve registration in a Bayesian framework. <br/>
We propose a hierarchical model whose job is to model the amplitude of features and find a warping function that synchronizes all curves.


## Dataset 

Data are a collection of observations regarding one leg hoop over time. <br/>
They are divided into three groups: healthy people, people who had physiotherapy and people who had surgery. <br/>
Unfortunately, we are not allowed to upload original data, since they are medical records. <br/>
In order to let you run the code, we built up a set of fake-observations. You can find them in Simulated Data. 

## Model 

We implemented a Gibbs Sampler algorithm with one step of Metropolis-Hastings for the time transformation parameters.
The model is the following one:



If you are insterested in a more detailed description of the model, please rely on the report uploaded in the repository.


## Contents

1. Data preprocessing 
2. Simulated Data 
3. Metropolis-Hastings step : implementation of the Metropolis-Hastings step for the time transformation parameters;
4. Gibbs Sampler : application of the Gibbs sampler with one step of Metropolis-Hustings to the data;
5. Chain convergence : analysis of the chains;
6. Comparison : this folder cointains a comparison among the three groups previously presented. <br/>
We are aware that you have no access to original data and in particular to the three different groups, but we thought it could be interesting to take a look at it anyway. <br/>
Do people who had surgery have less or more difficulty in jumping with respect to people who had physiotherapy? We tried to answer to this question and more.<br/>
In order to do this, we performed analysis such as the comparison of the posterior shape parameter a and the posterior mean derivative of each group.
7. Report : the report highlights in detail the steps of our work: model building, posterior inferences, comparisons.
8. References : this folder contains the article we consulted during our study;


The dataset we worked with contains observations of the flexion-extension angle of a knee during aone leg hoop over time. We have 2 thousand sampling times for each observation and We analyzed data coming from three groups of people: people who just had surgery, people that are in physicaltherapy or that had done it in the past, and healthy people. The healty subjects represent the control group in our study. To see how we uploaded and visualized our data see [Import_Data](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Import_data.R) file.
The plotted curves are in the folder [Plots](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/tree/main/Plots) under the name *gruppo_controllo*, *gruppo_fisioterapia*, *gruppo_surgery*.

For instance, here we see the original curves for the control group

![alt text](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/Plots/gruppo_controllo.png)

The aim of this project was to align those curves. The data are private so we can not upload the original dataset, but to show that the algortihm for the alignment actually worked, we will upload the simulated curves that we used to check the performances of our algorithm. See the [simulated_functions](https://github.com/PrincipeFederica/Bayesian-Principe-Mattina-Bighignoli/blob/main/simulated_functions.R) file. 


## Structure of the Codes


## Authors
* **Paolo Bighignoli** - MSc in Mathematical Engineering, Quantitative Finance, Politecnico di Milano
* **Federica Mattina** - MSc in Mathematical Engineering, Applied Statistics, Politecnico di Milano
* **Federica Principe** - MSc in Mathematical Engineering, Applied Statistics, Politecnico di Milano


## References
* **Bayesian Hierarchical Curve Registration.** Donatello Telesca, Lurdes Y. T. Inoue. 
Journal of the American Statistical Association (2008).
* **Bayesian analysis for the social sciences.** Simon Jackman. Wiley, New York (2009).
* **An Adaptive Metropolis Algorithm.** Heikki Haario, Eero Saksman, Johanna Tamminen. Bernoulli Journal (2001).
