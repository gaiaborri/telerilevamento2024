# spectral indices
#visualizziamo delle immagini da satellite

library(imageRy)
library(terra)

# list of files:
im.list()

# importing data
# https://visibleearth.nasa.gov/images/35891/deforestation-in-mato-grosso-brazil/35892l
m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")

# band 1 = nir = R
# band 2 = red = G
# band 3 = green = B

im.plotRGB(m1992, 1, 2, 3)

# Exercise: put the nir ontop of the G component
im.plotRGB(m1992, 2, 1, 3)

# nir ontop of the B component
im.plotRGB(m1992, 2, 3, 1)

# importing the 2006 image
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
# nir on the green component of RGB 
im.plotRGB(m2006, 2, 1, 3)
# nir on the blue component of RGB
im.plotRGB(m2006, 2, 3, 1)

# multiframe
par(mfrow=c(2,3))
im.plotRGB(m1992, 1, 2, 3) # nir on R 1992
im.plotRGB(m1992, 2, 1, 3) # nir on G 1992
im.plotRGB(m1992, 2, 3, 1) # nir on B 1992
im.plotRGB(m2006, 1, 2, 3) # nir on R 2006
im.plotRGB(m2006, 2, 1, 3) # nir on G 2006
im.plotRGB(m2006, 2, 3, 1) # nir on B 2006

#cos'è la biomassa? è la massa biologica che c'è in un sistema, le piante ricoprono la maggior parte delle biomassa sul nostro pianeta
#le piante rifelttono molto l'infrarosso, infatti il blu e il rosso vengono del tutto assorbiti. 
#posso calcolare degli indici
#il rosso viene assorbito per far partire il trasporto degli elettroni e poi il ciclo di Calvin
#per riflettanza si intende la divisione tra la radiazione riflessa e quella incidente 
#l'indice DVI (difference vegetation index) è l'indice di vegetazione basato sulla differenza
#quando la riflettanza dell'infrarosso è molto bassa allora la pianta sta andando incontro a morte
#viceversa se il rosso viene assorbito molto allora la fotosintesi funziona
#con il DVI possiamo fare un calcolo della biomassa stimata di una certa area. 
#con il rosso otteniamo la firma spettrale 
#red edge: bordo, ultima parte vicino al rosso, indica il grado di salute della pianta,
#se la pendenza è molto altra tra il rosso e l'infrarosso allora la pianta è sana, se diminuisce la pianta è in sofferenza
#l'NDVI usa il rosso e l'infrarosso (nir)

# vegetation indices

library(imageRy)
library(terra)

im.list()


#usiamo l'immagine mato grosso
#NASA Earth Observatory
#nel sito NASA Visible Earth si trovano le immagini gratuite
im.import("matogrosso_l5_1992219_lrg.jpg" )
m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg") 
#hanno fatto false color: 3 bande infrarosso, rosso e verde

# bands: 1=NIR, 2=RED, 3=GREEN
#plotting 
im.plotRGB(m1992, 1, 2, 3)
#tutto quello che diventa rosso è vegetazione 

#nir su verde
im.plotRGB(m1992, 2, 1, 3)
#parti rosa:suolo nudo

#nir su blu
im.plotRGB(m1992, 2, 3, 1)

# import the recent image
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")

#ASTER: satellite più recente
#con più bande, ha sia l'infrarosso vicino, medio e termico 
im.plotRGB(m2006, 2, 3, 1)

#multiframe with 1992 and 2006 images with par()
par(mfrow=c(1,2))
im.plotRGB(m1992, 1, 2, 3)
im.plotRGB(m2006, 1, 2, 3)

dev.off()

#nir on top of green
im.plotRGB(m2006, 2, 1, 3)
#nir on top of blu
im.plotRGB(m2006, 2, 3, 1) 

#per vedere le 6 immmagini in un unico plot
par(mfrow=c(2,3))
#mettiamo tutte e 6 le immagini
im.plotRGB(m1992, r=1, g=2, b=3) #1992 nir on red
im.plotRGB(m1992, 2, 1, 3) #1992 nir on green
im.plotRGB(m1992, 2, 3, 1) #1992 nir on blue
im.plotRGB(m2006, 1, 2, 3) #2006 nir on red
im.plotRGB(m2006, 2, 1, 3) #2006 nir on green
im.plotRGB(m2006, 2, 3, 1) #nir on blue

#plot prima barra (nir)
plot(m2006[[1]])

#3 risoluzioni: spaziale, spettrale , radiometrica (ovvero quanti valori nella codificazione in beat stiamo usando)

# build a multiframe with 1992 and 2006 images
par(mfrow=c(1,2))
im.plotRGB(m1992, r=2, g=3, b=1)
im.plotRGB(m2006, r=2, g=3, b=1)

# DVI = NIR - RED
# bands: 1=NIR, 2=RED, 3=GREEN

dvi1992 = m1992[[1]] - m1992[[2]]
plot(dvi1992)

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi1992, col=cl)

# exercise: calculate dvi of 2006
dvi2006 = m2006[[1]] - m2006[[2]]
plot(dvi2006, col=cl)

# NDVI
ndvi1992 = (m1992[[1]] - m1992[[2]]) / (m1992[[1]] + m1992[[2]])
ndvi1992 = dvi1992 / (m1992[[1]] + m1992[[2]])
plot(ndvi1992, col=cl)

# NDVI
ndvi2006 = dvi2006 / (m2006[[1]] + m2006[[2]])
plot(ndvi2006, col=cl)

# par
par(mfrow=c(1,2))
plot(ndvi1992, col=cl)
plot(ndvi2006, col=cl)

clvir <- colorRampPalette(c("violet", "dark blue", "blue", "green", "yellow"))(100) # specifying a color scheme
par(mfrow=c(1,2))
plot(ndvi1992, col=clvir)
plot(ndvi2006, col=clvir)

# speediing up calculation
ndvi2006a <- im.ndvi(m2006, 1, 2)
plot(ndvi2006a, col=cl)
