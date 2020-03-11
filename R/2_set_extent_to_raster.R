##%######################################################%##
#                                                          #
####              Change raster extent                  ####
#               Created by: A.C.D. Castello
#               Based on: Change resolution by
#                     Santiago Velazco                     #
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


### carregando o raster modelo
ext <- raster("variaveis/presente/CHELSA_01.tif")

### selecionando a projeção
crs(ext) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"


for (i in 1:length(Soil)) {
  print(i)
  layer <- raster(Soil[i])
  crs(layer) <-
    "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  layer2 <- projectRaster(layer, ext)
  layer3 <- crop(layer2, ext)
  writeRaster(layer3,
              paste(Dirsave, paste0(names(layer), '.tif$'), sep = '/'),
              format = 'GTiff',
              overwrite = T)
}
