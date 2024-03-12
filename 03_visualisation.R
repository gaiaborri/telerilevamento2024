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
