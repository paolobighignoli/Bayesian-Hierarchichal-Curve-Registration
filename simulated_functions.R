############################
## FUNZIONI SEMPLICI DA ALLINEARE

a=10
b=2
f=function(t){
  result=1000*(t^a*(1-t)^b)
  if(t>1) {result=0}
  return(result)}
f=Vectorize(f)

times=seq(0,1,length.out=30)

data=matrix(0,15,150)

data[1,1:30]=f(times)
data[2,11:70]=2.5*f(seq(0,1,length.out=60)) # traslata di 10 e dilatata 
                                            # di 0.5 nei tempi, dilatata 
                                            # di 2.5 nelle y
data[3,91:105]=0.8*f(seq(0,1,length.out=15))# traslata di 90 e dilatata 
                                            # di 2 nei tempi, dilatata
                                            # di 0.8 nelle y

data[4,21:50]=1.8*f(times)
data[5,51:140]=1.5*f(seq(0,1,length.out=90))# traslata di 30 e dilatata
                                            # di 1/3 nei tempi, dilatata
                                            # di 1.5 nelle y 
data[6,81:95]=0.4*f(seq(0,1,length.out=15)) # traslata di 60 e dilatata 
                                            # di 2 nei tempi, dilatata di
                                            # 0.4 nelle y
data[7,65:94]=1.2*f(times)
data[8,51:140]=1.5*f(seq(0,1,length.out=90))
data[9,6:21]=1.9*f(seq(0,1,length.out=15)) 
data[10,31:60]=0.7*f(times)
data[11,61:150]=2.1*f(seq(0,1,length.out=90))
data[12,51:65]=0.4*f(seq(0,1,length.out=15)) 
data[13,25:54]=1.1*f(times) 
data[14,13:72]=1.6*f(seq(0,1,length.out=60)) 
data[15,111:125]=2.3*f(seq(0,1,length.out=15)) 

x11()
matplot(1:150, t(data), type="l", col=1)
