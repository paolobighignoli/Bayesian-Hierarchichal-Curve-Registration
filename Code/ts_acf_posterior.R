
# F & G 

p=11

f_thin=f[p,seq(1,n_iter,20)]
g_thin=g[p,seq(1,n_iter,20)]

x11()
par(mfrow=c(3,2))
plot(ts(f[p,start:n_iter]), ylab="",xlab="t",main=paste("Traceplot of f - curve", p))
plot(ts(g[p,start:n_iter]), ylab="",xlab="t",main=paste("Traceplot of g - curve", p))
acf(f[p,start:n_iter],lwd=3, ylab="",col="red3",main=paste("ACF of f - curve",p)) 
acf(g[p,start:n_iter],lwd=3, ylab="",col="red3",main=paste("ACF of g - curve",p))
hist(f[p,start:n_iter],nclass="fd", ylab="",xlab="x",freq=F,main=paste("Posterior of f - curve",p),col="gray") 
lines(density(f[p,start:n_iter]),col="blue",lwd=2)
abline(v=quantile(f[p,start:n_iter],prob=c(0.025)),col="red",lty=2,lwd=2)
abline(v=quantile(f[p,start:n_iter],prob=c(0.5)),col="red",lty=1,lwd=2)
abline(v=quantile(f[p,start:n_iter],prob=c(0.975)),col="red",lty=2,lwd=2)
hist(g[p,start:n_iter],nclass="fd",freq=F, ylab="",xlab="x",main=paste("Posterior of f - curve",p),col="gray") 
lines(density(g[p,start:n_iter]),col="blue",lwd=2)
abline(v=quantile(g[p,start:n_iter],prob=c(0.025)),col="red",lty=2,lwd=2)
abline(v=quantile(g[p,start:n_iter],prob=c(0.5)),col="red",lty=1,lwd=2)
abline(v=quantile(g[p,start:n_iter],prob=c(0.975)),col="red",lty=2,lwd=2)



# A & C

p=11

a_thin=a[p,seq(1,n_iter,20)]
c_thin=c[p,seq(1,n_iter,20)]

x11()
par(mfrow=c(3,2))
plot(ts(a[p,start:n_iter]), ylab="",xlab="t",main=paste("Traceplot of a - curve", p))
plot(ts(c[p,start:n_iter]), ylab="",xlab="t",main=paste("Traceplot of c - curve", p))
acf(a_thin,lwd=3, ylab="",col="red3",main=paste("ACF of a - curve",p)) 
acf(c_thin,lwd=3, ylab="",col="red3",main=paste("ACF of c - curve",p))
hist(a[p,start:n_iter],nclass="fd", ylab="",xlab="x",freq=F,main=paste("Posterior of a - curve",p),col="gray") 
lines(density(a[p,start:n_iter]),col="blue",lwd=2)
abline(v=quantile(a[p,start:n_iter],prob=c(0.025)),col="red",lty=2,lwd=2)
abline(v=quantile(a[p,start:n_iter],prob=c(0.5)),col="red",lty=1,lwd=2)
abline(v=quantile(a[p,start:n_iter],prob=c(0.975)),col="red",lty=2,lwd=2)
hist(c[p,start:n_iter],nclass="fd",freq=F, ylab="",xlab="x",main=paste("Posterior of c - curve",p),col="gray") 
lines(density(c[p,start:n_iter]),col="blue",lwd=2)
abline(v=quantile(c[p,start:n_iter],prob=c(0.025)),col="red",lty=2,lwd=2)
abline(v=quantile(c[p,start:n_iter],prob=c(0.5)),col="red",lty=1,lwd=2)
abline(v=quantile(c[p,start:n_iter],prob=c(0.975)),col="red",lty=2,lwd=2)
