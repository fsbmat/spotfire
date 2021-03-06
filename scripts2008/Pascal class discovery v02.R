#------------------------------------------------------------------------------------------------------------------------#
#				MISE EN PLACE DE LA SESSION
#------------------------------------------------------------------------------------------------------------------------#

save.image("CHEMIN D'ACCES/ma session R.RData")


#------------------------------------------------------------------------------------------------------------------------#
#		RECUPERATION DES DONNEES - SELECTION DE GENES
#------------------------------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------#
#Importation des donn�es
#--------------------------------------------------------------------------------------#

poulet<-read.table("dataMAloessGENE.txt")
#On importe les donn�es normalis�es dans l'objet "poulet"

#-------------------------------#
#Une s�rie de v�rifications
#-------------------------------#

dim(poulet)
#[1] 20652    55

dimnames(poulet)[[2]]
dimnames(poulet)[[1]][1:20]
poulet[1:10,1:10]

class(poulet$Status)
#[1] "factor"

levels(poulet$Status)
#[1] "gene"


#-------------------------------#
#Cr�ation d'un objet ne contenant que les donn�es
#-------------------------------#

poulet2<-poulet[,7:55]
dimnames(poulet2)[[1]]<-dimnames(poulet)[[1]]

#-------------------------------#
#V�rifications
#-------------------------------#
dim(poulet2)
dimnames(poulet2)[[2]]


#-------------------------------#
#Cr�ation d'un facteur groupe
#-------------------------------#

grp<-as.factor(c(rep("N",9),rep("J16",7),rep("J16R5",8),rep("J16R16",9),rep("J48",7),rep("J48R24",9)))

#-------------------------------#
#Un premier aper�u des donn�es
#-------------------------------#

boxplot(as.list(poulet2),pars=list(las=2))
#boxplot de chaque puce

boxplot(t(poulet2)~grp)
#boxplots par groupe d'individus


#-------------------------------#
#S�lection de g�nes pr�sentant un effet groupe
#-------------------------------#

aov.grp<-list()
aov.grp<-apply(poulet2,1,function(x){aov(x~grp)})
#calculs un peu long...

pval.aov<-sapply(aov.grp,function(x){summary(x)[[1]][1,5]})
#On r�cup�re les p-values de l'anova

length(pval.aov[pval.aov<=0.05])
#[1] 14921
length(pval.aov[pval.aov<=0.1])
#[1] 16328
length(pval.aov[pval.aov<=0.01])
#[1] 11849
length(pval.aov[pval.aov<=0.001])
#[1] 8307

names(pval.aov)<-dimnames(poulet)[[1]]

library(multtest)
pval.aov.BH<-mt.rawp2adjp(pval.aov,proc="BH")
adjp.aov<-pval.aov.BH$adjp[order(pval.aov.BH$index),2]
names(adjp.aov)<-names(pval.aov)
#ajustement des p-values par la m�thode de Benjamini et Hochberg

length(adjp.aov[adjp.aov<=0.05])
#[1] 14193
length(adjp.aov[adjp.aov<=0.01])
#[1] 10793
length(adjp.aov[adjp.aov<=0.001])
#[1] 7048
length(adjp.aov[adjp.aov<=0.0001])
#[1] 4623
length(adjp.aov[adjp.aov<=0.00001])
#[1] 2943

plot(c(0,0.01),c(0,11000),type="n")
for (i in seq(0,0.01,by=0.0001))
{points(i, length(adjp.aov[adjp.aov<=i]))}
#Nombre de g�nes retenus en fonction du seuil de FDR fix�

X11()
plot(c(0,0.01),c(0,110),type="n")
for (i in seq(0,0.01,by=0.0001))
{points(i, length(adjp.aov[adjp.aov<=i])*i)}
#graphique du nombre de faux positifs en fonction du seuil

X11()
plot(c(0,11000),c(0,110),type="n")
for (i in seq(0,0.01,by=0.0001))
{points(length(adjp.aov[adjp.aov<=i]), length(adjp.aov[adjp.aov<=i])*i)}
#graphique du nombre de faux positifs en fonction du nombre de g�nes s�lectionn�s

#On va r�aliser une s�lection relativement drastique car de tr�s nombreux g�nes pr�sentent un effet groupe significatif

selgenes1<-names(adjp.aov)[adjp.aov<=0.00001]
length(selgenes1)
#[1] 2943
#OK, on a s�lectionn� 2943 g�nes

poulet3<-poulet2[selgenes1,]

#------------------------------------------------------------------------------------------------------------------------#
#				IMPORTATION DES DONNEES
#------------------------------------------------------------------------------------------------------------------------#

poulet3<-read.table(�poulet3.txt�,header=T,sep=�\t�)
annot.poulet3<- read.table(�annotpoulet3.txt�,header=T,sep=�\t�)
#importation du tableau de donn�es et de la table des annotations


#-------------------------------#
#Cr�ation d'un facteur groupe
#-------------------------------#

