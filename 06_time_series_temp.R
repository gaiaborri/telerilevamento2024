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
#non abbiamo fatto una classificazione ma abbiamo mantenuto i valori 




