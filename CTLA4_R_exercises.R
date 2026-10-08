# ==============================================================
# Introduction to R & RStudio — Genomics Exercises (CTLA4)
# No packages required — base R only
# Run line by line in RStudio: Ctrl+Enter / Cmd+Enter
# Oct 8, 2026
# ==============================================================


# ──────────────────────────────────────────────────────────────
# PART 1 — R BASICS
# ──────────────────────────────────────────────────────────────

# --- 1.1 The console as a calculator ---

# Number of base pairs in the human genome (approximate)
3200000000

# How many chromosome pairs does a human have?
23 * 2

# Average gene length in base pairs
27000 / 1

# Percentage of the genome that is protein-coding
(20000 * 1500) / 3200000000 * 100

# EXERCISE 1.1: The CTLA4 gene spans ~6,000 bp on chromosome 2.
# The human genome has ~3,200,000,000 bp.
# What percentage of the genome does CTLA4 occupy?
# Write a single R expression.


# --- 1.2 Variables ---

# Store key numbers about CTLA4
gene_name   <- "CTLA4"
chromosome  <- 2
gene_length <- 6000          # base pairs
exon_count  <- 4

# Print a variable — just type its name
gene_name
chromosome

# Or use print() explicitly
print(gene_length)

# EXERCISE 1.2: Create variables for:
#   - mrna_length: 933 nucleotides (CTLA4 coding sequence)
#   - protein_length: 223 amino acids
#   Verify that mrna_length / 3 equals protein_length
#   (account for the stop codon — is it exact? Why or why not?)


# --- 1.3 Data types ---

# numeric — numbers
gc_content <- 0.587           # 58.7% GC in CTLA4 exon 1
class(gc_content)             # "numeric"

# character — text (always in quotes)
sequence <- "ATGCTTCTGCTT"
class(sequence)               # "character"

# logical — TRUE or FALSE
is_oncogene  <- FALSE
is_expressed <- TRUE
class(is_oncogene)            # "logical"

# integer — whole numbers
n_exons <- 4L                 # the L suffix makes it an integer
class(n_exons)                # "integer"

# EXERCISE 1.3: What class is "58.7"? What class is 58.7?
# Are they the same? Use class() to check, then explain why
# the distinction matters when doing arithmetic.


# --- 1.4 Basic string operations ---

seq <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"

# How many characters (nucleotides)?
nchar(seq)

# Extract a substring: first codon
substring(seq, 1, 3)          # "ATG" — start codon

# Convert to upper or lower case
toupper("atgctt")
tolower(seq)

# Does the sequence contain a stop codon TAA?
grepl("TAA", seq)             # TRUE

# EXERCISE 1.4: Using substring(), extract the last three
# nucleotides of seq (the stop codon).
# Hint: use nchar(seq) to find the last position.


# ──────────────────────────────────────────────────────────────
# PART 2 — VECTORS
# ──────────────────────────────────────────────────────────────

# --- 2.1 Creating vectors ---

# c() combines values into a vector
nucleotides <- c("A", "T", "G", "C")

# Expression levels (log2) for 6 immune genes
expression <- c(8.2, 3.4, 11.7, 6.5, 9.1, 4.8)

# Chromosomes that carry immune-checkpoint genes
checkpoint_chr <- c(2, 9, 10, 1, 3)

# A sequence of positions
positions <- 1:10              # shorthand for c(1,2,3,...,10)


# --- 2.2 Naming a vector ---

gene_expr <- c(8.2, 3.4, 11.7, 6.5, 9.1, 4.8)
names(gene_expr) <- c("CTLA4", "CD28", "PDCD1", "CD274", "HAVCR2", "LAG3")
gene_expr


# --- 2.3 Indexing ---

# By position (1-based in R — NOT 0-based like Python)
gene_expr[1]              # CTLA4:  8.2
gene_expr[3]              # PDCD1: 11.7
gene_expr[c(1, 3, 5)]    # CTLA4, PDCD1, HAVCR2

# By name
gene_expr["CTLA4"]
gene_expr[c("CD28", "LAG3")]

# By logical condition — genes expressed above 7
gene_expr[gene_expr > 7]

# Negative index = exclude
gene_expr[-2]             # everything except CD28

# EXERCISE 2.1: From gene_expr, select only the genes whose
# expression is between 5 and 10. Use a logical condition.


# --- 2.4 Vector arithmetic — nucleotide counts ---

seq   <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
bases <- strsplit(seq, "")[[1]]   # character vector of single letters