grp<-as.factor(c(rep("N",9),rep("J16",7),rep("J16R5",8),rep("J16R16",9),rep("J48",7),rep("J48R24",9)))


#------------------------------------------------------------------------------------------------------------------------#
#			CLASSIFICATION ASCENDANTE HIERARCHIQUE
#------------------------------------------------------------------------------------------------------------------------#
library(cluster)
#-----------------------------------------------------#
#CAH DES INDIVIDUS
#-----------------------------------------------------#

plclust(hclust(as.dist(1-cor(poulet3)),method="complete"),hang=-1,labels=grp)
X11()
plclust(hclust(as.dist(1-cor(poulet3)),method="ave"),hang=-1,labels=grp)
X11()
plclust(hclust(as.dist(1-cor(poulet3)),method="ward"),hang=-1,labels=grp)
#Observer les diff�rences entre les dendrogrammes issus de m�thodes d'agglom�ration diff�rentes

plclust(hclust(as.dist(1-cor(poulet3)),method="ward"),hang=-1,labels=grp)
X11()
plclust(hclust(as.dist(1-cor(poulet2)),method="ward"),hang=-1,labels=grp)
#Observer l'effet d'une s�lection de g�nes

plclust(hclust(as.dist(1-cor(poulet3)),method="ward"),hang=-1,labels=grp)
#On s�lectionne cette classification
X11()
plot(hclust(as.dist(1-cor(poulet3)),method="ward")$height[49:10],pch=18,col="blue")
#Choix d'un nombre de classes (ici, je dirais 6 ou 8 classes)


plclust(hclust(as.dist(1-cor(poulet3)),method="ward"),hang=-1,labels=grp)
X11()
plclust(hclust(dist(t(poulet3)),method="ward"),hang=-1,labels=grp)
#Observer les diff�rences entre les dendrogrammes obtenus avec deux distances diff�rentes

plclust(hclust(dist(t(poulet3)),method="ward"),hang=-1,labels=dimnames(poulet3)[[2]])
#on retrouve notre puce Np5...

plclust(hclust(as.dist(1-cor(poulet2)),method="ward"),hang=-1,labels=grp)
X11()
plclust(hclust(as.dist(1-cor(poulet2)^2),method="ward"),hang=-1,labels=grp)
#Idem : comparaison des distances bas�es sur la corr�lation ou la corr�lation au carr�
#La distance bas�e sur cor2 peut se r�v�ler utile dans les classifications de g�nes


#-----------------------------------------------------#
#DOUBLE CLASSIFICATION
#-----------------------------------------------------#

selgenes2<-names(adjp.aov)[adjp.aov<=0.000001]
length(selgenes2)
noms.selgenes2<-poulet[adjp.aov<=0.000001,"ID"]
poulet4<-poulet2[selgenes2,]
#Une s�lection de g�nes un peu plus drastique pour ne pas faire (trop) planter les ordinateurs...


library(geneplotter)
library(marray)

slf<-function(d) hclust(d,method="ward")
#d�finition de la fonction qui permet de r�aliser les classifications des g�nes et des individus

heatmap(as.matrix(poulet3),
col= maPalette(low="green",high="red",mid="black"),
hclustfun=slf,
labRow=annot.poulet3[,�Name�],
labCol=as.character(grp))
#ATTENTION : ne lancer la commande ci-dessus que si votre ordinateur tourne bien!!!
#Si cette fonction ne marche pas et vous revoie un message d'erreur en lien avec un probl�me de m�moire, essayez de ferner votre session R et de la relancer. Rechargez les packages cluster, geneplotter et marray puis relancez la fonction ci-dessus.
#Vous pouvez aussi essayer de baisser le seuil de s�lection utilis� dans poulet4 pour avoir moins de g�nes
#Cette classification est bas�e sur distance=distance euclidienne classique et crit�re d'agglom�ration=Ward

#Il serait sans doute plus judicieux de travailler sur une distance bas�e sur la corr�lation (en particulier pour les variables)

distcor<-function(x){as.dist(1-cor(t(x)))}
#La distance bas�e sur la corr�lation
heatmap(as.matrix(poulet3),
col= maPalette(low="green",high="red",mid="black"),
distfun=distcor,
hclustfun=slf,
labRow=annot.poulet3[,�Name�],
labCol=as.character(grp))
#La double classification bas�e sur distance=1-cor et crit�re d'agglom�ration=Ward

#On va travailler avec cette double classification
#Le principal probl�me auquel nous sommes confront�s est le manque d'interactivit� avec ce graphique. On aimerait pouvoir zoomer et se balader dans cette heatmap pour aller voir de quels g�nes sont constitu�s les groupes, etc...
#Les commandes qui vont suivre ont pour but d'obtenir � la fois des listes de g�nes et �galement des graphiques repr�sentant des sous-parties de cette heatmap correspondant � des groupes de g�nes "homog�nes"

