# DATA MINING AND INFORMATION SYSTEMS
# ESERCITAZIONE RIASSUNTIVA, 3/4/09
################################################################################
Parte A.
1. Su un campione di 50 imprese abbiamo rilevato i seguenti indici di bilancio
X1: liquidit�/debito totale,
X2: debito corrente/debito totale
X3: attivit�/debito totale
I dati sono contenuti nel file bilanci.txt. Determina il vettore delle
medie, delle deviazioni standard e la matrice di correlazione.
2. Ci sono casi anomali?
3. Qual � la % della varianza totale spiegata dalla prima e dalle prime due
componenti principali?
Per caricare i dati
read.table("http://venus.unive.it/romanaz/datamin/dati/bilanci.txt",
 header=TRUE)
##############################################################################
Soluzione
################################################################################
Parte B.
4. Si pu� prevedere l'indice di rifrazione del vetro mediante la sua composizione
chimica. Per risolvere il problema usa i dati dei vetri, gruppo "vetri di 
abitazione float" (Class = 1). Quali sono le variabili esplicative pi� 
importanti per la previsione di Ri? quali sono quelle irrilevanti?
5. Calcola i quartili della distribuzione dei residui standardizzati.
6. Qual � il valore previsto di Ri se il vettore delle variabili esplicative �
Na 13.5, Mg 4.0, Al 1.2, Si 72.6, K 0.52, Ca 8.1, Ba 0.0, Fe 0.0
Per caricare i dati
read.csv("http://venus.unive.it/romanaz/datamin/dati/glass_data.csv",
 header=TRUE)
################################################################################
Soluzione
################################################################################
Parte C.
7. Le unit� di una popolazione appartengono al gruppo C0 o al gruppo C1.
La probabilit� che un'unit� scelta a caso appartenga a C0 � uguale a 0.65.
Su ogni unit� si osservano due variabili numeriche X1 e X2 la cui distribuzione
congiunta � normale.
Per il gruppo C0 i parametri sono m1 = m2 = 0; s1 = s2 = 1; r = 0.
Per il gruppo C1 i parametri sono m1 = m2 = 1.5; s1 = s2 = 1; r = -0.8.
Sull'unit� A abbiamo osservato X1 = 1, X2 = 1.
A quale gruppo attribuiresti A? Giustifica brevemente.
################################################################################
Soluzione
################################################################################
Parte D.
8. Considera i dati dell'indagine Qualit� della Vita 2007 de Il Sole-24Ore,
sezione demografia (variabili con iniziale E).
Dividi le province nei due gruppi: C0, Centro-Nord; C1,
Sud-Isole e stima la funzione discriminante lineare. Quali sono le province 
classificate erroneamente?
9. Determina il punto sulla curva ROC corrispondente ai risultati precedenti. 
10. Ripeti la classificazione usando il metodo kNN. Qual � il valore ottimo
di k?
Per caricare i dati
dati <- read.csv2("http://venus.unive.it/romanaz/datamin/dati/qual07.csv",
 header=TRUE)
################################################################################
Soluzione
  