# Count each nucleotide
n_A <- sum(bases == "A")
n_T <- sum(bases == "T")
n_G <- sum(bases == "G")
n_C <- sum(bases == "C")

counts <- c(A = n_A, T = n_T, G = n_G, C = n_C)
counts

# Total length
sum(counts)     # should equal nchar(seq)

# EXERCISE 2.2:
# 1. Compute the GC content of seq as a fraction: (n_G + n_C) / nchar(seq)
# 2. What is the AT/GC ratio?
# 3. The clinical CTLA4 fragment has a reported GC content of ~45%.
#    Does your result match? What might explain a difference?


# --- 2.5 Useful vector functions ---

length(gene_expr)           # number of elements
sort(gene_expr)             # ascending order
rev(sort(gene_expr))        # descending order
which.max(gene_expr)        # index of maximum
which.min(gene_expr)        # index of minimum
mean(gene_expr)             # mean expression
sd(gene_expr)               # standard deviation

# EXERCISE 2.3: Which gene in gene_expr has the highest expression?
# Use which.max() and then index with the result to print both
# the gene name and the value.


# ──────────────────────────────────────────────────────────────
# PART 3 — CONTROL FLOW
# ──────────────────────────────────────────────────────────────

# --- 3.1 if / else ---

gc <- 0.587   # GC content of our CTLA4 fragment

if (gc > 0.6) {
  cat("High GC — strong promoter activity likely\n")
} else if (gc > 0.4) {
  cat("Moderate GC content\n")
} else {
  cat("Low GC content\n")
}

# EXERCISE 3.1: Write an if / else block that checks whether a
# gene's expression (expr <- 11.7) is:
#   - > 10: print "Highly expressed"
#   - Between 5 and 10: print "Moderately expressed"
#   - <= 5: print "Low expression"


# --- 3.2 for loops — scanning a DNA sequence ---

seq   <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
bases <- strsplit(seq, "")[[1]]

# Count G bases with a loop
count_G <- 0

for (base in bases) {
  if (base == "G") {
    count_G <- count_G + 1
  }
}

cat("Number of G bases:", count_G, "\n")

# EXERCISE 3.2: Extend the loop to count ALL FOUR bases
# simultaneously, storing each count in its own variable
# (count_A, count_T, count_G, count_C).
# Print a summary line at the end.


# --- 3.3 Reading codons with a loop ---

seq    <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
n      <- nchar(seq)
codons <- c()   # empty vector to collect codons

# seq() with 'by = 3' steps in codon-sized jumps
for (i in seq(1, n - 2, by = 3)) {
  codon  <- substring(seq, i, i + 2)
  codons <- c(codons, codon)
}

print(codons)
cat("Number of codons:", length(codons), "\n")

# EXERCISE 3.3:
# 1. How many codons did you extract? Does the last one equal "TAA"?
# 2. Modify the loop to STOP when it encounters a stop codon
#    (TAA, TAG, or TGA) and print how many coding codons came before it.


# --- 3.4 while loop — scanning for a motif ---

seq   <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
bases <- strsplit(seq, "")[[1]]
i     <- 1

while (bases[i] != "T") {
  i <- i + 1
}
cat("First T found at position:", i, "\n")

# EXERCISE 3.4: Using a while loop, find the position of the
# FIRST STOP CODON (TAA) in seq. Print its start position.
# Tip: check substring(seq, i, i+2) at each step.


# ──────────────────────────────────────────────────────────────
# PART 4 — WRITING YOUR OWN FUNCTIONS
# ──────────────────────────────────────────────────────────────

# General pattern:
# my_function <- function(argument1, argument2) {
#   # body — compute something
#   return(result)
# }


# --- 4.1 GC content function ---

gc_content <- function(dna) {
  bases <- strsplit(dna, "")[[1]]
  g     <- sum(bases == "G")
  c_    <- sum(bases == "C")    # c is also a built-in; add _ to avoid clash
  gc    <- (g + c_) / length(bases)
  return(gc)
}

# Test it
gc_content("ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA")
gc_content("GCGCGCGCGC")    # expect 1.0
gc_content("ATATAT")        # expect 0.0

# EXERCISE 4.1: Add a second argument digits = 3 so the function
# returns the GC content rounded to that many decimal places.
# Use round(). Call it with the default and with digits = 1.


# --- 4.2 Complement strand function ---

complement <- function(dna) {
  map         <- c(A = "T", T = "A", G = "C", C = "G")
  bases       <- strsplit(dna, "")[[1]]
  comp        <- map[bases]           # named-vector lookup
  comp_strand <- paste(rev(comp), collapse = "")
  return(comp_strand)
}

