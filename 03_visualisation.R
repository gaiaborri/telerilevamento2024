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

#Lista di tutti i dati disponibili in imageRy
im.list()

#importo i data presenti su imageRy in R
im.import("matogrosso_ast_2006209_lrg.jpg")

#importing data:
b2 <- im.import("sentinel.dolomites.b2.tif")

#colorRampPalette: sono funzioni utili per convertire schemi di colori "sequenziali" o "divergenti" progettati a mano in scale di colori continue
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
plot(b2, col=cl)
#otteniamo un plot con in scala di grigi

#abbiamo caricato la banda del blu, ora carichiamo le altre bande (b3,b4,b8), digitando anche la funzione plot
#quindi:
#green
b3 <- im.import("sentinel.dolomites.b3.tif")
plot(b3, col=cl)
#red
b4 <- im.import("sentinel.dolomites.b4.tif")
plot(b4, col=cl)
#nir
b8 <- im.import("sentinel.dolomites.b8.tif")
plot(b8, col=cl)

#multiframe #mfrow <- Dato un numero di grafici n, trovare una disposizione per mostrare i grafici in un array.
par(mfrow=c(2,2))
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)
#ottengo un foglio con i quattro plot in scala di grigi. Toglieno "col=cl" ottengo i quattro plot ma a colori

# stack images
#un altro metodo è impilare le bande tutte insieme e crea una vera immagine satellitare
#lo si fa con una procedura che si chiama stack
#possiamo prendere tutte le bande e considerarle come elementi di un array unendole tutte insieme con la procedura stack
#avrò una singola immagine satellitare dove avrò i singoli elementi uniti

stacksent <- c(b2, b3, b4, b8)
dev.off() # it closes devices
plot(stacksent, col=cl)
#in R i singoli elementi si selezionano con la parentesi quadra. indici di posizione=[]
plot(stacksent[[4]], col=cl)
#essendo in 2 dimensioni devo aggiungere altre due parentesi quadre avendo delle matrici

# Exercise: plot in a multiframe the bands with different color ramps
#in questo modo ottengo un foglio con 4 plot con differenti colorazioni che decido io
par(mfrow=c(2,2))

clb <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(b2, col=clb)

clg <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(b3, col=clg)

clr <- colorRampPalette(c("dark red", "red", "pink")) (100)
plot(b4, col=clr)

cln <- colorRampPalette(c("brown", "orange", "yellow")) (100)
plot(b8, col=cln)

#schema RGB 
#sono i tre colori principali, rosso, verde e blu. Si usano questi filtri e la combinazione porta a tutti i potenziali colori
#immaginiamo di eliminare uno di questi filtri tipo il rosso e ci mettiamo l'infrarosso, l'immagine cambia

#RGB space
#stacksent[[1]] =b2= blue #la banda numero 2 del blu corrisponde al primo elemento di stacksent
#stacksent[[2]] =b3= green
#stacksent[[3]] =b4= red
#stacksent[[4]] =b8= nir =infrarosso

#RGB plot
#im.plotRGB(stacksent, r=3, g=2,b=1)
im.plotRGB(stacksent, 3,2,1) #visualizzazione reale

#una banda che ci viene in aiuto per la vegetazione è la riflettanza dell'infrarosso nella foglia
#nell'immagine con i tre filtri, RGB, prendo quello del red e lo sostituisco con l'infrarosso
#quindi invece di r=3 sarà r=4 che è la banda di infrarosso vicino
#tutto ciò che riflette infrarosso diventa rosso
#la vegetazione diventa rossa. 
#infrarosso potenzia la visione esponenzialmente rispetto alle bande del visibile
im.plotRGB(stacksent, 4,2,1) #nir su rosso
im.plotRGB(stacksent, 4,3,2) #nir su rosso
#al livello visivo le due con l'infrarosso sono praticamente la stessa cosa, regola i colori la banda non correlata ovvero l'infrarosso vicino

dev.off()

#altre combinazioni
#nir on green
#inseriamo l'infrarosso nel verde piuttosto che nel rosso: nella componente greem
#il suolo nudo di questa combinazione diventa rosa
im.plotRGB(stacksent, 3, 4, 2) 

#nir on blue
#il suolo nudo diventa giallo. il giallo è il colore che colpisce di più l'occhio umano
#metto l'infrarosso nel blu, 4 nella posizione del blu=2
#composizione spesso usata per far vedere il suolo nudo, in questo caso c'è roccia quindi non si vede bene
im.plotRGB(stacksent, 3, 2, 4) #suolo nuddo giallo

#final mutliframe:exercise:put the four images altogther
par(mfrow=c(1,4))
im.plotRGB(stacksent, 3, 2, 1) #natural colors
im.plotRGB(stacksent, 4, 2, 1) #nir on red
im.plotRGB(stacksent, 3, 4, 2) #nir on green
im.plotRGB(stacksent, 3, 2, 4) #nir on blue
#ottengo i quattro plot in riga

#la funzione "pairs" per correlare le infromazioni, otteniamo diversi grafici, sulla diagonoale abbiamo la distribuzione di frequenza dei dati
pairs(stacksent)
#i grafici ci fa vedere al correlazione di tutti i pixel banda contro banda (es. blu contro il verde, il blu contro il rosso ecc.) 
#il numero rappresenta l'indice di correlazione di Pearsonvaria che varia tra -1 e 1 e definisce il grado di correlazione, i valori si abbassano quando si considera l'inbfrarosso vicino. 
#l'infrarosso aggiunge molta informazione perche la correlazione è molto minore.
#nelle immagini infatti è l'infrarosso che fa la differenza

#per sapere con quanti pixel stiamo lavorando quindi per avere info sulle immagini possiamo digitare il nome delle immagini
#dopo la funzione pairs digitimao l'immagine che ci interessa ad esempio:

pairs(stacksent)
b2
#otteniamo i dati dell'immagine e alla sezione "dimensions" moltipichiamo i primi due nuemri ed otteniamo il numero dei pixel 
immagine-> b2-> dimensions -> 934*1069

#con la funzione ncell(b2) otteniamo la stessa cosa
ncell(b2)
