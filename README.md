# Biome


## Introduction

  Biome is a data analysis pipeline written in R emu data clean up, phylogenetic analysis and other fine analysis.

## Installation

  ### Requirements

  - Python 3.x

  - R
    
    - Rstudio or Rscript

  <details>
    <summary><h4> Libraries </h4></summary> 
      
  ```R
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
```
    
  </details>


  ### Installation proper

  - Install the required libraries 
  - Clone the repo

  ```bash
  mkdir ~/Biome
  git clone https://github.com/Guillermo-GEN/Biome.git ~/Biome
  ```


