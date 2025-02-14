install.packages("terra")
intassl.packages("raster")
install.packages("imageRy")
install.packages("viridis")
install.packages("patchwork")

#carico i diversi pacchetti per lavorare
library(terra)                                                                  #terra per lavorare con immagini satellitari
library(raster)                                                                 #raster per gestire i dati raster
library(imageRy)                                                                #imageRy per manipolare le immagini
library(viridis)                                                                #viridis per caricare palette di colori utili per rappresentare i dati visivamente
library(ggplot2)                                                                #ggplot2 per creare grafici 
library(patchwork)                                                              #patchwork per combinare i grafici ggplot2

# SCALA COLORI #                                                                #definisco le scale di colori per ogni indice, composte da 100 gradazioni di colore

ndvi_color <-  colorRampPalette(c("black","grey","green","darkgreen"))(100)

ndwi_color <- colorRampPalette(c("grey", "orange", "red")) (100)

mndwi_color <-  colorRampPalette(c("grey","lightblue","blue"))(100)

urban_color <-  colorRampPalette(c("black","grey","red","darkred")) (100)


#### APRILE ####

#imposto la directory di lavoro corrente
aprile <- setwd("C:/Users/Utente/Desktop/uni/TELERILEVAMENTO/EXAM/immagini/21_aprile")

aprile

# bande #

#carico la banda 02 dell'immagine Sentinel-2 del 21 Aprile 2024 come oggetto <-rast
b2_a <- rast("2024-04-21-00_00_2024-04-21-23_59_Sentinel-2_L2A_B02_(Raw).tiff")
#carico la banda 03 dell'immagine Sentinel-2 del 21 Aprile 2024 come oggetto <-rast
b3_a <- rast("2024-04-21-00_00_2024-04-21-23_59_Sentinel-2_L2A_B03_(Raw).tiff")
#carico la banda 04 dell'immagine Sentinel-2 del 21 Aprile 2024 come oggetto <-rast
b4_a <- rast("2024-04-21-00_00_2024-04-21-23_59_Sentinel-2_L2A_B04_(Raw).tiff")
#carico la banda 08 dell'immagine Sentinel-2 del 21 Aprile 2024 come oggetto <-rast
b8_a <- rast("2024-04-21-00_00_2024-04-21-23_59_Sentinel-2_L2A_B08_(Raw).tiff")
#carico la banda 11 dell'immagine Sentinel-2 del 21 Aprile 2024 come oggetto <-rast
b11_a <- rast("2024-04-21-00_00_2024-04-21-23_59_Sentinel-2_L2A_B11_(Raw).tiff")
#carico la banda 12 dell'immagine Sentinel-2 del 21 Aprile 2024 come oggetto <-rast
b12_a <- rast("2024-04-21-00_00_2024-04-21-23_59_Sentinel-2_L2A_B12_(Raw).tiff")

# carico l'immagine True Color #                                    
#utilizza le bande dello spettro del visibile per simulare la percezione umana dei colori
#per la visualizzazione True Color vado ad utilizzare la combianzione: B4 (red), B3 (Green), B2(Blue)

t_color_a <- rast(list(b4_a,b3_a,b2_a))
#per visualizzare le immagini multispettrali in RGB uso la seguente funzione
p_tc_a <- plotRGB(t_color_a, 1, 2 ,3, main="Aprile Porto Alegre")               #con il paramentro "main" definisco il titolo al'output

#### ANALISI APRILE 2024 ####

# NDVI (Normalized Difference Vegetation Index) #                               #questo indice viene utilizzato per descrivere il livello di salute della vegetazione. Ha valori compresi tra -1 e +1  

ndvi_a <- (b8_a-b4_a)/(b8_a+b4_a)                                               #carico la banda 4 (Red) e la banda 8 (NIR)
p_ndvi_a <- plot(ndvi_a, col = ndvi_color, main = "NDVI APRILE Porto Alegre")   #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo 

# NDWI (Normalized Difference Water Index) #                                    #questo indice lo uso per monitorare il contenuto di acqua nei corpi idrici 

ndwi_a <-  (b3_a-b8_a)/(b3_a+b8_a)                                              #carico la banda 3(Green) e la banda 8 (NIR)
p_ndwi_a <- plot(ndwi_a, col= ndwi_color, main = "NDWI APRILE Porto Alegre")    #per la visualizzazione ho utilizzato una palette di colori specifici, asseganndo un titolo all'elemento
                                                                                #questo indice può essere influenzato dalla presenza di sostanza organica disciolta e dai sedimenti in sospensione, poichè alterano la riflettanza nell'intervallo del verde e del NIR, riducendo il contrasto tra acqua e suolo

