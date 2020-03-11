#Installation

if(!require(devtools)){
  install.packages("devtools")
}
if(!require(GRaF)){
  devtools::install_github("goldingn/GRaF")
}
if(!require(ellipsenm)){
  devtools::install_github("marlonecobos/ellipsenm")
}
devtools::install_github("andrefaa/ENMTML")
library(ENMTML)

#algorithm = c("MXD", "SVM", "GLM", "GAM", "BRT", "RDF", "MLK", "GAU"),

#Run
ENMTML(
  pred_dir = "~/Desktop/Artigo Modelagem Aspidosperma/variaveis/PCA/Presente", 
  proj_dir = NULL, 
  occ_file = "~/Desktop/Artigo Modelagem Aspidosperma/occurrences_aspi_11-2019_used_in_ENMs_15_plus.txt",
  sp = 'sp', x = 'x', y = 'y',
  min_occ = 1,
  thin_occ = NULL,
  eval_occ = NULL,
  colin_var = NULL,
  imp_var = FALSE,
  sp_accessible_area = c(method='MASK', filepath='~/Desktop/Artigo Modelagem Aspidosperma/Ecorregioes WWF cortada/wwf_terr_ecos.shp'),
  pseudoabs_method = c(method = 'ENV_CONST'),
  pres_abs_ratio = 1,
  part=c(method="BLOCK"),
  save_part = FALSE,
  save_final = TRUE,
  algorithm = c("MXD", "SVM", "RDF", "GAU"),
  thr = c(type='MAX_TSS'),
  msdm = c(method="OBR"),
  ensemble = c(method="SUP", metric='TSS'),
  extrapolation = FALSE,
  cores = 1
)
