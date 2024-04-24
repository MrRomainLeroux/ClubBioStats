###################################################################################

# Séance 3 : ggplots2
# Date 28/03/2024

# éléments g?om?triques: histogramme, scatterplot, curve plot, density plot
# propri?t?s visuelles: axes, couleurs, tailles, texte
# + par cat?gories, secondary axis, sauvegarder plot

###################################################################################

## ggplot2 = une bibliothèque de visualisation de données en R

# la "grammaire des graphiques", une approche conceptuelle de la création de graphiques.
# Cette grammaire se compose de différents éléments =

# Données & Esthétiques & Géométries & Facettes & Statistiques



# ---> Données (Data) :
#  Les données à visualiser sont organisées sous forme de data frame, où chaque colonne représente
#une variable et chaque ligne une observation.

# ---> Esthétiques (Aesthetics) :
#  Les esthétiques définissent comment les variables sont représentées graphiquement,
#comme les axes x et y, la couleur ou la taille des points.

# ---> Géométries (Geometries) : Les géométries (geoms) déterminent le type de graphique à créer,
#tels que points, lignes, barres, histogrammes, etc. Chaque type de graphique correspond à une fonction spécifique dans ggplot2 (par exemple, geom_point(), geom_line(), geom_bar()).

# ---> Facettes (Facets) : Les facettes permettent de diviser les données en sous-groupes
#et de créer des graphiques distincts pour chaque sous-groupe. Par exemple, vous pouvez diviser les données en fonction d'une variable catégorielle et créer des panneaux (ou des facettes) pour chaque niveau de cette variable.

# --->  Statistiques (Statistics) : Les statistiques permettent d'appliquer des transformations
# statistiques sur les données avant de les représenter graphiquement. Par exemple, vous pouvez ajouter une courbe de régression à un nuage de points en utilisant la fonction stat_smooth().

###################################################################################

library(ggplot2)

## INTRODUCTION

setwd('D:/RECHERCHES/Club_BioStats_2024/Séance3/')

data = data.frame(

  category = factor( rep( c("F","M"), 200 ) ),

  weight = round( c( rnorm(200, mean=50, sd=5),
                     rnorm(200, mean=60, sd=5) ) ) )

## ggplot2

# barplot by categories


plotCategories = ggplot( data, aes( x = weight ) ) +

  geom_histogram( bins = 20 ) +

  coord_cartesian(xlim=c(25,80), ylim=c(0,50)) +

  scale_x_continuous( expand = c( 0, 0 ) ) +

  scale_y_continuous( limits = c(0,50) )

print( plotCategories )

# save
ggsave( "dataCategories.png",
        plot = plotCategories,
        width = 10, height = 8,
        dpi = 200, units="in")

dev.off()

saveRDS( plotCategories, file = "plotCategoriesObject.RDS")

plotSaved = readRDS( "C:/Users/ADMIN Romain LEROUX/Documents/Club_BioStats_2024/Séance3/plotCategoriesObject.RDS")



# customize

plotCategories = ggplot( data, aes( x = weight ) ) +

  geom_histogram( bins = 20,

                  binwidth = 1,

                  color="red",

                  fill="blue",

                  alpha = 0.1 ) +

  xlab("Weight (kg)") +

  ylab("Count") +

  ggtitle( "un graph") +

  scale_y_continuous( expand = c(0,0),
                      limits = c(0,50) )

print( plotCategories )










# plusieurs histogrammes

moyenne = data.frame( category = c("F","M"), mean = c(50,60))

plotHist = ggplot( data, aes( x = weight, color = category ) ) +

  geom_histogram( bins = 30,
                  fill="white", alpha=0.5,
                  position="identity" ) +

  geom_vline( data = moyenne, aes( xintercept = mean ) ) +

  scale_y_continuous( expand = c(0,0),
                      limits = c(0,20) )

print(plotHist)



# plusieurs histogrammes par cat?gories
# facet_grid
# facet_wrap

plotHist = ggplot( data, aes( x = weight, color = category ) ) +

  geom_histogram( bins = 30, fill="white", alpha=0.5) +

  facet_wrap( category~. ) +

  theme_bw(16)+

  theme(legend.position = "bottom",

        strip.background = element_rect(fill = "red"))