# MNDWI (Modified Normalized Difference Water Index)#                           #per analizzare la presenza di acqua in un'area alluvionata ho deciso di utilizzare questo indice che devida dall'NDWI ma, mi permette di visualizzare meglio la presenza di acqua in ambienti urbani e migliora la separazione tra acqua e suolo

mndwi_a <- (b3_a-b11_a)/(b3_a+b11_a)                                            #a differnza dell'NDWI, al posto della banda NIR uso la banda SWIR (Shortwave Infrared) che corrispone alla banda 11 o 12. 
p_mndwi_a <- plot(mndwi_a, col= mndwi_color, main= "MNDWI APRILE Porto Alegre" )#per la visualizzazione ho utilizzato una palette di colori specifici, assegnano un titolo all'elemento 

# UI (Urban Index) #                                                            #questo indice viene utilizzato per visualizzare meglio al separazione tra aree urbane e non urbane.

urban_a <- (b11_a-b3_a)/(b11_a+b3_a)                                            #carico le bande SWIR (nel mio caso al banda 11) e la banda 3 (Green). In questo modo posso distinguere le superfici urbane da altre superfici naturali (vegetazione, acqua,suolo nudo) 
plot(urban_a, col= urban_color, main = "URBAN APRILE Porto Alegre")             #per la visualizzazione ho utilizzato una palette di colori spcifici, assegnando anche un titolo 

#CALCOLO deviazione standard MNDWI#                                                                                 
#la SD evidenzia aree con maggior variabilità dei valori di pixel.  
p_mndwi_a <- plot(mndwi_a, col= mndwi_color, main = "MNDWI APRILE Porto Alegre")#visualizzo il raster mndwi_a con la palette di colori definita da mndwi_color
sd13_mndwi_a <- focal(mndwi_a, w = matrix(1/169, 13, 13), fun = sd)             #calcolo SD su una finestra 13x13, quindi posso vedere le variazioni su scale ancora più ampie 
sd13_mndwi_a                                                                    #quello che otteniamo sono due valori: un valore minimo del raster: 9.569e-18, e un valore massimo: 4.676e-03. valori più alti indicano che, in alcune zone, i valori di MNDWI sono molto variabili ed indicano aree più eterogenee

#con le scale di colore nel pacchetto "viridis" si possono creare grafici per poter rappresentare meglio i dati. Sono più facili da leggere per chi soffre di daltonismo e per stampare bene in scala di grigi 
#le aree con alta SD (giallo) corrispondono ai bordi dei corsi d'acqua e alle zone d'acqua. Le zone di colore blu scuro hanno invece una SD bassa ed indicano una maggior omogeneità 
#all'aumentare della finestra, la SD si riduce e le variazioni locali diventano meno visibili.

plot(sd13_mndwi_a, col=viridis(100), main="SD MNDWI 13x13 - Aprile")            #con la finestra 13x13 vado a visualizzare variazioni su larga scala, ignorando i dettagli più fini, infatti le aree con alta SD sono concentrate lungo i corsi d'acqua. 

dev.off()


#### MAGGIO ####

#imposto la directory di lavoro corrente
maggio <- setwd("C:/Users/Utente/Desktop/uni/TELERILEVAMENTO/EXAM/immagini/06_maggio")

maggio

# bande #

#carico la banda 02 dell'immagine Sentinel-2 del 06 Maggio 2024 come oggetto <-rast
b2_m <- rast("2024-05-06-00_00_2024-05-06-23_59_Sentinel-2_L2A_B02_(Raw).tiff")
#carico la banda 03 dell'immagine Sentinel-2 del 06 Maggio 2024 come oggetto <-rast
b3_m <- rast("2024-05-06-00_00_2024-05-06-23_59_Sentinel-2_L2A_B03_(Raw).tiff")
#carico la banda 04 dell'immagine Sentinel-2 del 06 Maggio 2024 come oggetto <-rast
b4_m <- rast("2024-05-06-00_00_2024-05-06-23_59_Sentinel-2_L2A_B04_(Raw).tiff")
#carico la banda 08 dell'immagine Sentinel-2 del 06 Maggio 2024 come oggetto <-rast
b8_m <- rast("2024-05-06-00_00_2024-05-06-23_59_Sentinel-2_L2A_B08_(Raw).tiff")
#carico la banda 11 dell'immagine Sentinel-2 del 06 Maggio 2024 come oggetto <-rast
b11_m <- rast("2024-05-06-00_00_2024-05-06-23_59_Sentinel-2_L2A_B11_(Raw).tiff")
#carico la banda 12 dell'immagine Sentinel-2 del 06 Maggio 2024 come oggetto <-rast
b12_m <- rast("2024-05-06-00_00_2024-05-06-23_59_Sentinel-2_L2A_B12_(Raw).tiff")

