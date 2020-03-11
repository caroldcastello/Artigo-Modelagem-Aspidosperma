sp.list.1.1 <- c("crypticum", "curranii", "huberianum", "nigricans", "spruceanum")

for (y in 1:length(sp.list.1.1)){ #beginning of species' loop
  print(paste("Begin of the extrapolation cleaning of ",sp.list.1[y],sep=""))
  
  
  for (x in 1:length(alg.list)){ #beginning of algorithm' loop
    
    #leitura da extrapolação
    model <- raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences","/Algorithm/",alg.list[x],"/",sp.list.1[y],".tif",sep=""))
    mop <- raster(paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences","/Extrapolation/",sp.list.1[y],"_MOP.tif",sep=""))
    
    #excluir células com alta extrapolação
    plot(model, 
         main = paste(sp.list.1[y],"\n","Algorithm:",alg.list[x]),
         xlab = "Potential distribution before extrapolated cells cleaning.")
    model[which(mop[]<0.9)]<-0
    plot(model, 
         main = paste(sp.list.1.1[y],"\n","Algorithm:",alg.list[x]),
         xlab = "Potential distribution after extrapolated cells cleaning.")
    
    #exportar
    writeRaster(model, 
                paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences","/Algorithm/",alg.list[x],"/",sp.list.1[y],"_clean.tif",sep=""), 
                format = "GTiff", overwrite = T)
    
  } #end of algorithm's loop
  
  print(paste("End of the extrapolation cleaning of ",sp.list.1[y],sep=""))
  
}#end of species' loop


#### FUTURE ####

fut <- "CCSM4_2050_85"
fut <- "CCSM4_2080_85"
fut <- "HadGEM2-AO_2050_85"
fut <- "HadGEM2-AO_2080_85"
fut <- "IPSL-CM5A-LR_2050_85"
fut <- "IPSL-CM5A-LR_2080_85"
fut <- "MIROC-ESM-CHEM_2050_85"
fut <- "MIROC-ESM-CHEM_2080_85"


for (y in 1:length(sp.list.1)){ #beginning of species' loop
  print(paste("Begin of the extrapolation cleaning of ",sp.list.1[y],sep=""))
  
  for (x in 1:length(alg.list)){ #beginning of algorithm' loop
    
    #leitura da extrapolação
    model <- raster(paste("/Volumes/Seagate Backup Plus Drive/Manuscritos/Em andamento/Modelagem Aspidosperma/Resultados/all_k-fold/Result_clim_soil_5_15","/Projection/",fut,"/",alg.list[x],"/",thr,"/",sp.list.1[y],".tif",sep=""))
    mop <- raster(paste("/Volumes/Seagate Backup Plus Drive/Manuscritos/Em andamento/Modelagem Aspidosperma/Resultados/all_k-fold/Result_clim_soil_5_15","/Projection/",fut,"/Extrapolation/",sp.list.1[y],"_MOP.tif",sep=""))
    
    #excluir células com alta extrapolação
    plot(model, 
         main = paste(sp.list.1[y],"\n","Algorithm:",alg.list[x],"\n",fut),
         xlab = "Potential distribution before extrapolated cells cleaning.")
    model[which(mop[]<0.9)]<-0
    plot(model, 
         main = paste(sp.list.1[y],"\n","Algorithm:",alg.list[x],"\n",fut),
         xlab = "Potential distribution after extrapolated cells cleaning.")
    
    #exportar
    writeRaster(model, 
                paste("~/Desktop/Artigo Modelagem Aspidosperma/Resultados/extrapolation_cleaned/spp_less_than_15occurrences/Projection/",fut,"/",alg.list[x],"/",thr,"/",sp.list.1[y],"_clean.tif",sep=""), 
                format = "GTiff", overwrite = T)
    
  } #end of algorithm's loop
  
  print(paste("End of the extrapolation cleaning of ",sp.list.1[y],sep=""))
  
} #end of species' loop
