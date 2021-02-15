
library(invgamma)
library(matlib)
library(MASS)
library("readxl") 
library("readr")
library(fda)
library(coda)
library(LearnBayes)
library(truncnorm)
library(mvtnorm)
library(ggplot2)
library(ggpubr)
library(pracma)


#########################################################################
#########################################################################


# data arrangement 

data <- read.table("HOP_TPPI_ThoraxPelvisHipKneeFoot_all.csv", head = TRUE, sep = ';')

data_t <- t(data)

prima_colonna <- data_t[,1]

keep <- prima_colonna == "Knee"

data1 <- data_t[keep,]

quarta_colonna <- data1[,4]

keep1 <- quarta_colonna == "X"

data2 <- data1[keep1,]

data3 <- data2[,-c(1,2,3,4)] 


keep2=grep("R_01", row.names(data2))


data3 <- data3[keep2,]

colnames(data3) <- 1:ncol(data3)

data3 <- data.frame(data3)

for(i in c(1:ncol(data3))) {
  data3[,i] <- as.numeric(as.character(data3[,i]))
}

data_RI <- data3

x11(width=100, height = 70)
matplot(t(data_RI), type="l")


for(i in 1:nrow(data_RI)){
  index=which.max(is.na(data_RI[i,])) 
  if(index>1) {
    data_RI[i,index:ncol(data_RI)]=data_RI[i,index-1]}
  
}

data=data_RI[1:nrow(data_RI),seq(1,1400,10)]

x11(width=100, height = 70)
matplot(t(data), type="l")


###############################################################################
###############################################################################

# basis of splines 

n_times = ncol(data)

m=4           # spline order 
degree=m-1    # spline degree 

p =  50  # number of nodes
k = p + 2 
br = c( seq(0,n_times,length.out = p) )
basis = create.bspline.basis(rangeval=c(-2000, 2000), norder=m,  breaks = br, dropind = c(1:4,49:52))
k=p-6

abscissa = 1:ncol(data)

# Evaluate the basis on the grid of abscissa
basismat = eval.basis(abscissa, basis)
basismat_tr = t(basismat)


n_iter = 100000
n_obs = nrow(data)   # number of patients 

Y = as.vector( t(data) )


######################################################################
######################################################################

# hyperparameters and initial values

a_lambda =  1
b_lambda =   0.005

a_eps = 1
b_eps = 0.005

a_a = 0.1 
b_a = 1

a_c = 0.1
b_c = 1

m_a0 = 2
sigma_a0 = 1

m_c0 = 20
sigma_c0 = 1

c = matrix (0, nrow = n_obs, ncol = n_iter )
a = matrix (0, nrow = n_obs, ncol = n_iter )
c[,1] = matrix (0, nrow = n_obs )
a[,1] = matrix (1, nrow = n_obs )

beta = matrix (0, nrow = k, ncol = n_iter)
beta[1,1]=0 

c0 = matrix (0, nrow = n_iter)
a0 = matrix (0, nrow = n_iter)

c0[1] = 0.3
a0[1] = 1

g0 = 1
f0 = 0
sigma_f = 80   
sigma_g = 0.01

sd_f = sqrt(sigma_f)
sd_g = sqrt(sigma_g)

f = matrix (0, nrow = n_obs, ncol = n_iter )
g = matrix (0, nrow = n_obs, ncol = n_iter )
g[,1] = matrix(1, nrow = n_obs)

sigma_eps = matrix (0, nrow = n_iter)
sigma_eps[1] = 0.3

sigma_a = matrix (0, nrow = n_iter)
sigma_a[1] = 0.3

sigma_c = matrix (0, nrow = n_iter)
sigma_c[1] = 0.3

lambda = matrix (0, nrow = n_iter)
lambda[1] = 0.3

x = 2
abc = -1
omega = diag(x, k)
omega[abs(row(omega)-col(omega))==1] = abc
omega[k, k] = 1
omega[1,1] = 2

nacp = matrix(0, nrow = n_obs)

m_tilde = matrix ( 0, nrow = n_obs , ncol = n_tempi )

