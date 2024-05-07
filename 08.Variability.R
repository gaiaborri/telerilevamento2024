# Measuring variability from satellite imagery

library(imageRy)
library(terra)
# install.packages("viridis")
library(viridis)

im.list()

sent <- im.import("sentinel.png")

im.plotRGB(sent, 1, 2, 3)

# NIR = band 1
# red = band 2
# green = band 3

im.plotRGB(sent, r=2, g=1, b=3)

#La prima banda NIR dell'immagine viene assegnata alla variabile nir
nir <- sent[[1]]

#Viene creata una paletta di colori che va dal rosso all'arancione al giallo
#composta da 100 gradazioni di colore.
cl <- colorRampPalette(c("red","orange","yellow"))(100)
plot(nir, col=cl)

#Viene calcolata la deviazione standard su una finestra 3x3 della variabile nir utilizzando la 
#funzione focal() con una matrice di pesi 3x3, e il risultato viene assegnato a sd3.
#focal(x, w, fun) --> x: la matrice o il raster su cui applicare l'operazione.
#w: la matrice di pesi che definisce la finestra per calcolare le statistiche focali.
#fun: la funzione di aggregazione da applicare ai valori all'interno della finestra.
sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)
plot(sd3)

#La funzione viridis(7) restituisce una palette di colori Viridis con 7 colori.
#La funzione appena creata viene chiamata con l'argomento (256) per ottenere una palette di 256 colori
#Infine, la funzione plot() viene utilizzata per visualizzare il grafico della deviazione standard sd3, 
#e la palette di colori viridisc viene utilizzata per colorare il grafico.
#In questo modo, il grafico della deviazione standard sd3 viene visualizzato utilizzando una scala di colori Viridis.
viridisc <- colorRampPalette(viridis(7))(256)
plot(sd3, col=viridisc)

# Standard deviation 7x7
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd)
plot(sd7, col=viridisc)

# stack
stacksd <- c(sd3, sd7)
plot(stacksd, col=viridisc)

# Standard deviation 13x13
sd13 <- focal(nir, matrix(1/169, 13, 13), fun=sd)

stacksd <- c(sd3, sd7, sd13)
plot(stacksd, col=viridisc)
