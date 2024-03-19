#Satellite data visualisation in R by imageRy
library("terra")
library("imageRy")
#tutte le volte che vedremo una funzione che inizia con "im." vuol dire che è del pacchetto imageRy
#con list abbiamo la lista dei dati gia caricati nel pacchetto 
im.list()
#in questo caso non ci sono argomenti ma si intende tutta la lista
#tramite la funzione im.import() importiamo i dati in R così da poterli utilizzare
im.import("matogrosso_ast_2006209_lrg.jpg") 
#ma vogliamo dargli un nome più semplice quindi:
mato<-im.import("matogrosso_ast_2006209_lrg.jpg") 

19/03/2024
library(terra)
library(imagRy)
#importing data:
b2 <- im.import("sentinel.dolomites.b2.tif")
#abbiamo caricato la banda del verde, ora carichiamo le altre bande (b3,b4,b8)
quindi:
b3 <- im.import("sentinel.dolomites.b3.tif")
b4 <- im.import("sentinel.dolomites.b4.tif")
b8 <- im.import("sentinel.dolomites.b8.tif")
#multiframe
par(mfrow=c(2,2))
plot(b2)
plot(b3)
plot(b4)
plot(b8)
#otteniamo un plot con all'interno i 4 plot 
#schema RGB 
#sono i tre colori principali, rosso, verde e blu. Si usano questi filtri e la combinazione porta a tutti i potenziali colori
#immaginiamo di eliminare uno di questi filtri tipo il rosso e ci mettiamo l'infrarosso, l'immagine cambia

!manca un pezzo

#RGB plotting
#stacksent[[1]] =b2= blue
#stacksent[[2]] =b3= green
#stacksent[[3]] =b4= red
#stacksent[[4]] =b8= nir
#im.plotRGB(stacksent, r=3, g=2,b=1)
im.plotRGB(stacksent, 3,2,1)
im.plotRGB(stacksent, 4,2,1)
im.plotRGB(stacksent, 4,3,2)

dev.off()

#nir on green
im.plotRGB(stacksent, 3, 4, 2)

#nir on blue
im.plotRGB(stacksent, 3, 2, 4)

#final mutliframe:exercise:put the four images altogther
par(mfrow=c(2,2))
im.plotRGB(stacksent, 3, 2, 1) #natural colors
im.plotRGB(stacksent, 4, 2, 1) #nir on red
im.plotRGB(stacksent, 3, 4, 2) #nir on green
im.plotRGB(stacksent, 3, 2, 4) #nir on blue

#la funzione "pairs" per correlare le infromazioni, otteniamo diversi grafici, sulla diagonoale abbiamo la distribuzione di frequenza dei dati
pairs(stacksent)
#i grafici ci fa vedere al correlazione di tutti i pixel banda contro banda (es. blu contro il verde, il blu contro il rosso ecc.) il numero sopra l'indice varia tra -1 e 1 
#e definisce il grado di correlazione, i valori si abbassano quando si considera l'inbfrarosso vicino. 
#l'infrarosso aggiunge molta informazione perche la correlazione è molto minore.
#nelle immagini infatti è l'infrarosso che fa la differenza

#per sapere con quanti pixel stiamo lavorando quindi per avere info sulle immagini possiamo digitare il nome delle immagini
#dopo la funzione pairs digitimao l'immagine che ci interessa ad esempio:
pairs(stacksent)
b2
#otteniamo i dati dell'immagine e alla sezione dimensions moltipichiamo i primi due nuemri ed otteniamo il numero dei pixel 
#con la funzione ncell(b2) otteniamo la stessa cosa
ncell(b2)