for ( q in 1:n_obs ) {
  m_tilde[q,] =  c[q,1] + a[q,1]*basismat %*% beta[,1] 
}


##############################################################################
##############################################################################

# step of Metropolis-Hastings 

fg_log_post <- function( f_new, g_new, f_prior, g_prior, y, mtilde, sigmaepsilon, sigma_f, sigma_g ){
  
  
  sd_f = sqrt(sigma_f)
  sd_g = sqrt(sigma_g)

  # Log-Likelihood
  L =  - (1/(2*sigmaepsilon)) *(t( as.vector(y - mtilde) ) %*% as.vector(y -  mtilde ) )
  
  # Prior 
  P_f = dnorm( f_new, mean=f_prior, sd=sd_f, log=T )
  P_g = dnorm( g_new, mean=g_prior, sd=sd_g, log=T )
  
  # Add the prior in log scale
  out = L + P_f + P_g
  
  # return the log-posterior
  return(out)
}


################################################################################
################################################################################

# variance of the proposal 

sd_f_proposal = 1.4
sd_g_proposal = 0.03

var_pf = matrix(1.4, nrow = n_obs, ncol = n_iter)
var_pg = matrix(0.01, nrow = n_obs, ncol = n_iter)


################################################################################
################################################################################

# Gibbs sampler 

