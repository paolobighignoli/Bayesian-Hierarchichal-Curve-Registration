
# POSTERIOR MEAN TRAJECTORY

mean_curve_i = matrix(0,n_times,n_iter)

pb <- txtProgressBar(min = 0, max = n_iter, initial = 0, style = 3)
for(i in 1:n_iter){
  
  mean_curve_i = matrix(0,n_times,n_obs)
  
  for(p in 1:n_obs){
    
    curve_i[,p] = c[p,i]+a[p,i]*basismat%*% beta[,i]
    
  }
  
  mean_curve_i[,i] = rowMeans(curve_i)
  setTxtProgressBar(pb, i)
  
}
YYY_final = rowMeans(mean_curve_i)
YYY_FINAL = as.double(t(YYY_final))

x11()
matplot(1:n_times,  t(YYY), type="l", col="dark grey",lwd = 1,xlab = 'Times',ylab = 'Aligned Curves')
lines(YYY_FINAL,type='l',col= 5,lwd = 2)
legend(50,9,legend=c( "Aligned Curves","Posterior Mean Shape Function"), col=c("grey","red"), lty=1:2, cex=0.8,lwd = 2)



##############################################################################
##############################################################################

# CROSS-SECTIONAL MEAN TRAJECTORY

x11()
matplot(1:n_times, t(data), type="l", col=1)
matplot(1:n_times, t(data), type="l", col="grey",lwd = 2,xlab = 'Times',ylab = 'Curves')
lines(rowMeans(t(data)),type='l',col=2,lwd=4)
legend(70,12,legend=c( "Simulated Curves", "Mean Curve"),
       col=c("grey","red"), lty=1:2, cex=0.8)

