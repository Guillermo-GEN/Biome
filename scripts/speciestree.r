#Arbol con especies
species_tree <- read.tree("data/physeq_tree.nwk")

map <- read.csv("data/otu_2_species.csv", header = T, check.names = F, row.names = 1)

otu_to_species <- map %>%
  select(rowname, species) %>%
  deframe()  # This will create a named vector: OTUs as names, species as values

species_tree$tip.label <- otu_to_species[species_tree$tip.label]

write.tree(species_tree, file = "data/species_tree.newick")

plot_tree(species_tree, label.tips = "rowname", )

################
#Trim y convinar con el objeto physeq_tree se necesita modificar dependiendo de que se quiera cortar
unroot_tree <- read.tree("data/physeq_tree.nwk")

#outgroup = "sp###" que se quiera usar como grupo externo para enraizar, e.g. outgroup = "sp651"
#descomenta, designa el outgroup y comenta el enraizado por midpoint para
#tree <- ape::root(unroot_tree, outgroup = "sp27", resolve.root = TRUE)

#Por simplicidad si no se sabe el grupo raiz se enraiza a midpoint con castor en el caso de referencia castor agarra algun punto entre sp27 y el resto como midpoint
tree <- root_at_midpoint(unroot_tree)


# Otra alternativa es buscar el par mas distante entre si en el caso de referencia este agarra sp10 como grupo externo 
#dist_matrix <- ape::cophenetic.phylo(unroot_tree)
#max_indices <- which(dist_matrix == max(dist_matrix), arr.ind = TRUE)
# Tomar el primer par válido
#tip1_index <- max_indices[1, 1]
#tip2_index <- max_indices[1, 2]
#tip1_name <- rownames(dist_matrix)[tip1_index]
#tip2_name <- colnames(dist_matrix)[tip2_index]
# Encontrar el ancestro común más reciente
#mrca_node <- ape::getMRCA(unroot_tree, c(tip1_name, tip2_name))
#tree <- ape::root(unroot_tree, node = mrca_node, resolve.root = TRUE)nroot_tree <- read.tree("data/physeq_tree.nwk")

is.rooted(tree)

# And add it to our phyloseq object
physeq <- readRDS("data/tmp/physeq_object.rds")
physeq <- merge_phyloseq(physeq, phy_tree(tree))
#Y se guarda el objeto phyloseq
saveRDS(physeq, "data/tmp/physeq_tree_species.rds")
