
library(fda)
library(roahd)
library(scales)


# data preparation

load("COEFFICIENTS_ALIGNED_CURVES_INTERVENTO.RData")
load("COEFFICIENTS_ALIGNED_CURVES_FISIO.RData")
load("COEFFICIENTS_ALIGNED_CURVES_SANI.RData")

AAA = rbind(AAA_fisio, AAA_intervento, AAA_sani)
CCC = rbind(CCC_fisio, CCC_intervento, CCC_sani)
BBB = rbind(BBB_fisio, BBB_intervento, BBB_sani)

n_curve_fisio = nrow(AAA_fisio)
n_curve_intervento = nrow(AAA_intervento)
n_curve_sani = nrow(AAA_sani)

n_curve_tot = nrow(AAA)
n_iter = ncol(AAA)

n_tempi = 200


########################################################################
########################################################################


m=4           # spline order 
degree=m-1    # spline degree 

p =  50  # numero di nodi 
k = p + 2 
br = c( seq(0,n_tempi,length.out = p) )
basis = create.bspline.basis(rangeval=c(-2000, 2000), norder=m,  breaks = br, dropind = c(1:4,49:52))
k=p-6


abscissa = 1:n_tempi

# Evaluate the basis on the grid of abscissa
basismat = eval.basis(abscissa, basis)


#########################################################################
#########################################################################

# depth measure on the dataset made of the three groups

DEPTH = matrix(0, n_curve_tot, n_iter)

pb <- txtProgressBar(min = 0, max = n_iter, initial = 0, style = 3)
for ( i in 1:n_iter  ){
  
  DATA_ALIGNED = matrix(0, n_curve_tot, n_tempi)
  
  for ( j in 1:n_curve_tot ){
    
    if(j<n_curve_fisio){
  
      DATA_ALIGNED[j,] = CCC[j,i] + AAA[j,i]*basismat%*%BBB[1:44,i]
      
    }
    
    if(j>=n_curve_fisio & j<n_curve_intervento){
     
      DATA_ALIGNED[j,] = CCC[j,i] + AAA[j,i]*basismat%*%BBB[45:88,i]
      
    }
    
    if(j>=n_curve_intervento){
     
      DATA_ALIGNED[j,] = CCC[j,i] + AAA[j,i]*basismat1%*%BBB[89:nrow(BBB),i]
      
    }
  }
  
  DEPTH[,i] = MBD(DATA_ALIGNED)
  setTxtProgressBar(pb, i)
  
}


x11()
matplot(1:n_curve_tot, t(DEPTH[,seq(1,n_iter, 1000)]), type='l', lty=1,
        col=alpha(c(rep("green", n_curve_fisio), rep("blue", n_curve_intervento), rep("red", n_curve_sani)), rep(0.5, n_curve_tot)))

x11()
plot(apply(DEPTH[,20000:n_iter], 1,sum)/(n_iter-20000), 
     col=alpha(c(rep("green", n_curve_fisio), rep("blue", n_curve_intervento), rep("red", n_curve_sani)), rep(0.8, n_curve_tot)), seq(0,1,length.out=77))


######################################################################
######################################################################

# credible intervals 

upper=matrix(0,n_curve_tot)
lower=matrix(0,n_curve_tot)

for(i in 1:n_curve_tot){
  
  lower[i]=quantile(DEPTH[i,], probs=0.025)
  upper[i]=quantile(DEPTH[i,], probs=0.975)
  
}

dep=sort(apply(DEPTH[,20000:n_iter], 1,sum)/(n_iter-20000), index.return=TRUE)


colore=rep("red", n_curve_tot)
for(i in 1:n_curve_tot){
  
  if(dep$ix[i]<n_curve_fisio){colore[i]="green"}
  if(dep$ix[i]>n_curve_fisio+1 & dep$ix[i]<(n_curve_fisio+n_curve_intervento)){colore[i]="blue"}
  
}


