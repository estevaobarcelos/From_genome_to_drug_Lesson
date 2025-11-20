#-------------------------------------------------------------------------------
# Survival Analysis - TCGA Data (RSEM log2(x+1) normalized values)
#-------------------------------------------------------------------------------

# # Install required libraries
# install.packages("dplyr")
# install.packages("survival")
# install.packages("survminer")

# Load required libraries
library(dplyr)
library(survival)
library(survminer)

#-------------------------------------------------------------------------------
# Part 1. Load, merge and subset data.
#-------------------------------------------------------------------------------

# Load Count Matrix
count_matrix <- read.delim(file.choose(), header = TRUE, row.names = 1, sep = "\t")
colnames(count_matrix) <- gsub("\\.", "-", colnames(count_matrix))  # clean colnames

# Load Mutation and Survival Data
mutation_data <- read.delim(file.choose(), stringsAsFactors = FALSE)  # includes 'sample', 'gene', 'effect', etc.
survival_data <- read.delim(file.choose(), header = TRUE, row.names = 1, stringsAsFactors = FALSE)

# Merge mutation and survival data by patient ID
merged_data <- merge(mutation_data, survival_data, by.x = "sample", by.y = "row.names", all.x = TRUE)

# Find common patients between count_matrix and merged_data
common_patients <- intersect(colnames(count_matrix), merged_data$sample)

# Keep only rows in merged_data for these patients
merged_data <- merged_data[merged_data$sample %in% common_patients, ]

# Filter count_matrix columns to match these patients
count_matrix <- count_matrix[, common_patients]

# Check
length(unique(merged_data$sample))   # unique patients
ncol(count_matrix)                   # columns = unique patients

#-------------------------------------------------------------------------------
# Part 2. TP53 Mutation Status (patient-level)
#-------------------------------------------------------------------------------

# Identify TP53 mutations
tp53_patients <- unique(mutation_data$sample[mutation_data$gene == "TP53"])

# Create a patient-level dataset with TP53 status
patient_level <- merged_data %>%
  select(sample, OS, OS.time, DSS, DSS.time) %>%
  distinct() %>%
  mutate(TP53_status = ifelse(sample %in% tp53_patients, "Mutated", "Wildtype"))

# Check distribution
table(patient_level$TP53_status)

#-------------------------------------------------------------------------------
# Part 3. Survival Analysis by TP53 Mutation Status
#-------------------------------------------------------------------------------

# Overall Survival
surv_object <- Surv(time = patient_level$OS.time, event = patient_level$OS)
fit <- survfit(surv_object ~ TP53_status, data = patient_level)

# Kaplan-Meier plot
plot1 <- ggsurvplot(fit, data = patient_level, pval = TRUE, risk.table = TRUE,
                    title = expression(paste("Overall Survival by ", italic("TP53"), " Mutation Status")),
                    xlab = "Time (days)", ylab = "Overall Survival Probability",
                    legend.labs = c("Mutated", "Wildtype"),
                    palette = c("#d1495b", "#2e4057"),
                    break.time.by = 365,
                    risk.table.height = 0.25,
                    ggtheme = theme_minimal())

# Rotate x-axis labels
plot1$plot <- plot1$plot + theme(axis.text.x = element_text(angle = 45, hjust = 1))
plot1$table <- plot1$table + theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Print plot
plot1


#-------------------------------------------------------------------------------
# Part 4. Survival Analysis by TP53 Expression (median cutoff)
#-------------------------------------------------------------------------------

# Ensure TP53 is in count_matrix
if(!"TP53" %in% rownames(count_matrix)) stop("TP53 not found in count_matrix")

# Extract TP53 expression and convert to numeric
tp53_expr <- as.numeric(count_matrix["TP53", ])
names(tp53_expr) <- colnames(count_matrix)  # preserve patient IDs

# Compute median
median_expr <- median(tp53_expr, na.rm = TRUE)

# Create High/Low groups
expr_group <- ifelse(tp53_expr > median_expr, "High", "Low")

# Match patient-level survival data
expr_data <- patient_level %>%
  filter(sample %in% names(expr_group)) %>%
  mutate(TP53_expr_group = expr_group[sample])

# Survival analysis
surv_object_expr <- Surv(time = expr_data$OS.time, event = expr_data$OS)
fit_expr <- survfit(surv_object_expr ~ TP53_expr_group, data = expr_data)

# Kaplan-Meier plot (correct axis rotation)
plot2 <- ggsurvplot(fit_expr, data = expr_data, pval = TRUE, risk.table = TRUE,
                        title = expression(paste("Overall Survival by ", italic("TP53"), " Expression")),
                        xlab = "Time (days)", ylab = "Overall Survival Probability",
                        legend.labs = c("High", "Low"),
                        palette = c("#d1495b","#2e4057"),
                        break.time.by = 365,
                        risk.table.height = 0.25,
                        ggtheme = theme_minimal())

# Rotate x-axis labels for plot and risk table
plot2$plot <- plot2$plot + theme(axis.text.x = element_text(angle = 45, hjust = 1))
plot2$table <- plot2$table + theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Print plot
plot2


# End of script.
################################################################################