# carico l'immagine true color #

t_color_m <- c(b4_m,b3_m,b2_m)
#per visualizzare le immagini multispettrali in RGB uso la seguente funzione
p_tc_m <- plotRGB(t_color_m, 1, 2 ,3, main= "Maggio Porto Alegre")

#### ANALISI MAGGIO 2024 ####

# NDVI  (Normalized Difference Vegetation Index)#

ndvi_m <- (b8_m-b4_m)/(b8_m+b4_m)                                               #carico la banda 4 (Red) e la banda 8 (NIR)
plot(ndvi_m, col = ndvi_color, main = "NDVI MAGGIO Porto Alegre")               #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo 

# NDWI (Normalized Difference Water Index) # 

ndwi_m <-  (b3_m-b8_m)/(b3_m+b8_m)                                              #carico la banda 3(Green) e la banda 8 (NIR)
plot(ndwi_m, col= ndwi_color, main = "NDWI MAGGIO Porto Alegre")                #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

# MNDWI (Modified Normalized Difference Water Index)#

mndwi_m <- (b3_m-b11_m)/(b3_m+b11_m)                                            #carico la banda 3(Green) e la banda 11 (SWIR)
p_mndwi_m <- plot(mndwi_m, col= mndwi_color, main= "MNDWI MAGGIO Porto Alegre" )#per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

# UI (urban index) #

urban_m <- (b11_m-b3_m)/(b11_m+b3_m)                                            #carico la banda 11 (SWIR) e la banda 3 (Green)
plot(urban_m, col= urban_color, main = "URBAN MAGGIO Porto Alegre")             #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

                                             
#CALCOLO Deviazione Standard MNDWI#

p_ndwi_m <- plot(mndwi_m, col= mndwi_color, main = "MNDWI MAGGIO Porto Alegre")
sd13_mndwi_m <- focal(mndwi_m, w = matrix(1/169, 13, 13), fun = sd)             #calcolo SD su una finestra 13x13
sd13_mndwi_m                                                                    #quello che otteniamo sono due valori: un valore minimo del raster: 2.6098e-18, e un valore massimo: 4.6676e-03.Il valore minimo corrisponde ad aree omogenee, dove i valori del MDNWI sono quasi costanti o costanti,mentre il valore più alto indica aree con maggiore variabilità spaziale all'interno della finestra, corrispondendo quindi alle zone di transizione tra acqua e terra e alle zone sommerse


#visualizzo il grafico utilizzando la palette di colori "viridis" per rappresentare meglio i dati
#le aree con alta SD (giallo) corrispondono ai bordi dei corsi d'acqua e alle zone d'acqua. Le zone di colore blu scuro hanno invece una SD bassa ed indicano una maggior omogeneità

plot(sd13_mndwi_m, col=viridis(100), main="SD MNDWI 13x13 - Maggio")            #nella finestra più grande possiamo identificare le aree con variazioni significative su larga scala,ignorando le variazioni più piccole. Le zone con SD alta sono molto estese a causa dell'alluvione  

dev.off()

#### GIUGNO ####

#imposto la directory di lavoro corrente
giugno <- setwd("C:/Users/Utente/Desktop/uni/TELERILEVAMENTO/EXAM/immagini/30_giugno")

giugno

# bande #

#carico la banda 02 dell'immagine Sentinel-2 del 30 Giugno 2024 come oggetto <-rast
b2_g <- rast("2024-06-30-00_00_2024-06-30-23_59_Sentinel-2_L2A_B02_(Raw).tiff")
#carico la banda 03 dell'immagine Sentinel-2 del 30 Giugno 2024 come oggetto <-rast
b3_g <- rast("2024-06-30-00_00_2024-06-30-23_59_Sentinel-2_L2A_B03_(Raw).tiff")
#carico la banda 04 dell'immagine Sentinel-2 del 30 Giugno 2024 come oggetto <-rast
b4_g <- rast("2024-06-30-00_00_2024-06-30-23_59_Sentinel-2_L2A_B04_(Raw).tiff")
#carico la banda 08 dell'immagine Sentinel-2 del 30 Giugno 2024 come oggetto <-rast
b8_g <- rast("2024-06-30-00_00_2024-06-30-23_59_Sentinel-2_L2A_B08_(Raw).tiff")
#carico la banda 11 dell'immagine Sentinel-2 del 30 Giugno 2024 come oggetto <-rast
b11_g <- rast("2024-06-30-00_00_2024-06-30-23_59_Sentinel-2_L2A_B11_(Raw).tiff")
#carico la banda 12 dell'immagine Sentinel-2 del 30 Giugno 2024 come oggetto <-rast
b12_g <- rast("2024-06-30-00_00_2024-06-30-23_59_Sentinel-2_L2A_B12_(Raw).tiff")

