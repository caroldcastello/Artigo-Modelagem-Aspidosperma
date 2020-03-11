##%######################################################%##
#                                                          #
####                        ModleR                      ####
#                                                          #
##%######################################################%##

### INSTALATION ####

#library(remotes)
# With vignette
#remotes::install_github("Model-R/modleR", build = TRUE,
#                        build_opts = c("--no-resave-data", "--no-manual"))

### LOAD PACKAGES ####
library(modleR)
library(raster)


### READ THE DATA ####

# Occurrences
dat <- read.csv("data/pontos_citotipos.csv")
head(dat)


dat <- dat[, 5:9]

dat <- dat[, c(1, 4:5)]
head(dat)


names(dat)[names(dat) == "coords.x1"] <- "new.long"
names(dat)[names(dat) == "coords.x2"] <- "new.lat"
head(dat)

dat <- 


#Data from worldclim (bios and radiation)
clim <-
  stack(list.files(
    path = "variavies/PCA_chelsa_5km",
    pattern = ".tif",
    full.names = T
  ))

rad <-
  stack(
    list.files(
      path = "~/Raquel/Tese/experimento raquel/variavies/radiacao_wc_1km_clip",
      pattern = ".tif",
      full.names = T
    )
  )

vars <- stack(clim, rad)


#Data from Chelsa
vars <-
  stack(
    list.files(
      path = "variavies/PCA_chelsa_5km",
      pattern = ".tif",
      full.names = T
    )
  )

#Dir to save the results
dir.save <- "Teste_past"
dir.create(dir.save)


#Mask
ma <-
  shapefile(
    "/Users/carol.dcastello/Raquel/Tese/experimento raquel/shapes/mata_atlantica.shp"
  )

### MODELLING ####

### Cleaning and setting up the data: setup_sdmdata() ####

#The first step of the workflow is to setup the data, that is, to partition it according to each project needs, to sample background pseudoabsences and to apply some data cleaning procedures, as well as some filters. This is done by function setup_sdmdata()
#modleR comes with example data, a data frame called example_occs, with occurrence data for four species, and predictor variables called example_vars

args(setup_sdmdata)

species <- unique(dat$Ploidia2)

for (i in 1:length(species)) {
  species[i] -> sp0
  dat[which(dat$Ploidia2 == sp0), ] -> dat.spp
  
  sdmdata <- setup_sdmdata(
    species_name = sp0,
    occurrences = dat.spp,
    lon = "new.long",
    lat = "new.lat",
    predictors = vars,
    models_dir = dir.save,
    partition_type = "crossvalidation",
    cv_partitions = 5,
    cv_n = 1,
    seed = 512,
    buffer_type = "max",
    plot_sdmdata = T,
    n_back = 1000,
    clean_dupl = F,
    clean_uni = F,
    clean_nas = T,
    geo_filt = F,
    select_variables = F
  )
}

### Fitting a model per partition: do_any() and do_many() ####

#Functions do_any and do_many() create a model per partition, per algorithm. The difference between these functions that do_any() performs modeling for one individual algorithm at a time, that can be chosen by using parameter algorithm, while do_many() can select multiple algorithms, with TRUE or FALSE statements (just as BIOMOD2 functions do).

#args(do_any)

for (i in 1:length(species)) {
  species[i] -> sp0
  do_many(
    species_name = sp0,
    predictors = vars,
    project_model = T,
    proj_data_folder = "variavies/paleo_clim/PCA",
    models_dir = dir.save,
    #mask = ma,
    write_png = T,
    bioclim = T,
    maxnet = T,
    rf = F,
    svmk = F,
    svme = F,
    brt = F,
    glm = F,
    domain = T,
    mahal = F,
    equalize = T,
    write_bin_cut = T
  )
}


### Joining partitions: final_model() ####
#There are many ways to create a final model per algorithm per species.


for (i in 1:length(species)) {
  species[i] -> sp0
  final_model(
    species_name = sp0,
    algorithms = NULL,
    #if null it will take all the in-disk algorithms
    models_dir = dir.save,
    select_partitions = TRUE,
    select_par = "TSSmax",
    select_par_val = 0,
    which_models = c("raw_mean", "bin_consensus", "bin_mean", "cut_mean"),
    consensus_level = 0.5,
    uncertainty = T,
    overwrite = T
  )
}


### Algorithmic consensus with ensemble_model() ####

#The fourth step of the workflow is joining the models for each algorithm into a final ensemble model. ensemble_model() calculates the mean, standard deviation, minimum and maximum values of the final models and saves them under the folder specified by ensemble_dir. It can also create these models by a consensus rule (what proportion of final models predict a presence in each pixel, 0.5 is a majority rule, 0.3 would be 30% of the models).
#ensemble_model() uses the same which.model parameter of the final_model() function to specify which final model (Figure 2) should be assembled together (the default is a mean of the raw continuous models: which.models = c("raw_mean")).

for (i in 1:length(species)) {
  species[i] -> sp0
  data[which(data$Ploidia2 == sp0), ] -> dat.spp
  
  ensemble_model(
    species_name = sp0,
    occurrences = dat.spp,
    lon = "lon",
    lat = "lan",
    which_final = c("raw_mean", "bin_consensus", "bin_mean", "cut_mean"),
    write_ensemble = T,
    models_dir = dir.save
  )
}
