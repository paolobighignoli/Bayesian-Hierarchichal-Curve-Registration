library("readxl") 
library("readr")
## senza queste librerie non trova la funzione read_delim

############################################# PLOT GAMBA DOMINANTE ##############################################
# Di seguito i caricamenti e i plot delle curve che rappresentano il salto di una persona sana (control group)

HOP_controlD_ThoraxPelvisHipKneeFoot_all <- read_delim("HOP_controlD_ThoraxPelvisHipKneeFoot_all.csv", 
                                                       ";", escape_double = FALSE, trim_ws = TRUE, 
                                                       skip = 4)
# escape_double => Does the file escape quotes by doubling them? i.e. If this option is TRUE, the value """" represents a single quote, \".
# trim_ws => Should leading and trailing whitespace be trimmed from each field before parsing it?
# skip => Number of lines to skip before reading data.

HOP_controlD_ThoraxPelvisHipKneeFoot_all_names <- read_delim("HOP_controlD_ThoraxPelvisHipKneeFoot_all.csv", 
                                                             ";", escape_double = FALSE, trim_ws = TRUE)[1:4,]

index.select = NULL
ncol = dim(HOP_controlD_ThoraxPelvisHipKneeFoot_all_names)[2]

for(ii in 1:ncol){
  nomi.ii = HOP_controlD_ThoraxPelvisHipKneeFoot_all_names[ii]
  if(length(grep('R_01', names(nomi.ii)) >0)){ # prima replica
    if(nomi.ii[1,1]=='Knee' & nomi.ii[4,1]=='X'){
      index.select = c(index.select,ii)
    }
  }
}

data.ctrl = as.matrix(HOP_controlD_ThoraxPelvisHipKneeFoot_all[,index.select])
x11()
matplot(data.ctrl,type='l')
x11()
plot(data.ctrl[,1],type='l') # plot singola curva

################################################################################################################ 



############################################# PLOT OPERAZIONE CHIRURGICA ########################################
# Di seguito i caricamenti e i plot delle curve che rappresentano il salto di una persona operata chirurgicamente

HOP_RI_ThoraxPelvisHipKneeFoot_all <- read_delim("HOP_RI_ThoraxPelvisHipKneeFoot_all.csv", 
                                                       ";", escape_double = FALSE, trim_ws = TRUE, 
                                                       skip = 4)

HOP_RI_ThoraxPelvisHipKneeFoot_all_names <- read_delim("HOP_RI_ThoraxPelvisHipKneeFoot_all.csv", 
                                                             ";", escape_double = FALSE, trim_ws = TRUE)[1:4,]

index.select = NULL
ncol = dim(HOP_RI_ThoraxPelvisHipKneeFoot_all_names)[2]

for(ii in 1:ncol){
  nomi.ii = HOP_RI_ThoraxPelvisHipKneeFoot_all_names[ii]
  if(length(grep('R_01', names(nomi.ii)) >0)){ # prima replica
    if(nomi.ii[1,1]=='Knee' & nomi.ii[4,1]=='X'){
      index.select = c(index.select,ii)
    }
  }
}

data.ctrl = as.matrix(HOP_RI_ThoraxPelvisHipKneeFoot_all[,index.select])
x11()
matplot(data.ctrl,type='l')
x11()
plot(data.ctrl[,1],type='l') # plot singola curva

#########################################################################################################  



########################################### PLOT FISIOTERAPIA ############################################ 
# Di seguito i caricamenti e i plot delle curve che rappresentano il salto di una persona che ha fatto fisioterapia

HOP_TPPI_ThoraxPelvisHipKneeFoot_all <- read_delim("HOP_TPPI_ThoraxPelvisHipKneeFoot_all.csv", 
                                                 ";", escape_double = FALSE, trim_ws = TRUE, 
                                                 skip = 4)

HOP_TPPI_ThoraxPelvisHipKneeFoot_all_names <- read_delim("HOP_TPPI_ThoraxPelvisHipKneeFoot_all.csv", 
                                                       ";", escape_double = FALSE, trim_ws = TRUE)[1:4,]

# data <- read.table("HOP_RI_ThoraxPelvisHipKneeFoot_all.csv", head = TRUE, sep = ';')


index.select = NULL
ncol = dim(HOP_TPPI_ThoraxPelvisHipKneeFoot_all_names)[2]

for(ii in 1:ncol){
  nomi.ii = HOP_TPPI_ThoraxPelvisHipKneeFoot_all_names[ii]
  if(length(grep('R_01', names(nomi.ii)) >0)){ # prima replica
    if(nomi.ii[1,1]=='Knee' & nomi.ii[4,1]=='X'){
      index.select = c(index.select,ii)
    }
  }
}

data.ctrl = as.matrix(HOP_TPPI_ThoraxPelvisHipKneeFoot_all[,index.select])
x11()
matplot(data.ctrl,type='l')
x11()
plot(data.ctrl[,1],type='l') # plot singola curva

#########################################################################################################  


