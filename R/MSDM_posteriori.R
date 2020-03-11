#MSMD-POSTERIORI

## INSTALING PACKAGES ####

#install_github("sjevelazco/MSDM")  

## LOAD PACKAGES ####
require(devtools)  
require(MSDM)


## DIRECTORIES ####
dir_raster <-"/Volumes/Seagate Backup Plus Drive/Manuscritos/Em andamento/Modelagem Aspidosperma/Resultados/all_k-fold/Result_clim_soil_5_15/Algorithm/GAU"

dirsave <- "/Volumes/Seagate Backup Plus Drive/Manuscritos/Em andamento/Modelagem Aspidosperma/Resultados/all_k-fold/Result_clim_soil_5_15/Algorithm/GAU/MSDMPosterior"
dir.create(dirsave)

## READ DATA ####
occurrences <- read.table("/Volumes/Seagate Backup Plus Drive/Manuscritos/Em andamento/Modelagem Aspidosperma/Resultados/all_k-fold/Result_clim_soil_5_15/Occurrences_Cleaned.1.txt", header = T)
head(occurrences)

absences <- read.table("/Volumes/Seagate Backup Plus Drive/Manuscritos/Em andamento/Modelagem Aspidosperma/Resultados/all_k-fold/Result_clim_soil_5_15/absences.1.txt", header = T)
head(absences)



## RUN ####

MSDM_Posteriori(records=occurrences, absences=absences,
                x="x", y="y", sp="sp", method="OBR",
                dirraster = dir_raster, threshold = "spec_sens",
                dirsave = dirsave)

## PLOT ####
d <- list.dirs(dirsave, recursive = FALSE)

# Categorical models corrected by OBR methods
cat_obr <- stack(list.files(d[1], full.names = TRUE))
plot(cat_obr)
# Continuous models corrected by OBR methods
con_obr <- stack(list.files(d[2], full.names = TRUE))
plot(con_obr)