# Installing new packages in R

# install.packages("terra")
#per verificare se il pacchetto che andrò ad usare è stato caricato uso la funzione library

library(terra)
install.packages("devtools")
library(devtools)

#per usare la funzione install.github devo prima installare devotools
#intall.github dipende dal devtools
#quindi una volta installato devtools, installo il pacchetto imageRy

# installare il pacchetto imageRy da GitHub

devtools::install_github("ducciorocchini/imageRy")
#la funzione dopo i due punti deriva da devtools (questo è dentro al CRAN)
#la funzione install_github mi permette su R di andare a cercare quello che metto tra parentesi su github, quindi "esco" da R

library(imageRy)
