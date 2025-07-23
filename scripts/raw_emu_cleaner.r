rm(list =ls())
#Instalacion base de datos emu predeterminada
osf_database <- "emu_database/emu.tar"
databaseurl <- "https://osf.io/download/tswbp/"
emu_database_dir <- "emu_database"
if (!file.exists("emu_database/taxonomy.tsv")){
  download.file(databaseurl, osf_database, mode = "wb")
  untar(osf_database, exdir = emu_database_dir)
  file.remove(osf_database)
  message("Base de datos emu actualizada")
  return(invisible(TRUE))
}
invisible(FALSE)
if (!file.exists("emu_database/taxonomy.tsv")){
  message("Fallo en descargar la base de datos de emu. Intente mas tarde o instale manualmente")
  return(invisible(TRUE))
}
invisible(FALSE)
#Falta modificar esto una vez se sepa la metadata a usar
# Lets make a gigantic metadata file joining by DNI
meta1 <- read.csv("data/metadata_P.csv", check.names = FALSE)
# metadata file 2
meta2 <- read.delim("data/metadata_all_P.tsv", check.names = FALSE) |>
  dplyr::select(sample, Time, COVID19, COVID19_severity, BMI, DNI, 
                Treatment, Age, Old, Sex, Antibiotic, remove_duplicate) |>
  dplyr::mutate_all(~replace(., is.na(.), 0))

meta <- left_join(meta2, meta1, by = "DNI") |>
  dplyr::filter(COVID19 == "COVID" & Time == "T0")|>
  dplyr::mutate_all(~replace(., is.na(.), 0)) |>
  dplyr::filter(ID > 0) |>
  #dplyr::filter(remove_duplicate == "") |>
  dplyr::mutate_all(~ifelse(. == "no", 0, .)) |>
  dplyr::mutate_all(~ifelse(. == "si", 1, .)) |>
  tibble::column_to_rownames("sample")


# Load and prepare taxonomy file
tax_file <- read.delim("data/emu-combined-taxonomy-species.tsv") |>
  dplyr::select(superkingdom, phylum, class, order, family, genus, species) |>
  as.matrix()

# Ensure all elements in tax_file are characters
tax_file <- apply(tax_file, 2, as.character)

# Load in Emu results
emu <- read.delim(file = "data/emu-combined-abundance-species-counts.tsv", check.names = FALSE) |>
  mutate_all(~replace(., is.na(.), 0)) |>
  column_to_rownames("species")

# Filter out columns ending with "-threshold-0.0001"
filt_cols <- grep("-threshold-0.0001$", names(emu), value = TRUE, ignore.case = TRUE)
filt_emu <- emu[, !(names(emu) %in% filt_cols)]

# Convert to matrix and ensure numeric type for otu_table
emu_otu_mat <- as.matrix(filt_emu)
emu_otu_mat <- apply(emu_otu_mat, 2, as.numeric)

# Create the OTU, sample data, and taxonomy table objects
emu_otu <- otu_table(emu_otu_mat, taxa_are_rows = TRUE)
emu_sam <- sample_data(meta)
emu_tax <- tax_table(as.matrix(tax_file))

# Combine into a phyloseq object
physeq <- phyloseq(emu_otu, emu_sam, emu_tax)

message("Objeto phyloseq creado")

###################################################

#Take OTU table to make map for tree
tax_table_physeq <- tax_table(physeq)

# Convert the OTU table to a data frame
tax_table_df <- as.data.frame(tax_table_physeq) |>
  rownames_to_column()
tax_table_df <- tax_table_df |> rename(emOTU = 1) |> select(emOTU, species)

# read in emu database taxonomy.tsv (change path accordingly)
taxid <- read.delim("emu_database/taxonomy.tsv", 
                    header = TRUE, check.names = FALSE) |>
  select(tax_id, superkingdom, phylum, class, order, family, genus, species)

tax_map <- left_join(taxid, tax_table_df, by = "species") |>
  select(tax_id, emOTU) |>
  filter(emOTU != "")

write.csv(tax_map, file = "data/taxid_2_OTU.csv", row.names = FALSE)

if (file.exists("data/taxid_2_OTU.csv")){
  message("taxid_2_OTU.csv creado correctamente")
}

################################################
#creamos otro objeto para formar otro archivo csv conteniendo taxonomia y las IDs de emOTU
otu_species <- left_join(taxid, tax_table_df, by = "species") |>
  select(emOTU, superkingdom, phylum, class, order, family, genus, species)|>
  filter(emOTU != "")|>
  rename(rowname = emOTU)

write.csv(otu_species, file = "data/otu_2_species.csv", row.names = TRUE)

if(file.exists("data/otu_2_species.csv")) message("otu_2_species.csv creado correctamente")


###############################
#Guardar el objeto phyloseq para uso posterior
if(!dir.exists("data/tmp")) dir.create("data/tmp")
saveRDS(physeq, "data/tmp/physeq_object.rds")
if(file.exists("data/tmp/physeq_object.rds")) message ("Objeto phyloseq exportado")
