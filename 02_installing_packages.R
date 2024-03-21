# Installing new packages in R

# install.packages("terra")
library(terra)
install.packages("devtools")
library(devtools)

# install the imageRy package from GitHub
devtools::install_github("ducciorocchini/imageRy")
#la funzione dopo i due punti deriva da devtools
#la funzione install_github mi permette su R di andare a cercare quello che metto 
tra parentesi su github, quindi "esco" da R

library(imageRy)