pb <- txtProgressBar(min = 0, max = n_iter, initial = 0, style = 3)
for ( i in 2:n_iter ) {
  
  # lambda
  a_lambda_star = a_lambda + k/2
  b_lambda_star = b_lambda + 1/2 * t(beta[,i-1]) %*% (omega %*% beta[,i-1])
  lambda_inv = rgamma (1, shape=a_lambda_star, rate=b_lambda_star)
  lambda[i] = 1/lambda_inv
  
  # sigma_a
  a_a_star = a_a + n_obs/2
  b_a_star = b_a + 1/2 * ( sum( (a[,i-1] - a0[i-1]*matrix(1, nrow = n_obs) )^2 ) )
  sigma_a_inv = rgamma (1, shape=a_a_star, rate=b_a_star)
  sigma_a[i] = 1/sigma_a_inv
  
  # sigma_c
  a_c_star = a_c + n_obs/2
  b_c_star = b_c + 1/2 * ( sum( (c[,i-1] - c0[i-1]*matrix(1, nrow = n_obs) )^2 ) )
  sigma_c_inv = rgamma (1, shape=a_c_star, rate=b_c_star)
  sigma_c[i] = 1/sigma_c_inv
  
  # a0
  sigma_a0_star = 1/( 1/sigma_a0 + n_obs / sigma_a[i] ) 
  a0_star = sigma_a0_star * ( 1/sigma_a[i] * sum ( a[,i-1] ) + m_a0 / sigma_a0 )
  a0[i] = rnorm (1, a0_star, sqrt(sigma_a0_star))
  
  # c0
  sigma_c0_star = 1/( 1/sigma_c0 + n_obs / sigma_c[i] ) 
  c0_star = sigma_c0_star * ( 1/sigma_c[i] * sum ( c[,i-1]) + m_c0 / sigma_c0 )
  c0[i] = rnorm (1, c0_star, sqrt(sigma_c0_star))
  
  # a & c
  SIGMA_c_a = diag (c(sigma_c[i], sigma_a[i]))
  SIGMA_c_a_inv = solve( SIGMA_c_a ) # non dà problemi
  w1 = matrix( 1, nrow = n_times )
  v = rbind( c0[i], a0[i] )
  m_l = matrix( 0, nrow=2  , ncol=n_obs)
  
  # sigma_eps
  a_eps_star = a_eps + n_obs * n_times / 2
  
  
  result = 0
  X = vector()
  W = vector()
  
  
  for (j in 1:n_obs  ) {
    
    current_obs = t(as.matrix(data[j,])) 
    
    
    # STEP METROPOLIS SUI TEMPI
   
    if (i>=1000) {
      
      ggg = 250
      fff = 250
      
      f_med_1 = sum( f[j, (i-fff):(i-1)] ) / fff
      g_med_1 = sum( g[j, (i-ggg):(i-1)] ) / ggg
      
      var_pf[j,i] = (   sum( (f[j,(i-fff):(i-1)] - f_med_1)^2 ) ) / (fff-1)
      var_pg[j,i] = (   sum( (g[j,(i-ggg):(i-1)] - g_med_1)^2 ) ) / (ggg-1)
      
    }
    
    
    f_temp = rnorm ( 1, mean=f[j,i-1], sd=sqrt(var_pf[j,i-1]) )
    g_temp = rnorm ( 1, mean=g[j,i-1], sd=sqrt(var_pg[j,i-1]) ) 
    
    
    current_m_tilde = as.matrix(m_tilde[j,])
    
    abscissa_provv = f_temp + g_temp*abscissa
    basismat_provv =  eval.basis(abscissa_provv, basis)
   
    next_m_tilde = c[j,i-1]*cbind(rep(1,n_tempi)) + a[j,i-1]*basismat_provv %*% beta[,i-1]
    
    num <- fg_log_post( f_temp, g_temp, f0, g0, current_obs, next_m_tilde, sigma_eps[i-1], sigma_f, sigma_g)
    ratio <- num - fg_log_post( f[j,i-1], g[j,i-1], f0, g0, current_obs, current_m_tilde, sigma_eps[i-1], sigma_f, sigma_g)
    
    r <- min(0, ratio) 
    
    u <- log(runif(1))
    
    
    if(u < r )
    {
      f[j,i] <- f_temp
      g[j,i] <- g_temp
      nacp[j] = nacp[j] + 1
    }
    else { 
      f[j,i] <-  f[j,i-1]
      g[j,i] <- g[j,i-1]
    }
    
    
    
    abscissa_translated = f[j,i] + g[j,i]*abscissa
    basismat_translated =  eval.basis(abscissa_translated, basis)
    
    
    # W
    w2 = basismat_translated %*% beta[,i-1] 
    W = cbind( w1,w2 )
    SIGMA_l_inv = SIGMA_c_a_inv + 1/sigma_eps[i-1] * t(W) %*% W
    SIGMA_l = solve(SIGMA_l_inv) 
    
    
    # sigma_eps
    m_tilde[j,] =  c[j,i-1]*cbind(rep(1,n_times)) + a[j,i-1]*basismat_translated %*% beta[,i-1] 
    diff = current_obs - m_tilde[j,]
    result = result + t(diff) %*% diff
    
    
    # a & c
    m_l[,j] = SIGMA_l %*% ( SIGMA_c_a_inv %*% v + 1/sigma_eps[i-1] * t(W)%*%current_obs ) 
    res = mvrnorm( 1, m_l[,j], SIGMA_l )
    a[j,i] = res[2]
    c[j,i] = res[1]
    
    
    a[1,i]=1

    
    # X
    m = as.matrix(basismat_translated)  
    X = rbind( X, a[j,i]*m ) 
    
    
  }
  
  
  b_eps_star = b_eps + 1/2 * result
  sigma_eps_inv = rgamma (1, shape=a_eps_star, rate=b_eps_star)
  sigma_eps[i] = 1/sigma_eps_inv
  
  # beta
  
  # vettore C
  C = c[,i]
  C = as.matrix(C)
  C = C[rep(seq_len(nrow(C)), each = n_times), ]
  C = as.matrix(C) 
  
  
  SIGMA_beta_inv = 1/lambda[i] * omega
  V_beta_inv = SIGMA_beta_inv  + 1/sigma_eps[i] * t(X) %*% X
  V_beta = solve(V_beta_inv)
  m_beta = V_beta %*% ( 1/sigma_eps[i] * t(X) %*% (Y - C))
  
  
  beta[,i] = mvrnorm (1, m_beta, V_beta)
  
  beta[1,i]=0 # beta_0=0
  
  setTxtProgressBar(pb, i)
  
}



#####################################################################################
#####################################################################################

