# ==============================
#   RNA-seq DE + GO analysis
#   GSE238230 (WT vs KO CM)
#   Base-R / DESeq2 / clusterProfiler
# ==============================

# --- Install Required Packages ---
# Note: Run this section only once to install packages

# Bioconductor packages
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(c(
  "GEOquery",       # For downloading GEO data
  "DESeq2",         # For differential expression analysis
  "clusterProfiler", # For enrichment analysis
  "org.Mm.eg.db"    # Mouse genome annotation database
))

# CRAN packages
install.packages(c(
  "readxl",         # For reading Excel files
  "ggplot2",        # For data visualization
  "ggrepel",        # For ggplot label positioning
  "pheatmap"        # For heatmap creation
))

# --- Libraries ---
library(GEOquery)
library(readxl)
library(DESeq2)
library(clusterProfiler)
library(org.Mm.eg.db)
library(ggplot2)
library(ggrepel)
library(pheatmap)

# --- 1. Load data ---
getGEOSuppFiles("GSE238230", makeDirectory = TRUE)

counts <- as.data.frame(read_excel("C:/Users/39331/Documents/GSE238230/GSE238230_DESeq2_Ad_WEA_CM_Transcriptome_umi_counts.xlsx"))
colnames(counts)[1] <- "gene"

# --- 2. Prepare count matrix ---
raw_counts <- counts[, c("gene", grep(".raw$", colnames(counts), value = TRUE))]
rownames(raw_counts) <- raw_counts$gene
raw_counts <- raw_counts[, -1]
raw_counts_matrix <- as.matrix(raw_counts)

# --- 3. Subset to 6 samples (WT vs KO) ---
samples_of_interest <- c(
  "AD.WEA.WT.CM.1.raw", "AD.WEA.WT.CM.2.raw", "AD.WEA.WT.CM.3.raw",
  "AD.WEA.KO.CM.1.raw", "AD.WEA.KO.CM.2.raw", "AD.WEA.KO.CM.3.raw"
)
counts_subset <- raw_counts_matrix[, samples_of_interest]

colData <- data.frame(
  row.names = samples_of_interest,
  condition = factor(c(rep("WT", 3), rep("KO", 3)))
)

# --- 4. Run DESeq2 ---
dds <- DESeqDataSetFromMatrix(countData = counts_subset, colData = colData, design = ~ condition)
dds <- DESeq(dds)
res <- results(dds, contrast = c("condition", "KO", "WT"))
res$gene <- rownames(res)
res_df <- as.data.frame(res[!is.na(res$padj), ])

# --- 5. Volcano plot with top 30 labels ---
res_df$significant <- ifelse(res_df$padj < 0.05 & abs(res_df$log2FoldChange) > 1, "yes", "no")
top30 <- head(res_df[order(res_df$padj), ], 30)

ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj), color = significant)) +
  geom_point(alpha = 0.6, size = 1.5) +
  scale_color_manual(values = c("no"="grey", "yes"="red")) +
  theme_minimal(base_size = 13) +
  labs(title = "Volcano plot: KO vs WT", x = "log2 Fold Change (KO vs WT)", y = "-log10 adjusted p-value") +
  geom_text_repel(data = top30, aes(label = gene), size = 3, max.overlaps = Inf, box.padding = 0.3)


# --- 6. PCA plot ---
vsd <- vst(dds, blind = FALSE)
pcaData <- plotPCA(vsd, intgroup = "condition", returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

ggplot(pcaData, aes(PC1, PC2, color = condition)) +
  geom_point(size = 4) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  theme_minimal(base_size = 14) +
  labs(title = "PCA plot of samples (vst-transformed counts)") +
  scale_color_manual(values = c("WT" = "#1f77b4", "KO" = "#d62728")) +
  theme(plot.title = element_text(hjust = 0.5))

# --- 7. Heatmap of top 30 DE genes ---

# Select top 30 genes by adjusted p-value
top30_genes <- rownames(top30)

# Extract normalized expression for these genes
mat <- assay(vsd)[top30_genes, ]

# Z-score scaling by gene (row)
mat_z <- t(scale(t(mat)))

# Define annotation for samples
annotation_col <- data.frame(
  Condition = colData(dds)$condition
)
rownames(annotation_col) <- colnames(mat)

# Plot heatmap
pheatmap(
  mat_z,
  annotation_col = annotation_col,
  show_rownames = TRUE,
  show_colnames = TRUE,
  fontsize_row = 8,
  fontsize_col = 10,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  color = colorRampPalette(c("navy", "white", "firebrick3"))(50),
  main = "Top 30 DE genes (scaled expression)"
)


# --- 8. Split up- and downregulated genes ---
up_genes <- rownames(res_df[res_df$padj < 0.05 & res_df$log2FoldChange > 1, ])
down_genes <- rownames(res_df[res_df$padj < 0.05 & res_df$log2FoldChange < -1, ])

# --- 9. GO enrichment ---
up_ids <- bitr(up_genes, fromType="SYMBOL", toType="ENTREZID", OrgDb=org.Mm.eg.db)
down_ids <- bitr(down_genes, fromType="SYMBOL", toType="ENTREZID", OrgDb=org.Mm.eg.db)

ego_up <- enrichGO(gene=up_ids$ENTREZID, OrgDb=org.Mm.eg.db, keyType="ENTREZID",
                   ont="BP", pAdjustMethod="BH", qvalueCutoff=0.05, readable=TRUE)
ego_down <- enrichGO(gene=down_ids$ENTREZID, OrgDb=org.Mm.eg.db, keyType="ENTREZID",
                     ont="BP", pAdjustMethod="BH", qvalueCutoff=0.05, readable=TRUE)

# --- 10. Visualize GO enrichment ---
barplot(ego_up, showCategory=15, title="GO:BP Enrichment (Upregulated in KO)")
barplot(ego_down, showCategory=15, title="GO:BP Enrichment (Upregulated in WT)")

# --- Optional: cnetplot to show genes per pathway ---
cnetplot(ego_up, showCategory = 10, colorEdge = TRUE, circular = FALSE)

# Part 11. GSEA. ==============================================================

# --- Map gene symbols to Entrez IDs ---
res_df$entrez <- mapIds(org.Mm.eg.db,
                        keys = as.character(res_df$gene),
                        column = "ENTREZID",
                        keytype = "SYMBOL",
                        multiVals = "first")

# --- Create ranked gene list ---
# Using sign(log2FoldChange) * -log10(padj)
rnk_gsea <- dplyr::bind_cols(
  gene = res_df$gene,
  rank_score = as.numeric(-log10(res_df$padj) * sign(res_df$log2FoldChange))
)

# --- Clean the rank file ---
rnk_gsea <- rnk_gsea[!is.na(rnk_gsea$rank_score), ]
rnk_gsea <- rnk_gsea[rnk_gsea$rank_score != -Inf & rnk_gsea$rank_score != Inf, ]

# --- Write .rnk file for GSEA software ---
write.table(
  rnk_gsea,
  file = "KO_vs_WT_GSEA.rnk",
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE,
  sep = "\t"
)

print("Rank file for GSEA saved as: KO_vs_WT_GSEA.rnk")

# Ennd of script.