hv<-heatmap(as.matrix(poulet3),
col= maPalette(low="green",high="red",mid="black"),
distfun=distcor,
hclustfun=slf,
labRow=annot.poulet3[,�Name�],
labCol=as.character(grp),
keep.dendro=TRUE)
#On commence par r�cup�rer les dendrogrammes

names(hv)
#[1] "rowInd" "colInd" "Rowv"   "Colv"
#rowInd et colInd sont deux vecteurs contenant les permutations d'index pour les lignes et les colonnes respectivement (tels que retrourn�s par la fonction order.dendrogram, voir l'aide correspondante)
#Rowv et Colv sont les deux denrogrammes des lignes (g�nes) et des colonnes (individus) respectivement. Il s'agit d'objet de classe "dendrogram"

plot(hv$Colv)
plot(hv$Rowv)
#Chaque dendrogramme s�par�ment

dimnames(poulet3)[[2]][hv$colInd[1]]
dimnames(poulet3)[[2]][hv$colInd[2]]
#Les vecteurs rowInd et colInd peuvent �tre utilis� pour retrouver dans la table de donn�es de d�part (poulet3) une donn�e identifi�e sur le dendrogramme. rowInd (resp colInd) donne les num�ros de ligne (resp. des colonnes) des g�nes (resp. des individus) dans la table de d�part (poulet 3) dans l'ordre d'apparition des feuilles des dendrogrammes (de gauche � droite).

plot(hv$Rowv)
X11()
plclust(hclust(as.dist(1-cor(t(poulet3))),method="ward"),hang=-1,labels=dimnames(poulet3)[[1]])
#Cet arbre est le m�me que plot(hv$Rowv), � quelques rotations de branches pr�s

hc<-hclust(as.dist(1-cor(t(poulet3))),method="ward")
#On r�cup�re ce dendrogramme

plot(hc$height[1144:1125],pch=18,col="blue")
#Ce graphique qui nous sugg�re que 4 groupes de g�nes pourraient constituer un premier d�coupage int�ressant. Pour obtenir un d�coupage plus fin (et donc des groupes plus petits en effectif), on va consid�rer 7 groupes (attention, ce n�est bien s�r pas forc�ment un choix optimal, 7, 8 et 12 groupes semblent d�apr�s le graphique ci-dessus des choix acceptables)


plclust(hc,hang=-1,labels=dimnames(poulet3)[[1]])
X11()
plot(hc$height[1144:1125],pch=18,col="blue")
abline(h=18)
# En coupant l'arbre � une hauteur de 18, on obtient bien 7 groupes

cuthv7<-cut(hv$Rowv,h=18)

names(cuthv7)
#[1] "upper" "lower"
#upper est une version tronqu�e de l'arbre de d�part
#lower est une liste contenant les 7 sous-dendrogrammes g�n�r�s par la coupure

plot(cuthv7$lower[[1]])
#le dendrogramme correspondant au premier sous-groupe de g�nes auxquels nous allons nous int�resser

labels(cuthv7$lower[[1]])
#les noms des g�nes appartenant � ce premier sous-groupe

heatmap(as.matrix(poulet3[labels(cuthv7$lower[[1]]),]),
Rowv=str(cuthv7$lower[[1]]),
Colv=hv$Colv,
col= maPalette(low="green",high="red",mid="black"),
distfun=distcor,
hclustfun=slf,
labCol=as.character(grp))
#La sous partie du dendrogramme initial contenant les g�nes du sous-groupe 1
#...on aurait envie �ventuellement de descendre plus bas dans le d�coupage des sous-groupes
#A-t-on "le droit" de le faire directement sur ce morceau de l'arbre initial?


heatmap(as.matrix(poulet3[labels(cuthv7$lower[[2]]),]),
Rowv=str(cuthv7$lower[[2]]),
Colv=hv$Colv,
col= maPalette(low="green",high="red",mid="black"),
distfun=distcor,
hclustfun=slf,
labCol=as.character(grp))
#sous-groupe n�2


heatmap(as.matrix(poulet3[labels(cuthv7$lower[[3]]),]),
Rowv=str(cuthv7$lower[[3]]),
Colv=hv$Colv,
col= maPalette(low="green",high="red",mid="black"),
distfun=distcor,
hclustfun=slf,
labCol=as.character(grp))
#sous-groupe n�3


heatmap(as.matrix(poulet3[labels(cuthv7$lower[[4]]),]),
Rowv=str(cuthv7$lower[[4]]),
Colv=hv$Colv,
col= maPalette(low="green",high="red",mid="black"),
distfun=distcor,
hclustfun=slf,
labCol=as.character(grp))
#sous-groupe n�4


heatmap(as.matrix(poulet3[labels(cuthv7$lower[[5]]),]),
Rowv=str(cuthv7$lower[[5]]),
Colv=hv$Colv,
col= maPalette(low="green",high="red",mid="black"),
distfun=distcor,
hclustfun=slf,
labCol=as.character(grp))
#sous-groupe n�5


