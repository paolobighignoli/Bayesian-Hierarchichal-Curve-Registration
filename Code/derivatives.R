

start=15000
n_iter=50000
n_times=200


basis2 = create.bspline.basis(rangeval=c(1,n_times), nbasis = 44, norder = 4)


mean_derivative = matrix(0,n_times,n_iter-start)
times = 1:n_times


pb <- txtProgressBar(min = 0, max = n_iter, initial = 0, style = 3)
for(i in start:n_iter){
  
  derivative = matrix(0,n_times,n_obs) 
 
   for(p in 1:n_obs){
    
    y_p_i = c[p,i] + a[p,i]*basismat%*%beta[,i]
    
    xsp = smooth.basis(argvals = (1:n_times),y_p_i, basis2)
    x1 = function(x) {eval.fd(x,xsp$fd, Lfd=1)}
    derivative[,p] = x1(tempi)
   
   }
  
  mean_derivative[,i-start] = rowMeans(derivative)
  setTxtProgressBar(pb, i)

}

YYY_final = rowMeans(mean_derivative)
YYY_FINAL = as.double(t(YYY_final))


x11()
matplot(1:n_times, mean_derivative, col="lightgray", type="l", xlim=c(1,120))
lines(1:n_times, YYY_FINAL, type="l", col="red",lwd = 1)




