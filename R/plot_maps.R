library(raster)
library(dplyr)

#ensemble

ens <- "MSDMPosterior/BIN"

thr <- "MAX_TSS"


#algoritmos para plotar
mod<-c("SUP","GAU","MXD","RDF","SVM")

#spp
sp<-read.table("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/Occurrences_Cleaned.1.txt", header=T)


sp.list <- sp
sp.list <- sp.list$sp
sp.list <- as.vector(unique(sp.list))

#threshold utilizado na modelagem
thr.models <- read.table("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/Evaluation_Table copy.txt", sep="\t", header = T)



## DIR TO SAVE THE MAPS ####
Dirsave <- "~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/maps/maps"
dir.create(Dirsave)

setwd(Dirsave)

y <- 1

for (y in 1:length(sp.list)){ #beginning of species' loop
  print(paste("Begin map of ",sp.list[y],sep=""))
    
    
m1<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Ensemble/",mod[1],"/",ens,"/",sp.list[y],"_clean.tif",sep=""))

m2<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Algorithm/",mod[2],"/", thr,"/",sp.list[y],"_clean.tif",sep=""))

m3<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Algorithm/",mod[3],"/",thr,"/",sp.list[y],"_clean.tif",sep=""))

m4<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Algorithm/",mod[4],"/",thr,"/",sp.list[y],"_clean.tif",sep=""))

m5<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Algorithm/",mod[5],"/",thr,"/",sp.list[y],"_clean.tif",sep=""))


thr.value.1 <- thr.models[thr.models$Algorithm == mod[1],]
thr.value.1 <- thr.value.1[thr.value.1$Sp == sp.list[y],]
tss.1 <- thr.value.1$TSS
Fdp.1 <- thr.value.1$Fpb

thr.value.2 <- thr.models[thr.models$Algorithm == mod[2],]
thr.value.2 <- thr.value.2[thr.value.2$Sp == sp.list[y],]
tss.2 <- thr.value.2$TSS
Fdp.2 <- thr.value.2$Fpb

thr.value.3 <- thr.models[thr.models$Algorithm == mod[3],]
thr.value.3 <- thr.value.3[thr.value.3$Sp == sp.list[y],]
tss.3 <- thr.value.3$TSS
Fdp.3 <- thr.value.3$Fpb

thr.value.4 <- thr.models[thr.models$Algorithm == mod[4],]
thr.value.4 <- thr.value.4[thr.value.4$Sp == sp.list[y],]
tss.4 <- thr.value.4$TSS
Fdp.4 <- thr.value.4$Fpb


thr.value.5 <- thr.models[thr.models$Algorithm == mod[5],]
thr.value.5 <- thr.value.5[thr.value.5$Sp == sp.list[y],]
tss.5 <- thr.value.5$TSS
Fdp.5 <- thr.value.5$Fpb


tiff(filename = paste(sp.list[y],"_", "all_models.tif", sep=""), units="in", width=12, height=9, res=300, compression = 'lzw')
par(mfrow=c(2,3), mar=c(1,1,1,1), mai=c(0, 0, 0.5, 0))
plot(m1, legend=F, axes=F, box=F, 
     main = paste(mod[1], "\n", "TSS: ",round(tss.1,3),", ", "Fdb: ", round(Fdp.1,3), sep=""), cex.main=1)

plot(m2, legend=F, axes=F, box=F, 
     main = paste(mod[2], "\n", "TSS: ",round(tss.2,3),", ", "Fdb: ", round(Fdp.2,3), sep=""), cex.main=1)

plot(m3, legend=F, axes=F, box=F, 
     main = paste(mod[3], "\n", "TSS: ",round(tss.3,3),", ", "Fdb: ", round(Fdp.3,3), sep=""), cex.main=1)

plot(m4, legend=F, axes=F, box=F, 
     main = paste(mod[4], "\n", "TSS: ",round(tss.4,3),", ", "Fdb: ", round(Fdp.4,3), sep=""), cex.main=1)

plot(m5, legend=F, axes=F, box=F, 
     main = paste(mod[5], "\n", "TSS: ",round(tss.5,3),", ", "Fdb: ", round(Fdp.5,3), sep=""), cex.main=1)
dev.off()

print(paste("End map of ",sp.list[y],sep=""))
 
}


for (y in 1:length(sp.list)){ #beginning of species' loop
  print(paste("Begin map of ",sp.list[y],sep=""))
  
  
  m1<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Ensemble/",mod[1],"/",ens,"/",sp.list[y],"_clean.tif",sep=""))
  
  m2<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Algorithm/",mod[2],"/", thr,"/",sp.list[y],"_clean.tif",sep=""))
  
  m3<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Algorithm/",mod[3],"/",thr,"/",sp.list[y],"_clean.tif",sep=""))
  
  m4<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Algorithm/",mod[4],"/",thr,"/",sp.list[y],"_clean.tif",sep=""))
  
  m5<-raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/","Algorithm/",mod[5],"/",thr,"/",sp.list[y],"_clean.tif",sep=""))
  
  
  tiff(filename = paste(sp.list[y],"_", "all_models_2.tif", sep=""), units="in", width=12, height=9, res=300, compression = 'lzw')
  par(mfrow=c(2,3), mar=c(1,1,1,1), mai=c(0, 0, 0.5, 0))
  plot(m1, legend=F, axes=F, box=F, 
       main = paste(mod[1], sep=""), cex.main=1)
  
  plot(m2, legend=F, axes=F, box=F, 
       main = paste(mod[2], sep=""), cex.main=1)
  
  plot(m3, legend=F, axes=F, box=F, 
       main = paste(mod[3],  sep=""), cex.main=1)
  
  plot(m4, legend=F, axes=F, box=F, 
       main = paste(mod[4], sep=""), cex.main=1)
  
  plot(m5, legend=F, axes=F, box=F, 
       main = paste(mod[5], sep=""), cex.main=1)
  dev.off()
  
  print(paste("End map of ",sp.list[y],sep=""))
  
}

