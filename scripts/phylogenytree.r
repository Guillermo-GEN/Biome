rm(list =ls())
getwd()

# Specify the name of the virtual environment
venv_name <- "emOTU"

# Create the virtual environment if it doesn't exist
if (!virtualenv_exists(venv_name)) {
  virtualenv_create(envname = venv_name)
}

# Install the necessary Python packages in the virtual environment
virtualenv_install(envname = venv_name, packages = c("pandas", "scikit-bio", "ete3", "biom-format"))

# Use the virtual environment
use_virtualenv(venv_name, required = TRUE)

# Define the paths
script_path <- "scripts/agm_tree.py"
taxdump_dir <- "taxdump_dir"
output_file <- "data/emu_ref_tree.nwk"
taxdmpurl <- "https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz"
tmptaxdump <- "tmpdump/taxdump.tar.gz"
taxrefresh <- list.files(taxdump_dir, full.names = TRUE)

#Update Taxonomic dump 

if (!dir.exists("tmpdump")) dir.create("tmpdump", recursive = TRUE)
if (!dir.exists(taxdump_dir)) dir.create(taxdump_dir, recursive = TRUE)

unlink(taxrefresh, recursive = TRUE)


download.file(taxdmpurl, tmptaxdump, mopde = "wb")

untar(tmptaxdump, exdir = taxdump_dir)

file.remove(tmptaxdump)

message("Taxonomic dump actualizado")

# Get the Python executable path from the virtual environment
python_path <- virtualenv_python(envname = venv_name)

# Execute the script using system2()
result <- system2(python_path, args = c(script_path, taxdump_dir, output_file), stdout = TRUE, stderr = TRUE)

#############
# Define the paths
script_path2 <- "scripts/agmtrialtree.py"
input_tree_file <- "data/emu_ref_tree.nwk"
input_map_file <- "data/taxid_2_OTU.csv"
output_tree_file <- "data/physeq_tree.nwk"

# Execute the script using system2()
result2 <- system2(python_path, args = c(script_path2, input_tree_file, input_map_file, output_tree_file), 
                   stdout = TRUE, stderr = TRUE)

####################
