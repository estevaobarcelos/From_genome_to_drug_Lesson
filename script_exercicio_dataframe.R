# 1. Create sample gene expression data
gene_expression <- data.frame(
  gene = c("TP53", "BRCA1", "EGFR", "MYC", "ACTB", "GAPDH"),
  control_1 = c(12.5, 8.9, 25.1, 5.5, 100.2, 95.8),
  control_2 = c(11.8, 9.2, 24.8, 5.8, 101.5, 96.3),
  patient_1 = c(45.6, 5.2, 68.9, 12.4, 98.7, 94.2),
  patient_2 = c(42.3, 4.8, 72.1, 13.1, 99.1, 95.0)
)