complement("ATGCTT")    # "AAGCAT"
complement("ATG")       # "CAT"

# EXERCISE 4.2: Write a function reverse_complement() that returns
# the reverse complement of a DNA string (read 5'→3' on template).
# Test it on our CTLA4 fragment.


# --- 4.3 Codon-to-amino-acid translation ---

codon_table <- c(
  ATG = "Met", CTT = "Leu", CTG = "Leu", TTG = "Leu",
  TTA = "Leu", GTC = "Val", AGT = "Ser", ACC = "Thr",
  TGT = "Cys", AAC = "Asn", TAA = "STOP"
)

translate <- function(dna) {
  n      <- nchar(dna)
  aa_seq <- c()
  for (i in seq(1, n - 2, by = 3)) {
    codon <- substring(dna, i, i + 2)
    aa    <- codon_table[codon]
    if (!is.na(aa) && aa == "STOP") break
    aa_seq <- c(aa_seq, aa)
  }
  return(aa_seq)
}

# Translate our CTLA4 fragment
seq <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
translate(seq)

# EXERCISE 4.3:
# 1. How many amino acids does translate() return? Does it match
#    the codon count minus the stop?
# 2. What happens if you pass a sequence containing a codon not
#    in codon_table? Handle it gracefully with an if statement.


# ──────────────────────────────────────────────────────────────
# PART 5 — DATA FRAMES
# ──────────────────────────────────────────────────────────────

# --- 5.1 Building a data frame ---

genes <- data.frame(
  gene       = c("CTLA4", "CD28", "PDCD1", "CD274", "HAVCR2", "LAG3"),
  chromosome = c(2, 2, 2, 9, 2, 12),
  length_bp  = c(6000, 45000, 60000, 30000, 75000, 6500),
  expr_ctrl  = c(2.1, 3.4,  1.5,  4.2,  1.8,  2.9),   # resting T-cells
  expr_act   = c(8.2, 3.2, 11.7,  6.5,  9.1,  4.8),   # activated T-cells
  stringsAsFactors = FALSE
)

genes
nrow(genes)   # 6 genes
ncol(genes)   # 5 columns
dim(genes)    # c(6, 5)
str(genes)    # structure summary


# --- 5.2 Accessing columns and rows ---

# Column by name — returns a vector
genes$gene
genes$expr_act

# Single cell: [row, col]
genes[1, "expr_act"]          # CTLA4 activated expression

# Entire row
genes[1, ]

# Column as vector
genes[ , "chromosome"]


# --- 5.3 Adding a column — fold-change ---

genes$log2FC <- log2(genes$expr_act / genes$expr_ctrl)
round(genes$log2FC, 2)

# EXERCISE 5.1: Add a column 'upregulated' (logical) that is TRUE
# when log2FC > 1 (i.e., more than 2-fold up).
# How many genes are upregulated?


# --- 5.4 Filtering rows ---

# Genes on chromosome 2
genes[genes$chromosome == 2, ]

# Highly expressed in activated T-cells
genes[genes$expr_act > 7, ]

# Both conditions at once
genes[genes$chromosome == 2 & genes$expr_act > 5, ]

# EXERCISE 5.2: Filter the data frame to show only genes that are
# BOTH upregulated (log2FC > 1) AND on chromosome 2.


# --- 5.5 Sorting ---

# Sort by log2FC descending — most upregulated first
ordered_idx <- order(genes$log2FC, decreasing = TRUE)
genes[ordered_idx, ]

# EXERCISE 5.3: Sort the data frame by length_bp (shortest first).
# Which gene is shortest? Which is longest?


# --- 5.6 Summary statistics ---

mean(genes$log2FC)          # average fold-change
median(genes$expr_act)      # median activated expression
summary(genes)              # quick overview of every column

# EXERCISE 5.4: Using only base R (no packages), compute the mean
# expression in both conditions and print a sentence saying whether,
# on average, genes are more expressed in activated or resting T-cells.


# ──────────────────────────────────────────────────────────────
# PART 6 — BASE-R VISUALISATION
# ──────────────────────────────────────────────────────────────
# Plots appear in the Plots pane (bottom-right in RStudio)

# --- 6.1 Barplot — nucleotide counts ---

seq   <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
bases <- strsplit(seq, "")[[1]]
counts <- c(
  A = sum(bases == "A"),
  T = sum(bases == "T"),
  G = sum(bases == "G"),
  C = sum(bases == "C")
)