print(plotHist)

########################################################################################

## JEUX DE DONNEES

## data : ToothGrowth_Guinea

pathData = 'D:/RECHERCHES/Club_BioStats_2023/Séance3/'

ToothGrowth = read.csv( paste0( pathData, "ToothGrowth_Guinea.csv"), sep=",", dec=",")


ToothGrowth = ToothGrowth_Guinea



plot = ggplot( data = ToothGrowth ) +
  geom_bar( aes( x = City ) )
print(plot)

# split: city et dose

plot = ggplot( data = ToothGrowth ) +

  geom_bar( aes( x = City, fill = as.factor( dose ) ) ) +

  xlab("Dose (unite/jour)") +

  scale_fill_discrete( name = "Dose (unite/jour)") +

  theme_bw(16) +

  theme(legend.position="bottom")


# split: city et dose et supp

plot = plot +

  facet_wrap(.~supp)

print( plot )



# boxplot

plot = ggplot( data = ToothGrowth ) +

  geom_boxplot( aes( x = City, y = len, fill = as.factor( dose ) ) ) +

  geom_point( aes(x = City, y = len ), col = "red", shape = 8, alpha = 1.0,  ) +

  scale_fill_manual( values = c( "#E69F00" , "#56B4E9", "#009E73" ) ) +

  labs( fill = "Dose" )

print( plot )










## data : ToothGrowth_Guinea2

ToothGrowth2 = read.csv( "C:/Users/ADMIN Romain LEROUX/Documents/Club_BioStats_2024/Séance3/ToothGrowth_Guinea_2.csv", sep=";", dec=",")

head(ToothGrowth2)

ToothGrowth2 = ToothGrowth_Guinea_2

# ? # question : afficher uniquement la bar d'erreur sup?rieure

plot = ggplot( data = ToothGrowth2, aes( x = as.factor(dose) ,
                                         y = len,
                                         fill = supp )) +

  geom_bar( position = position_dodge(), stat = "identity") +

  geom_errorbar( aes( ymin = len-se, ymax = len+se, group = supp),

                 position = position_dodge(0.9)) +

  xlab("Dose (unite/temps)") +
  ylab("Length (unite) ") +

  ggtitle("Titre du graphe \n\n la suite du titre \n etc.") +

  scale_fill_discrete(name="supplement",
                      labels = c("orange juice","acid"))+


  scale_y_continuous( expand = c(0,0),
                      limits = c(0,30) ) +

  theme_bw(11) +

  theme(legend.position="bottom")


print( plot)

########################################################################################

## PLOT CURVE + two axes y
## model PKPD
## aim: plot PK and PD same graph

library(mrgsolve)
library(dplyr)

mod <- mread("irm1", modlib())
dosing <- ev(amt = 25, time = 0, ii = 24, addl = 6)
res <- mod %>%
  data_set(dosing) %>%
  param(CL = 0.5, KOUT = 0.25) %>%
  obsonly() %>%
  mrgsim(end = 336) %>%
  select(time, CP, RESP)


#exemple pk

plot_pk = ggplot( res, aes( x=time, y=CP) )+

  geom_line()+

  scale_x_continuous( breaks = seq( 0, 336, 24) ) +

  labs( x = "Time (unity)", y = "Concentration (unity)")

print( plot_pk )


# exemple pkpd

plot_pkpd = ggplot( res, aes( x=time, y=CP) ) +

  geom_line( aes( color = "Drug concentration") ) +

  geom_line( aes( y = RESP/10, color = "Biomarker (unity)" ) ) +

  scale_x_continuous( breaks = seq( 0, 336, 24) ) +



  scale_y_continuous(  expand = c(0,0),

                       breaks = seq( 0, 3, 0.5),

                       sec.axis = sec_axis( ~.*1,
                                            breaks = seq(0,3,0.1),

                                            name = "Biomarker (unity/10)"))+

  labs( x="Time(unity)", y = "Concentration (unity)") +

  ggtitle("Titre du graphe \n") +

  theme( plot.title = element_text( hjust = 0.5) )


print( plot_pkpd )










