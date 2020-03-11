##%######################################################%##
#                                                          #
####                   PCA preditores                   ####
#               Created by: Santiago Velazco               #
#                       Data: 25/11/2019                   #
##%######################################################%##

### carregando a biblioteca
library(raster)

### carregando a função para realizar a PCA
source("scripts/RasterPCA.R")


### carregando o caminho dos diretórios para salvar os outputs
saveDir = "variaveis/PCA/presente"
saveDirF <- "variaveis/PCA"
saveTxt <- "variaveis/PCA/presente/Table"

### carregando as variáveis do presente e de solo

clim <-
  stack(list.files(
    "variaveis/presente",
    full.names = T,
    pattern = '.tif'
  ))

soil <-
  stack(list.files("variaveis/solo", full.names = T, pattern = '.tif'))

# juntanto as variáveis de clima e solo
variables <- stack(clim, soil)

### carregando as variáveis do futuro
DirP <- "variaveis/futuro"
DirF <- file.path(DirP, list.files(DirP))
DirP_PCA <- file.path(saveDirF, 'futuro')
dir.create(DirP_PCA)
FoldersProj <- as.list(file.path(DirP_PCA, basename(DirF)))
lapply(FoldersProj, function(x)
  dir.create(x))


### Performing PCA

# Presente
dir.create(saveDir)
if (class(variables) == "RasterBrick")
  variables <- stack(variables)

df <- rasterToPoints(variables)
dim(df)
df <- na.omit(df)
pca.raw <- df[,-c(1:2)]

# meand and sd to stadardize future values
means <- colMeans(pca.raw)
stds <- apply(pca.raw, 2, sd)


#Scale transform
# this procedure will generate a PCA wiht CORRELATION MATRIX
data.scaled <- data.frame(apply(pca.raw, 2, scale))

# Conduct the PCA
data.pca <- prcomp(data.scaled, retx = TRUE)
Coef <- data.pca$rotation

#Variance explained for each PC and their coefficient

#criando o diretório para salvar a tabela de resultados
dir.create(saveTxt)

varexplained <- round(t(summary(data.pca)$importance), 3)
varexplained <-
  data.frame(varexplained, round(data.pca$rotation, 3))
write.table(
  varexplained,
  paste(saveTxt, '/', 'pca_varexplained_coef.txt', sep = ""),
  row.names = F,
  col.names = T,
  sep = '\t'
)

#axis with cummulative variance explanation until 96%
var.96 <- varexplained$Cumulative.Proportion <= 0.96

# Creation of new raster wiht PC
axis <- as.data.frame(data.pca$x)
axis <- round(axis[, var.96], 5)
axis <- data.frame(df[, 1:2], axis)
variables3 <- axis
gridded(variables3) <- ~ x + y
variables3 <- stack(variables3)

writeRaster(
  variables3,
  filename = paste(saveDir, '/', names(variables3), ".tif", sep = ""),
  format = 'GTiff',
  NAflag = -9999,
  overwrite = TRUE,
  bylayer = T
)

# Futuro
DirP <- as.list(DirF)
names(DirP) <- basename(DirF)
ProjT <-
  lapply(DirP, function(x)
    brick(stack(
      list.files(x, pattern = '.tif', full.names = T)
    )))
ProjT <- lapply(ProjT, function(x)
  stack(x, soil)) # Stack with soils
ProjE <- lapply(ProjT, function(x)
  rasterToPoints(x))
rm(ProjT)
ProjE <- lapply(ProjE, function(x)
  na.omit(x))
ProjER <-
  lapply(ProjE, function(z)
    z[, !(colnames(z) %in% c("x", "y"))])

scale <- lapply(ProjER, function(x)
  sweep(x, 2, means))
scale <- lapply(scale, function(x)
  x %*% diag(1 / stds))
PCAFut <- lapply(scale, function(x)
  x %*% Coef)
PCAFut <-
  lapply(PCAFut, function(x)
    data.frame(cbind(ProjE[[1]][, (1:2)], x)))

PCAFut.95 <- list()
for (j in 1:length(PCAFut)) {
  PCAFut.95[[j]] <- PCAFut[[j]][, c(1, 2, which(var.96) + 2)]
  gridded(PCAFut.95[[j]]) <- ~ x + y
  PCAFut.95[[j]] <- stack(PCAFut.95[[j]])
}

for (j in 1:length(PCAFut)) {
  writeRaster(
    PCAFut.95[[j]],
    paste(FoldersProj[[j]], names(PCAFut.95[[j]]), sep = "/"),
    bylayer = T,
    format = "GTiff",
    overwrite = T
  )
}
