#time series analysis

#per time series si intende prendere immagini e vederle nel tempo 
#the first method was based on classification

library (imageRy)
library(terra)

im.list()

#EN sta per European nitogen, e le numerazioni vanno da gennaio (01) a marzo 2020 (13)
#importing data

EN01<- im.import(""EN_01.png"")
EN13<- im.import(""EN_13.png"")
#In EN01 notiamo che la parte in italia è molto scandalosa con quella macchia rossa,
#si notano anche le città principali come Roma, Napoli
#il nostro problema è l'emissione da parte dell'agricoltura
#in EN13 situazione a marzo del 2020 e la situazione è decisamente migliore
#questo per via del Covid, che non ci permetteva grandi spostamenti 
#facciamo un par per metterli vicini

par(mfrow=c(2,1)) #così ottengo il plot con le due immagini una sopra e una sotto, non vicine
im.plotRGB.auto(EN01)
im.plotRGB.auto(EN13)
#otteniamo un plot con entrambe le immagini

#confronto tra livelli 
difEN = EN01[[1]] - EN13[[1]]
cl <- colorRampPalette(c("blue", "white","red")) (100)
#ho preso i pixel del primo livello di EN01 e ci sottraggo i pixel del primo livello di EN13 
#mi dirà quali punti hanno avuto un cambiamento più sentito

cl
difEN
dev.off()
plot(difEN, col=cl)
#otteniamo il grafico con i cambiamenti, il rosso rileva i valori maggiori,
#il blu rappresenta il contrario
#possiamo quantificare il cambiamento
#non abbiamo fatto una classificazione ma abbiamo mantenuto valori continui  

#Scioglimento dei ghiacciai in Groenlandia 

#il proxy è un variabile più facile da misurare
#il programma Copernicus ha 4 aree di studio, e nell'energia c'è il "Land Surface Temperature"
#ovvero una variabile che riguarda la temperatura del suolo
#il dataset EuroLST riguarda i dati solo dell'Europa
#i dati da prednere sono quelli con "greenland" in im.list()

g2000<- im.import("greenland.2000.tif")
clg<- colorRampPalette(c("black","blue","white","red")) (100)
plot(g2000, col=clg)
#la temperatura più bassa è visualizzata tramite il nero, quindi il ghiaccio nella zona più interna
#viene mantenuta per più tempo rispetto alle parti più esterne 
#sono dati a 16 bit 


#importiamo tutte le immagini

g2005 <- im.import("greenland.2005.tif")
g2010 <- im.import("greenland.2010.tif")
g2015 <- im.import("greenland.2015.tif")

par(mfrow=c(1,2))
plot(g2000,col=clg)
plot(g2015,col=clg)

par(mfrow=c(2,2))
plot(g2000,col=clg)
plot(g2005,col=clg)
plot(g2010,col=clg)
plot(g2015,col=clg)

#al posto della funzione "par" posso usare la funzione "stack"
greenland <- c(g2000, g2005, g2010, g2015)
plot(greenland, col=clg)

#ho preso la mia immagine con i 4 livelli e faccio li differenza tra il primo  e il quarto
#che corrisponde al 2000 e al 2015
#quindi:
dev.off()
difg= greenland[[1]] - greenland[[4]]
plot(difg, col=cl)

#la zona blu sta a significare l'aumento di temperatura 

#ammettiamo di prendere 3 livelli di un RGB, quindi R,G, e B
#per ognuno ci metto un anno
#quindi R=2000, G=2005,  B=2015
#se la mappa diventa rossa allora ho dei valori più alti nel 2000 e così per ogni colore ed anno

im.plotRGB(greenland, r=1, g=2, b=4)

#tutte le parti che diventano blu hanno temperature più alte, tra cui anche quella molto scura centrale 
#con questo plot posso associare a ogni componente una banda.
#quantifico il cambiamento mantenendo valori continui 






