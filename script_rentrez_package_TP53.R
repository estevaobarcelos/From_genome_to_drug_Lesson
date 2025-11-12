# ==============================
#   Rentrez Package - Protein Sequence Only
# ==============================

# Install and load required packages
install.packages("rentrez")
library(rentrez)

# Get protein (amino acid) sequence
# Search in protein database with specific filters
tp53_protein_search <- entrez_search(db="protein", 
                                     term="TP53[Gene Name] AND Homo sapiens[Organism] AND RefSeq[Filter]")

# Fetch protein sequence
tp53_protein_sequence <- entrez_fetch(db="protein", 
                                      id=tp53_protein_search$ids[1], 
                                      rettype="fasta")

# Print the amino acid sequence
cat("TP53 Protein Sequence:\n")
cat(tp53_protein_sequence)

# Save amino acid sequence to file
write(tp53_protein_sequence, "TP53_protein_sequence.fasta")
cat("\nProtein sequence saved to: TP53_protein_sequence.fasta\n")

# End of the script