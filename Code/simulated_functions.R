
a=10
b=2
fun=function(t){
  result=1000*(t^a*(1-t)^b)
  if(t>1) {result=0}
  return(result)}
fun=Vectorize(fun)


times=seq(0,1,length.out=60)

data=matrix(0,12,200)

data[1,1:60]=fun(times)
data[2,11:130]=2.5*fun(seq(0,1,length.out=120)) 
data[3,31:120]=0.8*fun(seq(0,1,length.out=90))
data[4,41:100]=1.8*fun(times)
data[5,1:150]=1.5*fun(seq(0,1,length.out=150))
data[6,21:110]=0.4*fun(seq(0,1,length.out=90)) 
data[7,65:124]=1.2*fun(times)
data[8,6:85]=1.9*fun(seq(0,1,length.out=80)) 
data[9,21:80]=0.7*fun(times)
data[10,13:132]=1.6*fun(seq(0,1,length.out=120))

data[11,] = 2
data[11,1:60]=2+fun(times)
data[12,] = 1
data[12,21:80]=1+0.5*fun(times)

data=as.matrix(data)

x11()
matplot(1:200, t(data), type="l", col=1)


