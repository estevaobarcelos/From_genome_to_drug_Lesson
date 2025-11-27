#-------------------------------------------------------------------------------
# Esercizi Struttura dati 
#-------------------------------------------------------------------------------

# Caso 1: Un numero intero.
x <- 10L # Literal integer

typeof(x)  # "integer" perché è memorizzato come intero
mode(x)    # "numeric" perché gli interi e i numeri decimali appartengono entrambi alla categoria numerica.
class(x)   # "integer" perché l'oggetto è trattato come intero.
# per ottenere informazioni su un oggetto.
class(x) # Restituisce la classe dell'oggetto (cioè il suo tipo ad alto livello, utile per la programmazione orientata agli oggetti)
typeof(x) # Restituisce il tipo interno di un oggetto (memorizzazione a basso livello)
mode(x) # Restituisce la modalità di memorizzazione dell'oggetto (simile a typeof(), ma più generico)

# Caso 2: Un numero decimale
y <- 10.5
typeof(y)  # "double"
mode(y)    # "numeric"
class(y)   # "numeric"

# Caso 3: Una stringa
s <- "Hello, it's me"
typeof(s)  # "character"
mode(s)    # "character"
class(s)   # "character"
# Qui tutte e tre le funzioni restituiscono "character", perché non ci sono ambiguità.

# Caso 4: Un fattore (factor) # In R, un factor è una struttura di dati utilizzata per rappresentare variabili categoriche. Un factor può avere un numero limitato di valori distinti chiamati livelli (levels).
# I factors vengono utilizzati per lavorare con dati categoriali come colori, nomi di città, generi, gruppi, classi, ecc.

f <- factor(c("rosso", "verde", "blu","giallo", "viola","nero","arancione"))
h <- factor(c("Male","Female"))
typeof(f)  # "integer"  (perché i fattori sono memorizzati internamente come numeri interi)
mode(f)    # "numeric"  (stessa logica)
class(f)   # "factor"   (perché è trattato come una variabile categorica)

# Caso 5: Un data frame
df <- data.frame(a = c(1, 2, 3), b = c("x", "y", "z"))
typeof(df)  # "list"     (perché un data frame è una lista di colonne)
mode(df)    # "list"     (stessa logica)
class(df)   # "data.frame" (perché viene trattato come tabella)

# Quando usare quale?
# typeof() → Quando vuoi sapere come R memorizza un oggetto internamente.
# mode() → Quando vuoi una descrizione più generica del tipo di dato.
# class() → Quando vuoi sapere come R considera l'oggetto dal punto di vista della programmazione orientata agli oggetti (OOP).


# Struttura dati.---------------------------------------------------------------
# 1. Vettore (vector)

# Creazione di un vettore di numeri interi (integer) da 1 a 10
v <- c(1:10)
f <- 1L:3L
class(v)
typeof(v)
mode(v)

# Somma di tutti gli elementi del vettore
sum_v <- sum(v)
print(sum_v)

# Estrazione del terzo elemento
print(v[3])

# Double
v <- c(1, 2, 3, 4.5, 5) # Contiene almeno un numero con virgola → diventa numeric
class(v)
typeof(v)
mode(v)

# Logical
v <- c(TRUE, FALSE, TRUE)
class(v)
typeof(v)
mode(v)
somma <- sum(c(TRUE, FALSE, TRUE,TRUE))
print(somma)

# Complex
v <- c(2+3i, 5-4i, 1+0i)
class(v)
typeof(v)
mode(v)

Re(v)
Im(v)  # Parte immaginaria

# Character (stringhe)	
v <- c("rosso", "verde", "blu")
class(v)
typeof(v)
mode(v)

# 2. Matrice (matrix)
# Creazione di una matrice 3x3  con numeri da 1 a 9
m <- matrix(1:9, nrow = 3, ncol = 3)
class(m)
typeof(m)
mode(m)
df <- as.data.frame(m)
df

# Estrazione della seconda riga
print(m[3, ])

# Somma di ogni colonna
col_sums <- colSums(m)
print(col_sums)


# 3. Array (array)
# Creazione di un array 2x2x2 con numeri da 1 a 8
arr <- array(1:8, dim = c(2,2,2))
class(arr)
typeof(arr)
mode(arr)

# Estrazione di un elemento specifico nella posizione [1,2,2]
print(arr[1,2,2])

# Somma di tutti gli elementi
sum_arr <- sum(arr)
print(sum_arr)


# 4. Data Frame (data.frame)
# Creazione di un data frame - "Nome" (stringhe) e "Età" (numeri)
df <- data.frame(Nome = c("Anna", "Luca", "Marco"), Età = c(22, 30, 25))
df
class(df)
typeof(df)
mode(df)

# Aggiunta di una nuova riga al data frame
df <- rbind(df, data.frame(Nome = "Giulia", Età = 28))

# Selezione delle persone con età superiore a 25 anni
df_over_25 <- df[df$Età > 25, ]
print(df_over_25)


# 5. Lista (list)
# Creazione di una lista contenente un vettore numerico, una stringa e una matrice
my_list <- list(numeri = c(1, 2, 3, 4), testo = "Ciao R", matrice = matrix(1:4, nrow=2))
class(my_list)

# Estrazione del secondo elemento della lista
print(my_list$testo)

# Modifica del primo elemento della lista
my_list$numeri <- c(10, 20, 30, 40)
print(my_list)


# 6. Fattore (factor)
# Creazione di un vettore di colori ripetuti (es. "rosso", "blu", "verde", "rosso")
colori <- c("rosso", "blu", "verde", "rosso")
class(colori)

# Conversione vettore in fattore
fattore_colori <- factor(colori)

# Mostrare i livelli del fattore
print(levels(fattore_colori))


# 7. Tibble (tibble)
# (Richiede il pacchetto tibble)
# Caricare il pacchetto tibble
library(tidyverse)

# Creazione di un tibble con due colonne: Nome e Età
tb <- tibble(Nome = c("Anna", "Luca", "Marco"), Età = c(22, 30, 25))
class(tb)

# Filtrare le persone con età maggiore di 25
tb_over_25 <- tb[tb$Età > 25, ]
print(tb_over_25)


# 8. Funzione (function)
# Definizione della funzione
quadrato <- function(x) {
  return(x^2)
}
class(quadrato)

# Utilizzo della funzione
print(quadrato(5))

# End of script.
#-------------------------------------------------------------------------------