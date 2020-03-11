library(raster)


#MF = M - MOP
#MF = Modelo Final / M = Modelo / MOP = células MOP com alta extrapolação (<0.9)
#MOP = 1 é baixa extrapolação / MOP = 0 é alta extrapolação. Assim, só posso permitir que meu modelo tenha valores de MOP = 1, pois os outros valores não são confiáveis…
#Todas as células do meu modelo que apresentaram valores até 0.9 na extrapolação não são confiáveis, portanto devo excluí-las do modelo. Daí: (M - MOP). 
#Então, subtrair de MOP < 0.9 é bastante restritivo, contribuindo para a robustez do modelo final, sobretudo quando quero transferir para outros cenários climáticos.


dir.1 <- "~/Desktop/teste/experimento_29_10/variaveis/Result_58spp/Ensemble/SUP"

list.files(path=dir.1, pattern=".tif$", full.names = T) -> modelos

dir.2 <- "~/Desktop/teste/experimento_29_10/variaveis/Result_58spp/Extrapolation"

list.files(path=dir.2, pattern="_MOP.tif$", full.names = T) -> mop

Dirsave <- "~/Desktop/teste/experimento_29_10/variaveis/Result_58spp/modelos finais"

for(i in 1:length(modelos)){
  
  for(j in 1:length(mop)){
    
    m0 <- raster(modelos[i])
    m1 <- raster(mop[j])
    
    m0[which(m1[]<0.9)]<-0
  
  writeRaster(m0, paste(Dirsave, paste0(names(m1), '_mf.tif'), sep = '/'),
              format = 'GTiff',
              overwrite = F)
  }
}



setwd("~/Desktop/teste/experimento_29_10/variaveis/Result")
williamii <- raster("~/Desktop/teste/experimento_29_10/variaveis/Result/Algorithm/SVM/album.tif")

williamii_MOP <- raster("~/Desktop/teste/experimento_29_10/variaveis/Result/Extrapolation/album_MOP.tif")

williamii[which(williamii_MOP[]<0.9)]<-0

#plot(williamii)

writeRaster(williamii, "album_mf.tif",
            format = 'GTiff')