# carico l'immagine true color #

t_color_g <- c(b4_g,b3_g,b2_g)
#per visualizzare le immagini multispettrali in RGB uso la seguente funzione
p_tc_g <- plotRGB(t_color_g, 1, 2 ,3, main= "Giugno Porto Alegre")

#### ANALISI GIUGNO 2024 ####

# NDVI (Normalized Difference Vegetation Index) #

ndvi_g <- (b8_g-b4_g)/(b8_g+b4_g)                                               #carico la banda 4 (Red) e la banda 8 (NIR)
plot(ndvi_g, col = ndvi_color, main = "NDVI GIUGNO Porto Alegre")               #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

# NDWI (Normalized Difference Water Index) # 

ndwi_g <-  (b3_g-b8_g)/(b3_g+b8_g)                                              #carico la banda 3(Green) e la banda 8 (NIR)
plot(ndwi_g, col= ndwi_color, main = "NDWI GIUGNO Porto Alegre")                #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

# MNDWI (Modified Normalized Difference Water Index)#

mndwi_g <- (b3_g-b11_g)/(b3_g+b11_g)                                            #carico la banda 3(Green) e la banda 11 (SWIR)
p_mndwi_g <- plot(mndwi_g, col= mndwi_color, main= "MNDWI GIUGNO Porto Alegre" )#per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

# UI (urban index) #

urban_g <- (b11_g-b3_g)/(b11_g+b3_g)                                            #carico la banda 11(SWIR) e la banda 3 (Green)
plot(urban_g, col= urban_color, main = "URBAN GIUGNO Porto Alegre")             #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

#CALCOLO deviazione standard MNDWI#

p_mndwi_g <- plot(mndwi_g, col= mndwi_color, main = "MNDWI GIUGNO Porto Alegre")
sd13_mndwi_g <- focal(mndwi_g, w = matrix(1/169, 13, 13), fun = sd)             #calcolo SD su una finestra 13x13
sd13_mndwi_g                                                                    #ottengo un valore minimo di 9.5693e-18 ed un valore massimo di 4.8178e-03


#visualizzo il grafico utilizzando la palette di colori "viridis" per rappresentare meglio i dati

plot(sd13_mndwi_g, col=viridis(100), main="SD MNDWI 13x13 - Giugno")

dev.off()

#### AGOSTO ####

#imposto la directory di lavoro corrente
agosto <- setwd("C:/Users/Utente/Desktop/uni/TELERILEVAMENTO/EXAM/immagini/14_agosto")

agosto

# bande #

#carico la banda 02 dell'immagine Sentinel-2 del 14 Agosto 2024 come oggetto <-rast
b2_ag <- rast("2024-08-14-00_00_2024-08-14-23_59_Sentinel-2_L2A_B02_(Raw).tiff")
#carico la banda 03 dell'immagine Sentinel-2 del 14 Agosto 2024 come oggetto <-rast
b3_ag <- rast("2024-08-14-00_00_2024-08-14-23_59_Sentinel-2_L2A_B03_(Raw).tiff")
#carico la banda 04 dell'immagine Sentinel-2 del 14 Agosto 2024 come oggetto <-rast
b4_ag <- rast("2024-08-14-00_00_2024-08-14-23_59_Sentinel-2_L2A_B04_(Raw).tiff")
#carico la banda 08 dell'immagine Sentinel-2 del 14 Agosto 2024 come oggetto <-rast
b8_ag <- rast("2024-08-14-00_00_2024-08-14-23_59_Sentinel-2_L2A_B08_(Raw).tiff")
#carico la banda 11 dell'immagine Sentinel-2 del 14 Agosto 2024 come oggetto <-rast
b11_ag <- rast("2024-08-14-00_00_2024-08-14-23_59_Sentinel-2_L2A_B11_(Raw).tiff")
#carico la banda 12 dell'immagine Sentinel-2 del 14 Agosto 2024 come oggetto <-rast
b12_ag <- rast("2024-08-14-00_00_2024-08-14-23_59_Sentinel-2_L2A_B12_(Raw).tiff")

# carico l'immagine true color #

t_color_ag <- c(b4_ag,b3_ag,b2_ag)
#per visualizzare le immagini multispettrali in RGB uso la seguente funzione
p_tc_ag <- plotRGB(t_color_ag, 1, 2 ,3, main= "Agosto Porto Alegre")

#### ANALISI AGOSTO 2024 ####

# NDVI (Normalized Difference Vegetation Index) #