barplot(
  counts,
  col    = c("#E74C3C", "#3498DB", "#2ECC71", "#F39C12"),
  main   = "Nucleotide composition — CTLA4 fragment",
  ylab   = "Count",
  xlab   = "Nucleotide",
  ylim   = c(0, max(counts) + 2)
)

# EXERCISE 6.1: Add a horizontal reference line (abline(h = ...))
# at the mean nucleotide count. Use mean(counts) and colour it "grey40".


# --- 6.2 Histogram — expression distribution ---

genes <- data.frame(
  gene      = c("CTLA4", "CD28", "PDCD1", "CD274", "HAVCR2", "LAG3"),
  expr_ctrl = c(2.1, 3.4, 1.5, 4.2, 1.8, 2.9),
  expr_act  = c(8.2, 3.2, 11.7, 6.5, 9.1, 4.8),
  stringsAsFactors = FALSE
)

hist(
  genes$expr_act,
  breaks = 5,
  col    = "#2E86AB",
  main   = "Distribution of expression in activated T-cells",
  xlab   = "log2 expression",
  ylab   = "Frequency"
)

# EXERCISE 6.2: Overlay a vertical line (abline(v = ...)) at
# log2FC = 1 to mark the upregulation threshold.
# Make it red and dashed (lty = 2).


# --- 6.3 Scatter plot — mRNA vs protein (central dogma check) ---

protein_levels <- c(6.1, 3.0, 10.2, 5.8, 8.3, 4.1)

plot(
  x    = genes$expr_act,
  y    = protein_levels,
  pch  = 19,
  col  = "#8E44AD",
  main = "mRNA vs Protein expression — immune-checkpoint genes",
  xlab = "mRNA expression (log2)",
  ylab = "Protein level (log2)"
)

text(
  x      = genes$expr_act,
  y      = protein_levels,
  labels = genes$gene,
  pos    = 4,
  cex    = 0.8
)

# Fit and draw a regression line
fit <- lm(protein_levels ~ genes$expr_act)
abline(fit, col = "#E84855", lwd = 2)

# EXERCISE 6.3:
# 1. Is the relationship between mRNA and protein levels positive or negative?
# 2. Which gene deviates most from the regression line? Biological explanation?
# 3. Compute: cor(genes$expr_act, protein_levels) — interpret the value.


# --- 6.4 Side-by-side comparison — resting vs activated ---

expr_matrix <- rbind(genes$expr_ctrl, genes$expr_act)
colnames(expr_matrix) <- genes$gene

barplot(
  expr_matrix,
  beside      = TRUE,
  col         = c("#95A5A6", "#2E86AB"),
  legend.text = c("Resting", "Activated"),
  args.legend = list(x = "topright"),
  main        = "Gene expression: resting vs activated T-cells",
  ylab        = "log2 expression",
  xlab        = "Gene"
)

# EXERCISE 6.4: Looking at the barplot, which gene shows the
# largest visual change between conditions?
# Calculate its log2FC to confirm.


# ──────────────────────────────────────────────────────────────
# ANSWER KEY
# ──────────────────────────────────────────────────────────────

## Exercise 1.1
6000 / 3200000000 * 100   # ≈ 0.0001875 %

## Exercise 1.2
mrna_length    <- 933
protein_length <- 223
mrna_length / 3
# 311 — the mRNA includes 5'UTR + coding + 3'UTR
# 224 codons (223 aa + 1 stop) × 3 = 672 nt coding region only
# so mrna_length / 3 ≠ protein_length — good teaching point!

## Exercise 1.3
class("58.7")   # "character"
class(58.7)     # "numeric"
# "58.7" is text — "58.7" + 1 throws an error

## Exercise 1.4
seq <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
end <- nchar(seq)
substring(seq, end - 2, end)   # "TAA"

## Exercise 2.1
gene_expr <- c(CTLA4=8.2, CD28=3.4, PDCD1=11.7, CD274=6.5, HAVCR2=9.1, LAG3=4.8)
gene_expr[gene_expr >= 5 & gene_expr <= 10]

## Exercise 2.2
seq   <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
bases <- strsplit(seq, "")[[1]]
n_G <- sum(bases == "G"); n_C <- sum(bases == "C")
n_A <- sum(bases == "A"); n_T <- sum(bases == "T")
gc_frac <- (n_G + n_C) / nchar(seq)
at_gc   <- (n_A + n_T) / (n_G + n_C)

## Exercise 2.3
gene_expr[which.max(gene_expr)]   # PDCD1 : 11.7

## Exercise 3.1
expr <- 11.7
if (expr > 10) {
  cat("Highly expressed\n")
} else if (expr > 5) {
  cat("Moderately expressed\n")
} else {
  cat("Low expression\n")
}