heatmap(as.matrix(poulet3[labels(cuthv7$lower[[6]]),]),
Rowv=str(cuthv7$lower[[6]]),
Colv=hv$Colv,
col= maPalette(low="green",high="red",mid="black"),
distfun=distcor,
hclustfun=slf,
labCol=as.character(grp))
#sous-groupe n�6


heatmap(as.matrix(poulet3[labels(cuthv7$lower[[7]]),]),
Rowv=str(cuthv7$lower[[7]]),
Colv=hv$Colv,
col= maPalette(low="green",high="red",mid="black"),
distfun=distcor,
hclustfun=slf,
labCol=as.character(grp))
#sous-groupe n�7

#Il ne reste plus qu'� voir de quels g�nes il s'agit...


sapply(cuthv7$lower,attributes)
#Pour voir quels sont les effectifs de chaque sous-groupe de g�nes
#On va s'int�resser au groupe n�4 qui pr�sente un effectif raisonnable (61 g�nes)

annot.poulet3[labels(cuthv7$lower[[4]]),"Name"]
#Les noms des 61 g�nes du groupe 4


#-----------------------------------------------------#
#IMPORTATION DES ANNOTATIONS DES GENES
#-----------------------------------------------------#

annot=read.table("annotation_oligo_29012007.txt",sep="\t",header=T)

dim(annot)
#[1] 16383    10
#v�rification OK
#Ce fichier n'a pas le m�me nombre de ligne que le fichier poulet car certains g�nes sont pr�sents en plusieurs exemplaires sur la puce. De plus, certains g�nes du fichier poulet n'ont aucune annotation leur correspondant dans le fichier annot

numlignes<-match(poulet$ID,annot$ID)
#numlignes est un vecteur contenant autant d'�l�ment que poulet contient de lignes

length(numlignes)
dim(poulet)[1]
#v�rification ok

#pour chaque ligne poulet[i,], numlignes contient la valeur numligne[i]=j o� j est le num�ro de la ligne annot[j,] telle que poulet[i,"ID"]=annot[j,"ID]
#numlignes contient la valeur NA si l'ID contenue dans poulet n'a pas d'�quivalent dans les ID de annot

poulet.annot<-cbind.data.frame(poulet,annot[numlignes,])
#On cr�� une nouvelle table qui contient les donn�es + les annotations

poulet.annot[1:10,c(1:6,56:65)]
#Voyons les infos que contient cette table


identical(as.character(poulet.annot[,4][!is.na(poulet.annot[,57])]),as.character(poulet.annot[,57][!is.na(poulet.annot[,57])]))
#v�rification que les 2 colonnes ID sont bien les m�mes

poulet.annot<-poulet.annot[,-57]
#On enl�ve la colonne ID issue de annot pour �viter les confusions

#r�cup�ration des infos sur les g�nes du sous-groupe n�4

poulet.annot[labels(cuthv7$lower[[4]]),c("Name","NomGallus")]

poulet.annot[labels(cuthv7$lower[[4]]),c("OrthoHomo","OrthoMus")]

poulet.annot[labels(cuthv7$lower[[4]]),"GObiolproc1"]

poulet.annot[labels(cuthv7$lower[[4]]),"GObiolproc2"]

poulet.annot[labels(cuthv7$lower[[4]]),"GOmolfunct1"]

poulet.annot[labels(cuthv7$lower[[4]]),"GOcellcomp1"]

#Exportation des infos les plus pertinentes (selon moi...)
write.table(poulet.annot[labels(cuthv7$lower[[4]]),c("Name","NomGallus","OrthoHomo","OrthoMus","GObiolproc1","GObiolproc2","GOmolfunct1")],file="grp4.txt")



#------------------------------------------------------------------------------------------------------------------------#
#				PAM : Partitioning around Medoids
#------------------------------------------------------------------------------------------------------------------------#

#En classification ascendante hi�rarchique, on a choisi 7 clusters de g�nes. On va voir ce que PAM peut �ventuellement nous apporter concernant ce choix.

plot(hc$height[1144:1125],pch=18,col="blue")
#d'apr�s ce graphique, on pourrait aussi choisir 11 ou 12 groupes (ou clusters)

#-----------------------------------------------------#
#REALISATION DE PAM AVEC 7 OU 14 CLUSTERS
#-----------------------------------------------------#
library(cluster)
pamG7<-pam(as.dist(1-cor(t(poulet3))),k=7)
pamG12<-pam(as.dist(1-cor(t(poulet3))),k=12)

#-----------------------------------------------------#
#SILHOUETTE PLOTS
#-----------------------------------------------------#
plot(pamG7,which.plots=2,nmax.lab=61)
X11()
plot(pamG12,which.plots=2,nmax.lab=61)
#A priori, on pr�f�rerait 7 groupes ici car la silhouette moyenne est plus forte
#On trouve n�anmoins quelques sous-groupes dont la silhouette est bonne en d�coupant en 12 clusters ( par exemple les clusters 1 et 11)