ndvi_ag <- (b8_ag-b4_ag)/(b8_ag+b4_ag)                                          #carico la banda 4 (Red) e la banda 8 (NIR)
plot(ndvi_ag, col = ndvi_color, main = "NDVI AGOSTO Porto Alegre")              #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

# NDWI (Normalized Difference Water Index) # 

ndwi_ag <-  (b3_ag-b8_ag)/(b3_ag+b8_ag)                                         #carico la banda 3(Green) e la banda 8 (NIR)
plot(ndwi_ag, col= ndwi_color, main = "NDWI AGOSTO Porto Alegre")               #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

# MNDWI (Modified Normalized Difference Water Index)#

mndwi_ag <- (b3_ag-b11_ag)/(b3_ag+b11_ag)                                       #carico la banda 3(Green) e la banda 11 (SWIR)
p_mndwi_ag <- plot(mndwi_ag, col= mndwi_color, main= "MNDWI AGOSTO Porto Alegre" ) #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo

# UI (urban index)#

urban_ag <- (b11_ag-b3_ag)/(b11_ag+b3_ag)                                       #carico la banda 11(SWIR) e la banda 3 (Green)
plot(urban_ag, col= urban_color, main = "URBAN AGOSTO Porto Alegre")            #per la visualizzaizone ho utilizzato una palette di colori spceifica, così da rendere l'immagine più intuitiva, assegnando anche un titolo


#CALCOLO deviazione standard MNDWI#                               

p_mndwi_ag <- plot(mndwi_ag, col= mndwi_color, main = "MNDWI AGOSTO Porto Alegre")
sd13_mndwi_ag <- focal(mndwi_ag, w = matrix(1/169, 13, 13), fun = sd)           #calcolo SD su una finestra 13x13
sd13_mndwi_ag                                                                   #ottengo un valore minimo di 9.5693e-18 ed un valore massimo di 4.4373e-03

#visualizzo i grafici utilizzando la palette di colori "viridis" per rappresentare meglio i dati
plot(sd13_mndwi_ag, col=viridis(100), main="SD MNDWI 13x13 - Agosto")

dev.off()

#IMMAGINI TRUE COLOR DEI MESI IN ESAME#

par(mfrow = c(2, 2), mar = c(6, 6, 5, 5), oma = c(1, 1, 3, 1))
p_tc_a <- plotRGB(t_color_a, 1, 2 ,3, main="Aprile Porto Alegre")
p_tc_m <- plotRGB(t_color_m, 1, 2 ,3, main= "Maggio Porto Alegre")
p_tc_g <- plotRGB(t_color_g, 1, 2 ,3, main= "Giugno Porto Alegre")
p_tc_ag <- plotRGB(t_color_ag, 1, 2 ,3, main= "Agosto Porto Alegre")

##CONFRONTI INDICI NDVI, NDWI, MNDWI e UI TRA I PERIODI IN ESAME##

#CONFRONTO NDVI MAGGIO - AGOSTO#                                              

par(mfrow= c(1,2))
plot(ndvi_m, col= ndvi_color, main = "NDVI MAGGIO Porto Alegre")
plot(ndvi_ag, col= ndvi_color, main = "NDVI AGOSTO Porto Alegre")
#Quello che osserviamo è una netta differenza della situazione durante l'alluvione e post alluvione
#In Maggio la zona mostra un 'ampia estenzione delle zone verdi chiare/grigie, che indica una forte presenza di acqua e quindi vegetazione sommersa.
#Le inondazioni  ho impattato significativamente sulla vegetazione, riducendo la riflessione della luce e l'assorbimento della vegetazione
#In Agosto invece la situazione è tornata alla normalità, infatti l'indice NDVI mostra che la vegetazione è tornata a crescere anche in prossimità dei fiumi e che le aree grigie corrispondono ai corsi d'acqua.

dev.off()

#CONFRONTO NDVI APRILE - AGOSTO#
par(mfrow= c(1,2))
plot(ndvi_a, col= ndvi_color, main = "NDVI APRILE Porto Alegre")
plot(ndvi_ag, col= ndvi_color, main = "NDVI AGOSTO Porto Alegre")
#questa è la situazione della vegatazione pre e post alluvione. 
#nel periodo di Agosoto la situazione si è ripristinata quasi totalmente, eccetto per le zone in prossimità dei corsi dei fiumi e del Lago Guaìba dove infatti, l'indice evidenzia un minor densità della vegetaizone, probabilmente in via di recupero. 

