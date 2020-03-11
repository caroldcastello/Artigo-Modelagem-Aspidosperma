##%######################################################%##
#                                                          #
####              Change raster resolution
 #                       & crop raster                  ####
#               Created by: Santiago Velazco               #
#                                                          #
##%######################################################%##

### carregando a biblioteca
library(raster)

### carregando o caminho dos diretórios dos rasters
Dir <- "variaveis/solo"


# Listar as variávies
Soil <- list.files(Dir, pattern = ".tif$", full.names = T)


### carregando o caminho dos diretórios para salvar os outputs
Dirsave <- "variaveis/solo"

## Mudando a resolução

#Para verificar o fator para a mudan?a da resolu??o: dividir o tamanho do pixel da resolu??o desejada pela resolu??o atual do raster
#de 250 m para 1km
0.008333334/0.002083333

#de 1km para 5 km
0.0416667/0.008333334

#5km para 10km
0.0833333/0.0416667

#cilp
crop_extent <- shapefile("extent/extent.shp")

##Solo
for (i in 1:length(Soil)) {
  print(i)
  layer <- raster(Soil[i])
  layer <- crop(layer, crop_extent)
  plot(layer)
  layer2 <- aggregate(layer, fact = 2)
  writeRaster(layer2,
              paste(Dirsave, paste0(names(layer2), '.tif'), sep = '/'),
              format = 'GTiff',
              overwrite = T)
}