#-----------------------------------------------------#
#CHOIX DU NOMBRE DE CLUSTER AVEC PAM
#-----------------------------------------------------#
pamlist<-list()
for (i in 2:11)  {pamlist[[i]]<-pam(as.dist(1-cor(t(poulet3))),k=i)}
#On r�alise PAM avec k=2,3,�,14
#ATTENTION : CALCUL LONG... � lancer avant une pause� et uniquement si votre PC n�a pas plant� jusque l�!!

unlist(sapply(pamlist,function(x)x$silinfo$avg.width))
#On r�cup�re les largeurs de silhouette moyennes

plot(2:11,unlist(sapply(pamlist,function(x)x$silinfo$avg.width)),pch=18,col="blue")
#On les repr�sente graphiquement
#Le choix de 7 clusters semble relativement raisonnable mais 8 clusters semblent plus adapt�s d�apr�s PAM (on gagne en pr�cision sans trop perdre en silhouette moyenne, i.e. dans la qualit� des clusters)


#-----------------------------------------------------#
#REPRESENTATION DES CLUSTERS DANS LES COORDONNEES DU MDS
#-----------------------------------------------------#
#Ces fonctions utilisent trop de RAM et ne fonctionnent pas avec des classifications PAM r�alis�es sur trop de g�nes (il est d'ailleurs probable que les MDS soient peu lisibles avec plusieurs centaines de g�nes comme nous le verrons au chapitre sur le MDS). On va donc regarder les fonctions suivantes en faisant plut�t des classifications des individus. Dans le chapitre sur le MDS, nous verrons comment repr�senter les classes de g�nes dans les coordonn�es du MDS en utilisant moins de m�moire.

pamP6<-pam(as.dist(1-cor(poulet3)),k=6)
#il semble assez logique ici de prendre 6 groupes...

plot(pamP6,which.plots=1,labels=4)
#Une premi�re repr�sentation dans les coordonn�es du MDS

plot(pamP6,which.plots=1,nmax.lab=50,color=TRUE,labels=5)
#Cliquez sur les points que vous souhaitez identifier puis taper sur "Echap" pour reprendre la main dans la ligne de commande
#On peut jouer sur l'argument labels pour ces repr�sentations (voir ci-dessous)
#labels= 0, no labels are placed in the plot;
#labels= 1, points and ellipses can be identified in the plot (see 'identify');
#labels= 2, all points and ellipses are labelled in the plot;
#labels= 3, only the points are labelled in the plot;
#labels= 4, only the ellipses are labelled in the plot.
#labels= 5, the ellipses are labelled in the plot, and points can be identified.



#------------------------------------------------------------------------------------------------------------------------#
#				MULTIDIMENSIONAL SCALING
#------------------------------------------------------------------------------------------------------------------------#


#-----------------------------------------------------#
#DIFFERENTS CALCULS DE DISTANCE
#-----------------------------------------------------#
rS=cor(t(poulet3))
dS=1-rS
dS2=sqrt(1-rS^2)
dN=dimnames(poulet3)[[1]]
dE=dist(poulet3)

#-----------------------------------------------------#
#REALISATION DES MDS
#-----------------------------------------------------#
mdsE<-cmdscale(dE,k=2,eig=TRUE)
mdsS<-cmdscale(dS,k=2,eig=TRUE)
mdsS2<-cmdscale(dS2,k=2,eig=TRUE)

#-----------------------------------------------------#
#COMPARAISON DES GRAPHES OBTENUS
#-----------------------------------------------------#
plot(mdsE$points,type="n",xlab="cp1",ylab="cp2",main="MDS pour donn�es poulet4, distance euclidienne")
text(mdsE$points[,1],mdsE$points[,2],dN,cex=0.4)
X11()
plot(mdsS$points,type="n",xlab="cp1",ylab="cp2",main="MDS pour donn�es poulet4, distance correlation")
text(mdsS$points[,1],mdsS$points[,2],dN,cex=0.4)
X11()
plot(mdsS2$points,type="n",xlab="cp1",ylab="cp2",main="MDS pour donn�es poulet4, distance correlation carree")
text(mdsS2$points[,1],mdsS2$points[,2],dN,cex=0.4)
#Ces graphiques ne sont pas �vidents � interpr�ter vu le nombre de g�ne...
#On va voir si on y voit plus clair en rajoutant des couleurs en lien avec une classification hi�rarchique

#-----------------------------------------------------#
#CHOIX DU NOMBRE DE DIMENSIONS EN MDS
#-----------------------------------------------------#
mdsScree<-cmdscale(dS,k=8,eig=T)
plot(mdsScree$eig,pch=18,col="blue")

#-----------------------------------------------------#
#REPRESENTATION DES CLASSES D'UNE CAH OU D'UNE PAM PAR MDS
#-----------------------------------------------------#