#CONFRONTO NDWI#
par(mfrow= c(2,2))
plot(ndwi_a, col= ndwi_color, main = "NDWI APRILE Porto Alegre") 
plot(ndwi_m, col= ndwi_color, main = "NDWI MAGGIO Porto Alegre") 
plot(ndwi_g, col= ndwi_color, main = "NDWI GIUGNO Porto Alegre")
plot(ndwi_ag, col= ndwi_color, main = "NDWI AGOSTO Porto Alegre")
#indice influenzato dalla presenza di sostanza organica disciolta e dai sedimenti in sospensione 

dev.off()

#CONFRONTO MNDWI APRILE - MAGGIO#

par(mfrow= c(1,2))                                   
plot(mndwi_a, col= mndwi_color, main = "MNDWI APRILE Porto Alegre")
plot(mndwi_m, col= mndwi_color, main = "MNDWI MAGGIO Porto Alegre")
#Confrontando la situazione pre e durante l'alluvione possiamo notare visivamente l'estensione dell'area alluvionata. 
#Con l'indice MNDWI, le aree blu (valori vicini all'1) indicano tipicamente la presenza di acqua. Nel grafico di Maggio vediamo una netta differenza della portata d'acqua dei fiumi, il che conferma una situazione alluvionata.  
#Ad Aprile, i valori della SD dell'indice MNDWI indicano una minor variazione delle superfici acquatiche, infatti la situazione idrica è più stabile
#A Maggio, i valori derivanti dal calcolo della SD MNDWI sono molto più alti, a significare un aumento elevato della presenza d'acqua.
#L'aumento della SD tra Aprile e Maggio è coerente con la maggiore eterogeneità dell'indice MNDWI nel periodo dell'alluvione 

#CONFRONTO MNDWI MAGGIO - GIUGNO#

par(mfrow= c(1,2))                                   
plot(mndwi_m, col= mndwi_color, main = "MNDWI MAGGIO Porto Alegre")
plot(mndwi_g, col= mndwi_color, main = "MNDWI GIUGNO Porto Alegre")
#Osservando le due situazioni possiamo notare come il livello di acqua si sia ritirato
#Le aree blu (MNDWI=1) nel mese di Giugno infatti risultano più ristrette, suggerendo un ritiro dell'acqua e quindi delle condizioni normali. 

dev.off()

#CONFRONTO MNDWI  MAGGIO - AGOSTO#

par(mfrow= c(1,2))
plot(mndwi_m, col= mndwi_color, main = "MNDWI MAGGIO Porto Alegre")
plot(mndwi_ag, col= mndwi_color, main = "MNDWI AGOSTO Porto Alegre")
#In questo caso osserviamo invece la portata d'acqua durante l'alluvione e post alluvione
#Ovviamente come ci aspettavamo, nel periodo di Maggio le zone blu scuro mostrano chiaramente i fiumi in piena che si sono espansi oltre i loro confini naturali creando ampie aree allagate
#In Agosto invece, le aree blu sono nettamente diminuite con una padronanza delle zone grigie, quindi l'acqua si è ritirata restando solo nelle zone di origine dei corsi d'acqua.

dev.off()

#CONFRONTO UI#

par(mfrow= c(2,2))
plot(urban_a, col= urban_color, main = "URBAN APRILE Porto Alegre") 
plot(urban_m, col= urban_color, main = "URBAN MAGGIO Porto Alegre") 
plot(urban_g, col= urban_color, main = "URBAN GIUGNO Porto Alegre")
plot(urban_ag, col= urban_color, main = "URBAN AGOSTO Porto Alegre") 
#essendo una zona molto urbanizzata possiamo notare che anche questa componente è stata fortemente impattata dall'alluvione.
#valori positivi indicano aree fortemente urbanizzate, mentre valori negativi indicano zone non urbanizzate (boschi, acqua, terreni agricoli)

dev.off()

#DIFFERENZE SD SULL'INDICE MNDWI NEI PERIODI IN ESAME#                          #mi permette di vedere quanto la variabiità dell'acqua nei mesi ed individuare le zone rimaste stabili e quelle invece soggette ad inondazione

#CALCOLO DIFFERENZA SD MNDWI MAGGIO- APRILE#                                   

diffsd1MNDWI <- sd13_mndwi_m - sd13_mndwi_a
plot(diffsd1MNDWI, col= viridis(100), main= "SD DIFFERENZA MNDWI MAGGIO - MNDWI APRILE")
#la mappa che otteniamo ci evidenzia un marcato aumento della variabilità delle aree fluviali.
#le zone evidenziate in giallo/verde sono quelle più colpite dall'accumulo di acqua e rappresentano un aumento della variazione a Maggio rispetto ad Aprile. Questo ci suggerisce che l'acqua ha invaso aree normalmente asciutte.
#le aree in blu scuro/viola indicano zone con già presenza di acqua ad Aprile (infatti visibili lungo i principali corsi dei fiumi) che non hanno subito grandi cambiamenti. 

