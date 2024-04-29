# How to import external data in R
#esco da R, vado in una cartella del mio computer
#importo il dato

library(terra)
library(imageRy)

#uso funzione setworkingdirectory setwd per definire dove si trova nostra immagine
#inizialmente c'è la lettera C maiuscola con il backslash ma a R non piace
#quindi devo cambiare la direzione degli slash
setwd("C:/Users/Mattia/Downloads/immagini lezioni R")

#poi uso una funzione che crea dei raster spaziali
rast("eclissi.png")

eclissi <- rast("eclissi.png") 

im.plotRGB(eclissi, 1, 2, 3)
im.plotRGB(eclissi, 2, 1, 3)
im.plotRGB(eclissi, 3, 1, 2)

#differenza tra 2 bande
dif = ecissi[[1]] - eclissi[[2]]
plot(dif)


#import another image 
desertification <- rast(""C:/Users/Mattia/Downloads/immagini lezioni R/sahel_desertification.jpg")

im.plotRGB(desertification, 1, 2, 3)
im.plotRGB(desertification, 2, 1, 3)
im.plotRGB(desertification, 3, 1, 2)

# importing Copernicus data
soil <- rast("C:/Users/Mattia/Downloads/immagini lezioni R/c_gls_SSM1km_202404210000_CEURO_S1CSAR_V1.2.1.nc")
plot(soil)

# la funzione crop per ritagliare ciò che mi interessa attraverso le coordinate del grafico
ext <- c(25, 30, 55, 58)
soilcrop <- crop(soil, ext)
plot(soilcrop)