#Dans l'objet hc, on dispose d'une CAH des g�nes avec distance=1-cor et crit�re d'agglom�ration=Ward

col<-cutree(hc,k=7)
#On coupe l'arbre en 7 classes

plot(mdsS$points,type="n",xlab="cp1",ylab="cp2",main="MDS pour donn�es poulet4, distance correlation")
text(mdsS$points[,1],mdsS$points[,2],dN,col=col,cex=0.4)
#Repr�sentation des classes de la CAH dans les coordonn�es du MDS

#Il est possible de faire la m�me chose avec la fonction clusplot du package "cluster".
#Cette fonction donne acc�s � de nombreuses options
#Elle s�lectionne automatiquement les coordonn�es � utiliser (MDS pour une matrice de distances et ACP pour une matrice de coordonn�es)
#En revanche, elle est beaucoup plus gourmande et fera planter votre ordinateur avec des donn�es de cette taille...

col<-pamG7$clustering
#On r�cup�re dans l'objet col les num�ros des classes auxquel chaque g�ne appartient

X11()
plot(mdsS$points,type="n",xlab="cp1",ylab="cp2",main="MDS pour donn�es poulet4, distance correlation")
text(mdsS$points[,1],mdsS$points[,2],dN,col=col,cex=0.4)
#Repr�sentation des classes de PAM (avec 7 groupes) dans les coordonn�es du MDS
#Les 7 groupes d�finis par PAM ne sont pas les m�mes que les 7 groupes d�finis par CAH.

table(cutree(hc,k=7),pamG7$clustering)
#Pour voir combien de g�nes ont chang�s de classe


#-----------------------------------------------------#
#COMBINAISON DES METHODES
#-----------------------------------------------------#


#--------------------------#
#CAH DES GENES
#--------------------------#

#L'objet hc contient une CAH des 1145 g�nes s�lectionn�s

#--------------------------#
#CHOIX DU NOMBRE DE CLASSES
#--------------------------#

plot(hc$height[1144:1125],pch=18,col="blue")
#Sur la base de ce graphique...

mk7<-cutree(hc,k=7)
#...On coupe l'arbre en 7 classes

#--------------------------#
#CALCUL DES BARYCENTRES DES 7 GROUPES
#--------------------------#

bary<-apply(poulet3,2,function(x){tapply(x,mk7,mean)})

#--------------------------#
#REALLOCATION PAR KMEANS
#--------------------------#

kmG7<-kmeans(poulet3,centers=bary)
#On initialise les k-means avec les barycentres des 7 classes de la CAH

table(mk7,kmG7$cluster)
#On regarde ce qui a chang� apr�s avoir appliqu� les k-means

#--------------------------#
#OBSERVATION DES MODIFICATIONS PAR MDS
#--------------------------#
plot(mdsS$points,type="n",xlab="cp1",ylab="cp2",main="MDS, distance correlation, avant kmeans")
text(mdsS$points[,1],mdsS$points[,2],dN,col=as.double(mk7))

X11()
plot(mdsS$points,type="n",xlab="cp1",ylab="cp2",main="MDS, distance correlation, apr�s kmeans")
text(mdsS$points[,1],mdsS$points[,2],dN,col=as.double(kmG7$cluster))
#On voit assez nettement sur ces repr�sentations que les g�nes qui ont �t� affect�s par les changements de classes sont principalement ceux qui se trouvaient "en bordure" d'une classe.


#------------------------------------------------------------------------------------------------------------------------#
#			ANALYSE EN COMPOSANTES PRINCIPALES
#------------------------------------------------------------------------------------------------------------------------#
#Deux fonctions (princomp et prcomp) calulent l'ACP classique dans R. Seule prcomp accepte un nombre de variables (colonnes) sup�rieur au nombre d'individus (lignes). Attention, les objets (r�sultats) cr��s par ces 2 fonctions n'ont pas tout � fait la m�me structure (voir les aides des 2 fonctions)
#la librairie amap permet �galement de faire de l'ACP (et d'autres m�thodes multidimensionnelles). Elle correspond � la librairie multidim de S+ (http://www.lsp.ups-tlse.fr/)
#Dans le cadre de ces travaux pratiques, nous utiliserons aussi le package FactoMineR qui contient de nombreuses fonctions faciles d'utilisation pour les repr�sentations d'ACP.


#-----------------------------------------------------#
#FONCTION PRINCOMP
#-----------------------------------------------------#

ACP1<-princomp(poulet3,cor=TRUE)
#r�alisation de l'ACP avec les g�nes en individus et les �chantillons en variables
#les individus sont centr�s
#Quelle est l'hypoth�se biologique sous-entendue dans le centrage des individus?

plot(ACP1)
#eboulis des valeurs propres

biplot(ACP1)
#Que pensez-vous de la premi�re dimension?

plot(ACP1$scores[,1],apply(poulet3,1,mean))
#Comment interpr�tez-vous ce graphique?