dev.off()

#CALCOLO DIFFERENZA SD MNDWI MAGGIO - AGOSTO#

diffsd2MNDWI <- sd13_mndwi_m - sd13_mndwi_ag
plot(diffsd2MNDWI, col= viridis(100), main= "SD DIFFERENZA MNDWI MAGGIO - MNDWI AGOSTO")
#in questo caso i valori più alti sono leggermente più lontani dai corsi dei fiumi principali 
#le zone gialle/verdi (quelle colpite dall'accumulo di acqua) sono in diminuzione ma ancora in fase di drenaggio 
#le zone blu scuro sono aumentate includendo, oltre ai fiumi principali anche aree prima di color giallo/verde, questo ci può far capire che in queste aree l'acqua si è completamente ritirata ed il suolo è tornato asciutto. 

dev.off()

#CALCOLO DIFFERENZA SD MNDWI APRILE - AGOSTO#

diffsd3MNDWI <-sd13_mndwi_ag - sd13_mndwi_a
plot(diffsd3MNDWI, col=viridis(100), main= "SD DIFFERENZA MNDWI AGOSTO - MNDWI APRILE")
#ad agosto la situazione è molto simile a quella pre alluvione, eccetto per alcune zone con sd alta che mostrano ancora una maggiore variabilità rispetto ad aprile 

dev.off()

par(mfrow= c(3,1))
plot(diffsd1MNDWI, col= viridis(100), main= "SD DIFFERENZA MNDWI MAGGIO - MNDWI APRILE")
plot(diffsd2MNDWI, col= viridis(100), main= "SD DIFFERENZA MNDWI MAGGIO - MNDWI AGOSTO")
plot(diffsd3MNDWI, col=viridis(100), main= "SD DIFFERENZA MNDWI AGOSTO - MNDWI APRILE")

# ANALISI % ACQUA PRE, DURANTE E POST INONDAZIONE (APRILE - MAGGIO- GIUGNO- AGOSTO) #

#per tutti i periodi in esame ho classificato l'immagine in due classi (acqua e non acqua), calcolato le frequenze di ciascuna classe, determinato le proporzioni e le percentuali relative a ciascuna classe di pixel nell'immagine MNDWI

# 1= acqua; 2= non acqua 

#APRILE#

class_mndwi_a <- im.classify(mndwi_a, num_clusters = 2)                         #classifico l'indice mndwi di aprile con due classi, max e min così da avere netta distinzione tra acqua (1) e non acqua (2)
plot(class_mndwi_a, main= "ANALISI % ACQUA - APRILE -")

f_mndwi_a <- freq(class_mndwi_a)                                                #La funzione freq() mi restituisce la frequenza (nuemro di pixel) per ciascuna delle classi presenti nell'immagine classificata.
f_mndwi_a                                                                       #ottengo quindi il numero di celle (pixel) che appartengono a ciascuna delle due classi.
#otteniamo che: la classe "1" ha 57,300 pixel e la classe "2" ha 923,950 pixel.
#infatti anche osservando l'immagine possiamo confermare che la classe "2" occupa una porzione molto maggiore dell'immagine rispetto alla classe "1".

tot_mndwi_a <- ncell(class_mndwi_a)                                             #con ncell() calcolo il numero totale di pixel nell'immagine che ho classificato
tot_mndwi_a                                                                                                                                      
prop_mndwi_a <- f_mndwi_a/tot_mndwi_a                                           #calcolo proporzione tra le frequenze delle singole classi (numero di pixel delle singole classi) rispetto al numero totale dei pixel
prop_mndwi_a
perc_mndwi_a <- prop_mndwi_a*100                                                #proporzione delle singole classi * 100 per avere la percentuale delle classi nell'immagine. Si visualizza in count
perc_mndwi_a

#le percentuali ottenute dimostrano che il 5.84% dei pixel nell'immagine appartengono alla classe "1", mentre il 94.16 % appartengono alla classe "2"

dev.off()

#MAGGIO#

class_mndwi_m <- im.classify(mndwi_m, num_clusters = 2)
plot(class_mndwi_m, main= "ANALISI % ACQUA - MAGGIO -")

f_mndwi_m <- freq(class_mndwi_m)
f_mndwi_m
#otteniamo che: la classe "1" ha 232,607 pixel e la classe "2" ha 748,643 pixel.
#osservando l'immagine possiamo vedere come la classe "1" è aumentata notevolemte, occupando zone molto estese.

tot_mndwi_m <- ncell(class_mndwi_m)
tot_mndwi_m
prop_mndwi_m <- f_mndwi_m/tot_mndwi_m
prop_mndwi_m
perc_mndwi_m <- prop_mndwi_m*100
perc_mndwi_m

