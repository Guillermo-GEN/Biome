
physeq <- readRDS("data/tmp/physeq_tree_species.rds")
#remover ASVs
pop_taxa <- function(physeq, badTaxa){
  allTaxa <- taxa_names(physeq)
  allTaxa <- allTaxa[!(allTaxa %in% badTaxa)]
  return(prune_taxa(allTaxa, physeq))
}

# ASVs that are no bueno
badTaxa <- c("sp1692")

# Cleaned up physeq for ancombc
ps <- pop_taxa(physeq, badTaxa)

biome <- phyloseq_validate(ps) |>
  tax_fix() 

# round otu counts
round_biome <- round(otu_table(biome))

# Update sample_data in phyloseq object
bigvid <- phyloseq(round_biome, biome@tax_table, biome@sam_data)
vid <- merge_phyloseq(bigvid, phy_tree(tree))

saveRDS (bigvid, "data/tmp/bigvid.rds")
saveRDS (vid, "data/tmp/vid.rds")

