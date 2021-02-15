
# RECONSTRUCTED CURVE

p = 11

y_p = matrix(0, nrow =n_iter-start, n_times )

for(i in (start+1):n_iter) {
  
  abscissa_translated =  f_p[j,i] + g_p[j,i]*abscissa
  basismat_translated = eval.basis(abscissa_translated, basis)
  
  y_p[i-start,] = c[j,i]+a[j,i]*basismat_translated%*% beta[,i]
  
}

y_reconstructed = colMeans(y_p)

###########################################################################
###########################################################################


# ALIGNED CURVES 

ALIGNED = matrix(0,n_obs,n_times)

pb <- txtProgressBar(min = 0, max = n_iter, initial = 0, style = 3)
for(j in 1:n_obs){
  
  y_j = matrix(0,n_iter-start,n_times)
  
  for(i in (start+1):n_iter){
    
    abscissa_temp =  f[j,i] + g_p[j,i]*abscissa
    abscissa_translated = -f_p[j,i]/g_p[j,i] + (1/g_p[j,i])*abscissa_temp
    basismat_translated = eval.basis(abscissa_translated, basis)
    
    y_j[i-start,] = c[j,i]+a[j,i]*basismat_translated%*% beta[,i]
    
  }
  
  ALIGNED[j,] = colMeans(y_j)
  setTxtProgressBar(pb, i)
  
}