#otteniamo che il 23.70% dei pixel nell'immagine appartengono alla classe "1", ed il 76.29% alla classe "2"
#seppur le zone con non-acqua sono maggiori, è visibilmente chiaro che la percentuale di pixel della classe "1" è nettamente alta.
#circa un quarto dell'area osservata è coperta da acqua

#GIUGNO#

class_mndwi_g <- im.classify(mndwi_g, num_clusters = 2)
plot(class_mndwi_g, main= "ANALISI % ACQUA - GIUGNO -")

f_mndwi_g <- freq(class_mndwi_g)
f_mndwi_g
#la classe "1" ha 121,982 pixel e la classe "2" ha 859,268 pixel.
#quindi la classe "1" sta procedendo verso un ritiro

tot_mndwi_g <- ncell(class_mndwi_g)
tot_mndwi_g
prop_mndwi_g <- f_mndwi_g/tot_mndwi_g
prop_mndwi_g
perc_mndwi_g <- prop_mndwi_g*100
perc_mndwi_g
#in questa fase di transizione tra pre alluvione e durante l'alluvione, la percentuale di pixel nell'immagine che appartengono alla classe "1" è di 12.43% e la classe "2" di 87.56%.
#quindi notiamo che già nel mese successivo all'alluvione la situazione stava già migliorando 


#AGOSTO#

class_mndwi_ag <- im.classify(mndwi_ag, num_clusters = 2)
plot(class_mndwi_ag, main= "ANALISI % ACQUA - AGOSTO - ")

f_mndwi_ag <- freq(class_mndwi_ag)
f_mndwi_ag
#la classe "1" ha 74,747 pixel e la classe "2" ha 906,503 pixel.

tot_mndwi_ag <- ncell(class_mndwi_ag)
tot_mndwi_ag
prop_mndwi_ag <- f_mndwi_ag/tot_mndwi_ag
prop_mndwi_ag
perc_mndwi_ag <- prop_mndwi_ag*100
perc_mndwi_ag
#il 7.61% dei pixel nell'immagine appartiene alla classe "1" , mentre il 92.38% alla classe "2"
#la situazione post alluvione è molto simile alla situazione pre alluvione 

dev.off()

#CONFRONTO IN TABELLA DELLE PERCENTUALI#

classi <- c("acqua","non-acqua")                                                #vettore che serve per le classi. Colonna classi ha due righe acqua e non-acqua
aprile <- c(5.83,94.16)                                                         #Colonna aprile ha acqua 5.83%  e non-acqua 94.16%
maggio <- c(23.70,76.29)                                                        #Colonna maggio ha acqua 23.70%  e non-acqua 76.29%


tab_acqua <- data.frame(classi, aprile, maggio)                                 #con data.frame() faccio un dataframe che ha 3 colonne che corrispondono: la prima classi, aprile , maggio. Ciascuna colonna ha le sue righe
tab_acqua

par(mfrow= c(2,1))
plot(class_mndwi_a, main= "ANALISI % ACQUA - APRILE -")
plot(class_mndwi_m, main= "ANALISI % ACQUA - MAGGIO -")

classi <-c("acqua", "non-acqua")
maggio <-c(23.70,76.29)                                                         #Colonna maggio ha acqua 23.70%  e non-acqua 76.29%
agosto <-c(7.61,92.38)                                                          #Colonna agosto ha acqua 7.61%  e non-acqua 92.38%

tab_acqua2 <- data.frame(classi, maggio, agosto)                                #con data.frame() faccio un dataframe che ha 3 colonne che corrispondono: la prima classi, giugno , luglio. Ciascuna colonna ha le sue righe
tab_acqua2

par(mfrow= c(2,1))
plot(class_mndwi_m, main= "ANALISI % ACQUA - MAGGIO -")
plot(class_mndwi_ag, main= "ANALISI % ACQUA - AGOSTO -")

#GRAFICI A CONFRONTO#

p1 <- ggplot(tab_acqua, aes(x=classi, y=aprile, color=classi)) + geom_bar(stat="identity", fill="white") + ylim(0,100)
p2 <- ggplot(tab_acqua, aes(x=classi, y=maggio, color=classi)) + geom_bar(stat="identity", fill="white") + ylim(0,100)

p1+p2  

p3 <- ggplot(tab_acqua2, aes(x=classi, y=maggio, color=classi)) + geom_bar(stat="identity", fill="white") + ylim(0,100)
p4 <- ggplot(tab_acqua2, aes(x=classi, y=agosto, color=classi)) + geom_bar(stat="identity", fill="white") + ylim(0,100)

p3+p4
