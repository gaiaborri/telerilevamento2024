#Classificare la copertura forestale. 
#selezioniamo pixel casuali 
#siti di prova 
#i gruppi di oggetti si chiamano cluster, ovvero un insieme di pixel presi in modo casuale
#se ho un pixel  verde che si colloca nel grafico in posizione casuale, come faccio a capire se appartiene al cluster nero o rosso?
#si fa la media dei tre rossi, poi la media dei tre neri e calcolo la distanza che c'è tra il verde e la media del nero e del rosso
#training-side 

#quantifying land cover variability

install.packages("ggplot2")
library("ggplot2")
library("terra")
library("imageRy")

#Listing images
im.list ()

#importing data
im.import("matogrosso_l5_1992219_lrg.jpg") 
m1992<-im.import("matogrosso_l5_1992219_lrg.jpg") 

#importing data (sun_image) Eclissi Solare!

sun<-im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

#classificazione dei tre livelli energetici dell'immagine solare
#con il comando im.classify()
#il num_clusters è il numero di classi che secondo noi sono valide

sunc<-im.classify(sun,num_clusters=3)

#la prima classe ha raggurppato i pixel appartenenti al livello energetico più basso 
#la seconda appartiene a l'ultimo livello e l'ultima a quella intermedia.

#ritorniamo al Mato Grosso

m1992<-im.import("matogrosso_l5_1992219_lrg.jpg") 
m2006<-im.import("matogrosso_ast_2006209_lrg.jpg")

#Classifying images
m1992c <- im.classify(m1992,num_clusters=2)

#la classe numero 1 è il suolo nudo (human)
#la classe numero 2 è la foresta (forest)

m2006c <- im.classify(m2006,num_clusters=2)
#la classe numero 1 è la foresta (forest)
#la classe nuemro 2 è suolo nudo (human)

#con le frequenze ottengo el percentuali delle due classi 