x11()
plot(dep$x, 1:n_curve_tot, pch=16, col=colore)
points(as.vector(lower[dep$ix]), 1:n_curve_tot, col=colore, pch=4)
points(as.vector(upper[dep$ix]), 1:n_curve_tot, col=colore, pch=4)
segments(y0=1:77, x0=as.vector(lower[dep$ix]), x1=as.vector(upper[dep$ix]),  col=colore)
legend(0.1, 40, legend=c("Fisioterapia","Intervento chirurgico", "Sani"),
       col=c("red","green", "blue"), lty=1:2, cex=0.8)



########################################################################
########################################################################

# depth measure of the group fisio wrt the group surgery+healthy

DEPTH1 = matrix(0, n_curve_fisio, n_iter)

pb <- txtProgressBar(min = 0, max = n_iter, initial = 0, style = 3)
for ( i in 1:n_iter  ){
  
  DATA_ALIGNED = matrix(0, n_curve_intervento+n_curve_sani, n_tempi)
  DATA_FISIO=matrix(0,n_curve_fisio, n_tempi)
  a=1
  
  for ( j in (n_curve_fisio+1):n_curve_tot ){
    
    
    if(j<n_curve_intervento){
      
      DATA_ALIGNED[a,] = CCC[j,i] + AAA[j,i]*basismat%*%BBB[45:88,i]
      
    }
    
    if(j>=n_curve_intervento){
     
      DATA_ALIGNED[a,] = CCC[j,i] + AAA[j,i]*basismat1%*%BBB[89:ncol(BBB),i]
      
    }
    a=a+1
  }
  
  for(k in 1:n_curve_fisio){
    
    DATA_FISIO[k,]=CCC[k,i] + AAA[k,i]*basismat%*%BBB[1:44,i]
    
  }
  
  DEPTH1[,i] = MBD_relative(Data_target=DATA_FISIO, Data_reference=DATA_ALIGNED)
  setTxtProgressBar(pb, i)
  
}


#######################################################################
#######################################################################

# credible intervals

upper1=matrix(0,n_curve_fisio)
lower1=matrix(0,n_curve_fisio)

for(i in 1:n_curve_fisio){
  
  lower1[i]=quantile(DEPTH1[i,], probs=0.025)
  upper1[i]=quantile(DEPTH1[i,], probs=0.975)
  
}


dep1=sort(apply(DEPTH1[,30000:n_iter], 1,sum)/(n_iter-30000), index.return=TRUE)

colore1="blue"

x11()
plot(dep1$x, 1:n_curve_fisio, pch=16,  col=colore1)
points(as.vector(lower1[dep1$ix]), 1:n_curve_fisio, col=colore1, pch=4)
points(as.vector(upper1[dep1$ix]), 1:n_curve_fisio, col=colore1, pch=4)
segments(y0=1:n_curve_fisio, x0=as.vector(lower1[dep1$ix]), x1=as.vector(upper1[dep1$ix]),  col=colore1)
legend(0.1, 40, legend=c("Intervento chirurgico", "Sani"),
       col=c("green", "blue"), lty=1:2, cex=0.8)



###########################################################################
###########################################################################

# depth measure of group fisio+surgery wrt group healthy


DEPTH1 = matrix(0, n_curve_fisio+n_curve_intervento, n_iter)