ACP1<-princomp(t(scale(t(poulet3),scale=F)))
#ACP avec double centrage en ligne et en colonne
#Que pensez-vous du centrage des g�nes

plot(ACP1)
#eboulis des valeurs propres

biplot(ACP1)
#nouveau biplot


#-----------------------------------------------------#
#FONCTION PRCOMP
#-----------------------------------------------------#

ACP2<-prcomp(t(poulet3),scale=F)
#ACP avec les individus en ligne et les g�nes en colonnes

plot(ACP2)
#eboulis

boxplot(data.frame(ACP2$x),las=2,cex.axis=0.7)
#Un autre moyen de s�lectionner le nombre de composantes prioncipales
X11()
biplot(ACP2$x,ACP2$rotation,xlabs=as.character(grp))
#On commence � voir des choses

ACP3<-prcomp(t(poulet3),scale=T)
#avec r�duction des g�nes
#Que pensez-vous de la r�duction des g�nes, est-ce judicieux ?

plot(ACP3)
#eboulis

biplot(ACP3$x,ACP3$rotation,xlabs=as.character(grp))
#deux premiers axes factoriels

plot(ACP3$x[,1],ACP3$x[,2],type="n",xlab="PC1",ylab="PC2")
text(ACP3$x[,1],ACP3$x[,2],as.character(grp))
#Un graphique des individus plus facile � lire

plot(ACP3$x[,2],ACP3$x[,3],type="n",xlab="PC2",ylab="PC3")
text(ACP3$x[,2],ACP3$x[,3],as.character(grp))
#Comment interpr�tez-vous les axes de l'ACP?

#*********************************************************************************************************************
#	FONCTION CERCLE -> Permet de tracer un cercle et notamment le cercle des corr�lations
#*********************************************************************************************************************
###############################################################################
# Cr�ation d'une fonction 'cercle' qui prend en param�tre la taille du rayon
# que l'on souhaite et qui permet de tracer le cercle correspondant � ce rayon.
# Cette fonction est utile pour tracer le cercle des corr�lations de rayon 1.
###############################################################################

cercle <- function (rad = 1)

	###########################################################################
	# rad	-> taille du rayon que l'on souhaite
	# 
	# Cette fonction premet de tracer un cercle dont le rayon est de longueur
	# 'rad'. Par d�faut, rad=1, ce qui correspond au cercle des corr�lations.
	###########################################################################
{
	teta <- (1:101 * 2 * pi)/100
	x <- rad * sin(teta)
	y <- rad * cos(teta)
	lines(x, y)
}


vec<-ACP3$rotation %*% diag(ACP3$sdev)
#Les coordon�es des g�nes


plot(vec[,1],vec[,2],type="n", xlim=c(-1,1),ylim=c(-1,1),main="Genes")
cercle(1)
arrows(rep(0,dim(poulet3)[1]),rep(0,dim(poulet3)[1]),vec[,1],vec[,2],lwd=0.2)
text(vec[,1],vec[,2],dimnames(poulet3)[[1]],cex=0.5)
#Repr�sentation des g�nes (et du cercle des corr�lations) - Plan 1-2
#C'est plus lisible lorsqu'on ne met pas les fl�ches mais �a reste difficile � lire quand m�me...


plot(vec[,2],vec[,3],type="n", xlim=c(-1,1),ylim=c(-1,1),xlab="PC2",ylab="PC3",main="Genes")
cercle(1)
arrows(rep(0,dim(poulet3)[1]),rep(0,dim(poulet3)[1]),vec[,2],vec[,3],lwd=0.2)
text(vec[,2],vec[,3],dimnames(poulet3)[[1]],cex=0.5)
#G�nes dans le plan 2-3
#M�me remarque, ce n'est pas tr�s lisible...
#-----------------------------------------------------#
#COMPARAISON MDS-ACP
#-----------------------------------------------------#

col=cutree(hc,k=7)
plot(vec[,1],vec[,2],type="n", xlim=c(-1,1),ylim=c(-1,1),main="Genes")
cercle(1)
text(vec[,1],vec[,2],dimnames(poulet3)[[1]],cex=0.5,col=col)
#Ca vous rappelle quelque chose?

X11()
plot(mdsS$points,type="n",xlab="cp1",ylab="cp2",main="MDS pour donn�es poulet4, distance correlation")
text(mdsS$points[,1],mdsS$points[,2],dN,col=col,cex=0.4)
#On obtient des r�sultats tr�s voisins avec le MDS

plot(vec[,1],-mdsS$points[,1])
#La preuve...

#En fait, le MDS avec une distance euclidienne est �quivalent � l'ACP sur le tableau de donn�es avec les g�nes en ligne.


#-----------------------------------------------------#
#ACP AVEC LE PACKAGE FactoMineR
#-----------------------------------------------------#

library(FactoMineR)

