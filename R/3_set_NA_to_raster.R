##%######################################################%##
#                                                          #
####                   Set NA to raster                 ####
#               Created by: A.C.D. Castello                #
#               Based on: Change resolution by             #
#                     Santiago Velazco                     #
#                                                          #
##%######################################################%##


### carregando a biblioteca
library(raster)


### carregando o caminho do diretório para salvar os outputs
saveDir = "variaveis/solo"

### carregando o raster modelo
raster.model <- raster("variaveis/presente/CHELSA_01.tif")

### carregando o caminho dos diretórios dos rasters
Data <- "variaveis/solo"

list.files(path = Data,
           pattern = ".tif$",
           full.names = T) -> raster.change



for (i in 1:length(raster.change)) {
  print(i)
  m0 <- raster(raster.change[i])
  m1 <- m0

  m0[is.na(raster.model[])] <- NA

  writeRaster(
    m0,
    paste(saveDir, '/', names(m1), ".tif", sep = ""),
    format = 'GTiff',
    NAflag = -9999,
    overwrite = T,
    bylayer = T
  )
}