pb <- txtProgressBar(min = 0, max = n_iter, initial = 0, style = 3)
for ( i in 1:n_iter  ){
  
  DATA_ALIGNED = matrix(0, n_curve_intervento+n_curve_fisio, n_tempi)
  DATA_SANI=matrix(0,n_curve_sani, n_tempi)
  a=1
  
  for ( j in 1:(n_curve_intervento+n_curve_fisio) ){
    
    
    if(j<n_curve_fisio){
      
      DATA_ALIGNED[j,] = CCC[j,i] + AAA[j,i]*basismat%*%BBB[1:44,i]
      
    }
    
    if(j>=n_curve_fisio ){
      
      DATA_ALIGNED[j,] = CCC[j,i] + AAA[j,i]*basismat%*%BBB[45:88,i]
      
    }
    
  }
  
  my_index = n_curve_fisio+n_curve_intervento
  for(k in 1:n_curve_sani){
    
    DATA_SANI[k,]=CCC[k+my_index,i] + AAA[k+my_index,i]*basismat1%*%BBB[89:nrow(BBB),i]
    
  }
  
  DEPTH1[,i] = MBD_relative(Data_target=DATA_ALIGNED, Data_reference=DATA_SANI)
  setTxtProgressBar(pb, i)
  
}


##########################################################################
##########################################################################

# credible intervals

upper=matrix(0,n_curve_fisio+n_curve_intervento)
lower=matrix(0,n_curve_fisio+n_curve_intervento)

for(i in 1:(n_curve_fisio+n_curve_intervento)) {
  
  lower[i]=quantile(DEPTH1[i,], probs=0.025)
  upper[i]=quantile(DEPTH1[i,], probs=0.975)
  
}

x11()
plot(1:(n_curve_fisio+n_curve_intervento), apply(DEPTH1[,30000:n_iter], 1,sum)/(n_iter-30000), pch=16,
     col=c( rep("blue", n_curve_fisio), rep("red", n_curve_intervento)))
points(1:(n_curve_fisio+n_curve_intervento), as.vector(lower), col=alpha(c( rep("blue", n_curve_fisio), rep("red", n_curve_intervento)), rep(0.8, (n_curve_fisio+n_curve_intervento))), pch=24)
points(1:(n_curve_fisio+n_curve_intervento), as.vector(upper), col=alpha( c(rep("blue", n_curve_fisio), rep("red", n_curve_intervento)), rep(0.8, (n_curve_fisio+n_curve_intervento))), pch=25)
segments(x0=1:(n_curve_fisio+n_curve_intervento), y0=as.vector(lower), y1=as.vector(upper) )


x11()
plot(apply(DEPTH1[,30000:n_iter], 1,sum)/(n_iter-30000), 1:(n_curve_fisio+n_curve_intervento), pch=16,
     col=c( rep("blue", n_curve_fisio), rep("red", n_curve_intervento)))
points(as.vector(lower), 1:(n_curve_fisio+n_curve_intervento), col=alpha(c(rep("blue", n_curve_fisio), rep("red", n_curve_intervento)), rep(0.8,(n_curve_fisio+n_curve_intervento))), pch=4)
points(as.vector(upper), 1:(n_curve_fisio+n_curve_intervento), col=alpha(c( rep("blue", n_curve_fisio), rep("red", n_curve_intervento)), rep(0.8,(n_curve_fisio+n_curve_intervento))), pch=4)
segments(y0=1:(n_curve_fisio+n_curve_intervento), x0=as.vector(lower), x1=as.vector(upper),  col=c(rep("blue", n_curve_fisio), rep("red", n_curve_intervento)))


dep=sort(apply(DEPTH1[,30000:n_iter], 1,sum)/(n_iter-30000), index.return=TRUE)


colore=rep("red", (n_curve_fisio+n_curve_intervento))


x11()
plot(dep$x, 1:(n_curve_fisio+n_curve_intervento), pch=16,
     col=colore)

points(as.vector(lower[dep$ix]), 1:(n_curve_fisio+n_curve_intervento), col=colore, pch=4)
points(as.vector(upper[dep$ix]), 1:(n_curve_fisio+n_curve_intervento), col=colore, pch=4)
segments(y0=1:(n_curve_fisio+n_curve_intervento), x0=as.vector(lower[dep$ix]), x1=as.vector(upper[dep$ix]),  col=colore)
legend(0.1, 40, legend=c("Fisio", "Intervento"),
       col=c("green", "blue"), lty=1:2, cex=0.8)