resACP<-PCA(t(poulet3),graph=F)
#R�alisation de l'ACP
#avec l'argument scale.unit=F, on r�alise l'ACP sans la r�duction des variables

barplot(resACP$eig$iner,xlab="Composante",ylab="variance expliqu�e")
#eboulis de la variance expliqu�e

barplot(resACP$eig$eig,xlab="Composante",ylab="valeur propre")
#�boulis des valeurs propres (idem ci-dessus au changement d'�chelle pr�s)

plot(resACP,choix="ind",col.ind=as.integer(grp))
#graphique des individus (les couleurs correspondent aux diff�rents groupes

plot(resACP$ind$coord[,1],resACP$ind$coord[,2],type="n",
	xlab=paste("Composante 1", paste("(",round(resACP$eig$iner[1],1),"%)",sep=""),sep=" "),
	ylab=paste("Composante 2", paste("(",round(resACP$eig$iner[2],1),"%)",sep=""),sep=" "))
text(resACP$ind$coord[,1],resACP$ind$coord[,2],as.character(grp),col=as.numeric(grp))
#Une autre mani�re de faire le graphique...plus manuel...


plot(resACP,choix="var")
#graphique des variables

plot(resACP,choix="var",lim.cos2.var=0.7,cex=0.6)
#repr�sentation des variables avec une limite sur le cos2.

#--------------------------#
#Essais d'am�liorations pour la lecture des variables
#--------------------------#

#Le graphique des variables �tant difficilement lisible, on va essayer deux choses pour l'am�liorer.
#1) on va utiliser des couleurs sur les variables pour repr�senter les groupes de la CAH

plot(resACP,choix="var",col.var=mk7)
plot(resACP,choix="var",lim.cos2.var=0.7,cex=0.6,col.var=mk7)
#Essayez de faire le lien entre ces graphiques + le graphique des individus et la double classification

#2) on va repr�senter en variables suppl�mentaires les barycentres de ces groupes de variables obtenus par CAH

sapply(cuthv7$lower,function(x){attributes(x)$members})
# [1] 182 133  56  61 116 461 136
#Les effectifs des sous-groupes d�finis par CAH et repr�sent�s en double classif

tapply(mk7,as.factor(mk7),length)
#1   2   3   4   5   6   7 
# 56 133 182 461  61 116 136 
#Les effectifs des sous-groupes d�finis par CAH et cod�s dans l'objet mk7

#Ces deux vecteurs nous permettent de faire le lien entre les sous-groupes repr�sent�s par double classification et ceux d�finis dans mk7 (qui sont plus pratiques � utiliser pour certaines fonctions)
#
N�de groupe dans mk7	Num�ro de groupe dans cuthv7	
1	3	
2	2	
3	1	
4	6	
5	4	
6	5	
7	7	
#On va donc cr�er un nouveau vecteur de la m�me forme que mk7 mais qui reprend les num�ros de groupe de cuthv7

mk7b=mk7
mk7b[mk7==1]=3
mk7b[mk7==3]=1
mk7b[mk7==4]=6
mk7b[mk7==5]=4
mk7b[mk7==6]=5
#cr�ation de mk7b qui est un recodage de mk7 (attention � ne pas remplacer mk7 par mk7b dans ces lignes de codes...)

sapply(cuthv7$lower,function(x){attributes(x)$members})
tapply(mk7b,as.factor(mk7b),length)
#v�rification OK

baryb<-apply(poulet3,2,function(x){tapply(x,mk7b,mean)})
#calcul des barycentres des 7 sous-groupes

dimnames(baryb)[[1]]<-paste("grp",1:7,sep="")
#On donne des noms explicites � ces sous-groupes et surtout des noms qui ne sont pas trouv�s dans la table poulet4

baryb[,1:5]
rbind(poulet3,baryb)[1146:1152,1:5]
#v�rification des index (lignes) o� vont se trouver les barycentres

resACP2<-PCA(t(rbind(poulet3,baryb)),quanti.sup=1146:1152,graph=F)
#ACP avec des variables quantitatives suppl�mentaires

plot(resACP2,choix="var",lim.cos2.var=0.7,cex=0.7,col.quanti.sup=1:7)
#graphique des variables avec des couleurs pour les barycentres

plot(resACP2,choix="var",lim.cos2.var=0.7,cex=0.7,col.quanti.sup=1:7,col.var=mk7b)
#graphique des variables avec des couleurs pour les barycentres et pour les variables

plot(resACP2,axes=c(2,3),choix="var",lim.cos2.var=0.6,cex=0.6,col.quanti.sup=1:7,col.var=mk7b)
#axes 2-3

plot(resACP2,axes=c(2,3),choix="ind",col.ind=as.integer(grp))
#comment interpr�tez-vous ce plan factoriel 2-3?


#--------------------------#
#Indices de qualit�
#--------------------------#

print(resACP2)
#nous donne la liste des sous-objets contenus dans l'objet resACP2. En particulier o� trouver les contributions des individus et des variables ainsi que les cos2


