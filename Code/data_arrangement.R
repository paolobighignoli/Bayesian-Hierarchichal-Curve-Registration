
library("readxl") 
library("readr")

data <- read.table("HOP_RI_ThoraxPelvisHipKneeFoot_all.csv", head = TRUE, sep = ';')
#data <- read.table("HOP_TPPI_ThoraxPelvisHipKneeFoot_all.csv", head = TRUE, sep = ';')
#data <- read.table("HOP_controlD_ThoraxPelvisHipKneeFoot_all.csv", head = TRUE, sep = ';')

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

#######################################################
#######################################################

for(i in 1:nrow(data_RI)){
  index=which.max(is.na(data_RI[i,])) # trovo il primo NA
  if(index>1) {
    data_RI[i,index:ncol(data_RI)]=data_RI[i,index-1]}
}

data = data_RI

x11(width=100, height = 70)
matplot(t(data), type="l")

