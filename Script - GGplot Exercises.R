#-------------------------------------------------------------------------------
# GGPLOT2 PACKAGE EXERCISES - grammar of graphs
#-------------------------------------------------------------------------------

# Install and Load necessary libraries
# The easiest way to get dplyr is to install the whole tidyverse:
# install.packages("tidyverse")

# Alternatively, install just dplyr:
# install.packages("dplyr")
# install.packages("ggplot2")

library(dplyr)
library(tidyverse)
library(ggplot2)

# Load datasets.
clinical_data <- read.delim(file.choose(), header = TRUE, row.names = 1)
head(clinical_data)
survival_data <- read.delim(file.choose(), header = TRUE, row.names = 1)
head(survival_data)
survival_data <- survival_data[, -ncol(survival_data)]
head(survival_data)

# Grafico 1: Distribuzione dell’età dei pazienti
plot1 <- ggplot(clinical_data, aes(x = age_at_initial_pathologic_diagnosis)) +
  geom_histogram(binwidth = 5, fill = "#00A8FF", color = "black") +
  labs(title = "Distribuzione dell'età dei pazienti",
       x = "Età alla diagnosi",
       y = "Conteggio") +
  scale_x_continuous(breaks = seq(min(clinical_data$age_at_initial_pathologic_diagnosis, na.rm = TRUE), 
                                  max(clinical_data$age_at_initial_pathologic_diagnosis, na.rm = TRUE), 
                                  by = 10)) +
  theme_minimal()

plot1

# Grafico 2: Sopravvivenza in base allo stato del tumore
plot2 <- ggplot(clinical_data, aes(x = person_neoplasm_cancer_status, fill = vital_status)) +
  geom_bar(position = "dodge2") +
  labs(title = "Sopravvivenza in base allo stato del tumore",
       x = "Stato Tumorale",
       y = "Numero di Pazienti") +
  theme_minimal()
plot2

# Grafico 3: Boxplot Età vs Lunghezza del Tumore.
# Crea i gruppi di età
clinical_data <- clinical_data %>%
  mutate(age_group = cut(age_at_initial_pathologic_diagnosis, 
                         breaks = c(0, 30, 60, Inf), 
                         labels = c("Under 30", "31-60", "Above 60"),
                         right = FALSE))

plot3 <- ggplot(clinical_data, aes(x = age_group, y = pathologic_tumor_length, fill = age_group)) +
  geom_boxplot() +
  labs(title = "Distribuzione della lunghezza del tumore per fascia d'età",
       x = "Fascia d'età",
       y = "Lunghezza del tumore") +
  scale_fill_manual(values = c("#E74C3C", "#3498DB", "#2ECC71")) +
  theme_minimal()

plot3 # Mostra il grafico

# Grafico 4.1: Scatter plot con retta di regressione
plot4 <- ggplot(clinical_data, aes(x = age_at_initial_pathologic_diagnosis, y = pathologic_tumor_length)) +
  geom_point(alpha = 1, color = "blue") +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Età vs Lunghezza del tumore",
       x = "Età alla diagnosi",
       y = "Lunghezza del tumore") +
  theme_minimal()
plot4

# Grafico 4.2: Scatter plot con retta di regressione
# Assicurati che le colonne siano numeriche
clinical_data$radiologic_tumor_length <- as.numeric(as.character(clinical_data$radiologic_tumor_length))
clinical_data$pathologic_tumor_length <- as.numeric(as.character(clinical_data$pathologic_tumor_length))

plot4 <- ggplot(clinical_data, aes(x = radiologic_tumor_length, y = pathologic_tumor_length)) +
  geom_point(alpha = 1, color = "blue") +  # Punti blu
  geom_smooth(method = "lm", color = "red") +  # Regressione lineare (retta rossa)
  labs(title = "Lunghezza del tumore radiologico vs Lunghezza del tumore patologico",
       x = "Lunghezza del tumore radiologico",
       y = "Lunghezza del tumore patologico") +
  theme_minimal()

# Mostra il grafico
plot4


# Grafico 5: Numero di pazienti per stato vitale.
plot5 <- ggplot(clinical_data, aes(x = vital_status, fill = vital_status)) +
  geom_bar() +
  labs(title = "Numero di pazienti per stato vitale",
       x = "Stato vitale",
       y = "Numero di pazienti") +
  theme_minimal()
plot5

# Grafico 6: Grafico di densità - Distribuzione dell'età per gruppo tumorale
plot6 <- ggplot(clinical_data, aes(x = age_at_initial_pathologic_diagnosis, fill = person_neoplasm_cancer_status)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuzione dell'età per stato tumorale",
       x = "Età alla diagnosi",
       y = "Densità") +
  theme_minimal()
plot6 

# Grafico 7: Violin plot - Distribuzione dell'età per stato tumorale
plot7 <- ggplot(clinical_data, aes(x = person_neoplasm_cancer_status, y = age_at_initial_pathologic_diagnosis, fill = person_neoplasm_cancer_status)) +
  geom_violin(alpha = 0.5,width = 1.0) +
  geom_boxplot(width = 0.1, outlier.color = "black", fill = "white") +
  labs(title = "Distribuzione dell'età per stato tumorale",
       x = "Stato Tumorale",
       y = "Età alla diagnosi") +
  theme_minimal()
plot7

# Grafico 8. Facet Grid - Età e lunghezza del tumore suddivisi per stato vitale
plot8 <- ggplot(clinical_data, aes(x = age_at_initial_pathologic_diagnosis, y = pathologic_tumor_length, color = vital_status)) +
  geom_point(alpha = 0.5) +
  facet_wrap(~ vital_status) +
  labs(title = "Confronto Età vs Lunghezza Tumore per Stato Vitale",
       x = "Età alla Diagnosi",
       y = "Lunghezza Tumore") +
  theme_minimal()
plot8

# Grafico 9: a linee - Sopravvivenza nel tempo
plot9 <- ggplot(survival_data, aes(x = OS.time, color = OS)) +
  geom_density() +
  labs(title = "Distribuzione della Sopravvivenza",
       x = "Giorni fino al decesso",
       y = "Densità") +
  theme_minimal()
plot9

# Grafico 10 - a torta Distribuzione di genere (Mostrare quanti pazienti sono uomini e quante donne.)
# Creiamo un dataset aggregato
gender_counts <- clinical_data %>%
  group_by(gender) %>%
  summarise(n = n())

# Creiamo il grafico a torta
plot10 <- ggplot(gender_counts, aes(x = "", y = n, fill = gender)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  labs(title = "Distribuzione di Genere") +
  theme_minimal()
plot10

# Grafico 11: Boxplot con colori corretti
plot11 <- ggplot(clinical_data_clean, aes(x = additional_treatment_completion_success_outcome, 
                                         y = pathologic_tumor_length, 
                                         fill = additional_treatment_completion_success_outcome)) +
  geom_boxplot() +  # Boxplot
  labs(title = "Distribuzione della lunghezza del tumore patologico in base al risultato del trattamento",
       x = "Risultato trattamento aggiuntivo completato",
       y = "Lunghezza del tumore patologico") +
  scale_fill_manual(values = c("#E74C3C", "#3498DB", "#2ECC71", "#F39C12", "#8E44AD")) +  # Aggiungi abbastanza colori
  theme_minimal()

# Mostra il grafico
plot11
#-------------------------------------------------------------------------------