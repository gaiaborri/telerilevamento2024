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

#per essere sicuro delle nostre classi

plot(m1992c)
#class 1 forest
#class 2 human 

#calcolo del numero di pixel per ogni cluster con la FREQUENZA

#Calculating Frequency
#per frequenza si intende quanto un parametro viene ripetuto in un insieme (es. quanti maschi ci sono in classe? F=10)

#1992

f1992<- freq(m1992c)
f1992
  layer value   count
1     1     1 1495563 #numero di pixel del suolo nudo
2     1     2  304437 #numero di pixel della foresta 

#funzione per calcolare il totale di pixel : ncell()
tot1992<- ncell(m1992c)
tot1992
[1] 1800000

prop1992= f1992/tot1992
prop1992

  layer        value     count
1 5.555556e-07 5.555556e-07 0.8308683
2 5.555556e-07 1.111111e-06 0.1691317

perc1992= prop1992*100
       layer        value    count
1 5.555556e-05 5.555556e-05 83.08683
2 5.555556e-05 1.111111e-04 16.91317

#Riorganizzando i dati abbiamo:
#percentages: forest= 83%; human= 17%

#2006

f2006<- freq(m2006c)
f2006
 layer value   count
1     1     1 3262004
2     1     2 3937996

#funzione per calcolare il totale di pixel : ncell()
tot2006<- ncell(m2006c)
tot2006
[1] 7200000

prop2006= f2006/tot2006
prop2006
layer        value     count
1 1.388889e-07 1.388889e-07 0.4530561
2 1.388889e-07 2.777778e-07 0.5469439

perc2006= prop2006*100
perc2006
layer        value    count
1 1.388889e-05 1.388889e-05 45.30561
2 1.388889e-05 2.777778e-05 54.69439

#Riorganizzando i dati abbiamo:
#percentages: forest= 54%; human= 45% o l'inverso??

#Bulding the dataframe
class <- c("forest","human")
y1992 <- c(83,17) #! i numeri non vanno tra virgolette
y2006 <- c(45,55) 

tabout <- data.frame(class, y1992,y2006)
tabout
   class y1992 y2006
1 forest    83    45
2  human    17    55

#se voglio vederla come tabella uso la funzione View(tabout)

#ggplot2 graphs

ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white")
ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white")

#stat="identity" ovvero valore della statistica così come lo abbiamo e fill è il colore

#per mettere insieme i grafici si usa un pacchetto chiamato "patchwork"
install.packages("patchwork")
library(patchwork)

#ad ognuno dei due grafici sopra assegnamo un oggetto 

p1 <- ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white")

p1 + p2

#la scala dei due grafici è diversa e questo crea confusione 
#per ovviare al problema si usa un'altra funzione chiamata ylim con 100 perchè è una percentuale 
#Correct ggplot
p1 <- ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p2 <- ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))

p1 + p2