## Exercise 3.2
seq   <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
bases <- strsplit(seq, "")[[1]]
count_A <- count_T <- count_G <- count_C <- 0
for (base in bases) {
  if      (base == "A") count_A <- count_A + 1
  else if (base == "T") count_T <- count_T + 1
  else if (base == "G") count_G <- count_G + 1
  else if (base == "C") count_C <- count_C + 1
}
cat("A:", count_A, " T:", count_T, " G:", count_G, " C:", count_C, "\n")

## Exercise 3.3
stop_codons  <- c("TAA", "TAG", "TGA")
coding_count <- 0
for (i in seq(1, nchar(seq) - 2, by = 3)) {
  codon <- substring(seq, i, i + 2)
  if (codon %in% stop_codons) break
  coding_count <- coding_count + 1
}
cat("Coding codons before stop:", coding_count, "\n")

## Exercise 3.4
seq <- "ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA"
i   <- 1
while (i <= nchar(seq) - 2) {
  if (substring(seq, i, i + 2) == "TAA") {
    cat("First TAA stop codon at position:", i, "\n")
    break
  }
  i <- i + 1
}

## Exercise 4.1
gc_content <- function(dna, digits = 3) {
  bases <- strsplit(dna, "")[[1]]
  gc    <- (sum(bases == "G") + sum(bases == "C")) / length(bases)
  return(round(gc, digits))
}
gc_content("ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA")
gc_content("ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA", digits = 1)

## Exercise 4.2
reverse_complement <- function(dna) {
  map   <- c(A = "T", T = "A", G = "C", C = "G")
  bases <- strsplit(dna, "")[[1]]
  rc    <- paste(rev(map[bases]), collapse = "")
  return(rc)
}
reverse_complement("ATGCTTCTGCTTTTGCTTTTAATGGTCAGTACCTGTAACTAA")

## Exercise 4.3
codon_table <- c(ATG="Met", CTT="Leu", CTG="Leu", TTG="Leu",
                 TTA="Leu", GTC="Val", AGT="Ser", ACC="Thr",
                 TGT="Cys", AAC="Asn", TAA="STOP")
translate <- function(dna) {
  n <- nchar(dna); aa_seq <- c()
  for (i in seq(1, n - 2, by = 3)) {
    codon <- substring(dna, i, i + 2)
    if (!codon %in% names(codon_table)) {
      aa_seq <- c(aa_seq, paste0("[", codon, "?]")); next
    }
    aa <- codon_table[codon]
    if (aa == "STOP") break
    aa_seq <- c(aa_seq, aa)
  }
  return(aa_seq)
}

## Exercise 5.1
genes$log2FC      <- log2(genes$expr_act / genes$expr_ctrl)
genes$upregulated <- genes$log2FC > 1
sum(genes$upregulated)   # 3 genes

## Exercise 5.2
genes[genes$upregulated & genes$chromosome == 2, ]

## Exercise 5.3
genes[order(genes$length_bp), ]
# CTLA4 (6000 bp) shortest; HAVCR2 (75000 bp) longest

## Exercise 5.4
m_ctrl <- mean(genes$expr_ctrl)
m_act  <- mean(genes$expr_act)
if (m_act > m_ctrl) {
  cat("On average, genes are more expressed in activated T-cells (",
      round(m_act, 2), "vs", round(m_ctrl, 2), ")\n")
} else {
  cat("On average, genes are more expressed in resting T-cells\n")
}

## Exercise 6.1
barplot(counts, col = c("#E74C3C","#3498DB","#2ECC71","#F39C12"),
        main = "Nucleotide composition — CTLA4 fragment",
        ylab = "Count", xlab = "Nucleotide", ylim = c(0, max(counts)+2))
abline(h = mean(counts), col = "grey40", lwd = 2)

## Exercise 6.2
hist(genes$expr_act, breaks = 5, col = "#2E86AB",
     main = "Expression in activated T-cells", xlab = "log2 expression")
abline(v = mean(genes$expr_ctrl) + 1, col = "red", lty = 2, lwd = 2)

## Exercise 6.3
# 1. Relationship is positive — higher mRNA → higher protein generally
# 2. PDCD1 deviates most — post-transcriptional regulation (miRNA, stability)
cor(genes$expr_act, protein_levels)   # ~0.97 — strong positive correlation

## Exercise 6.4
# CTLA4 shows the largest visual change
log2(genes$expr_act[1] / genes$expr_ctrl[1])  # ~1.97 — nearly 4-fold up
