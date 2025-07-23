#Directorio de trabajo Rstudio y Rscript
set_wd_to_script_location <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  
  if (length(file_arg) > 0) {
    script_path <- normalizePath(sub("^--file=", "", file_arg))
    setwd(dirname(script_path))
    return(invisible(TRUE))
  }
  
  if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
    script_path <- rstudioapi::getActiveDocumentContext()$path
    if (nzchar(script_path)) {
      setwd(dirname(script_path))
      return(invisible(TRUE))
    }
  }
  invisible(FALSE)
}

set_wd_to_script_location()

#Librerias
library(dplyr)
library(castor) #añadida para enraizado en midpoint automatico
library(stringr)
library(magrittr)
library(tidyr)
library(igraph)
library(visNetwork)
library(biomformat)
library(ggplot2)
library(ggprism)
library(ggsci)
library(ggside)
library(forcats)
library(FSA)
library(ggsignif)
library(broom)
library(ggsci)
library(DT)
library(tibble)
library(ape)
library(phytools)
library(microbiome)
library(SpiecEasi)
library(microViz)
library(patchwork)
library(parallel)
library(foreach)
library(reticulate)

#scripts
  #Limpieza y procesadoData and metadata
  source("scripts/raw_emu_cleaner.r")
  #Creacion de los arboles filogeneticos
  source("scripts/phylogenytree.r")
  #Creacion arbol phylogenetico con especies y enraizado
  source("scripts/speciestree.r")
  #Limpieza del objeto phyloseq
  source("scripts/ASVscleaning.r")
  #severidad diversidad alpha especifica para covid (WIP)
  #source("scripts/Shannon_alpha_diversity.r")
  #
