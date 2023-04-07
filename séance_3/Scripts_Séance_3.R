###################################################################################

# Séance 3 : ggplots2 
# Date 24-03/2023

# éléments géométriques: histogramme, scatterplot, curve plot, density plot
# propriétés visuelles: axes, couleurs, tailles, texte
# + par catégories, secondary axis, sauvegarder plot

###################################################################################

library(ggplot2)

## INTRODUCTION

setwd('D:/RECHERCHES/Club_BioStats_2023/Séance3/')

data = data.frame(
  category = factor( rep( c("F","M"), 200 ) ),
  weight = round( c( rnorm(200, mean=50, sd=5), 
                     rnorm(200, mean=60, sd=5) ) ) )

## ggplot2

# barplot by categories
plotCategories = ggplot( data, aes( x = weight ) ) +
  
  geom_histogram( bins = 20 ) +
  
  scale_y_continuous( expand = c(0,0), 
                      limits = c(0,50))

print( plotCategories )

# save
ggsave( "dataCategories.png", 
        plot = plotCategories, 
        width = 10, height = 8,
        dpi = 200, units="in")

# customize

plotCategories = ggplot( data, aes( x = weight ) ) +
  
  geom_histogram( bins = 20, binwidth = 1, 
                  color="red", fill="blue", alpha = 0.25 ) +
  
  xlab("Weight (kg)") +
  
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

# plusieurs histogrammes par catégories 
# facet_grid
# facet_wrap

plotHist = ggplot( data, aes( x = weight, color = category ) ) +
  
  geom_histogram( bins = 30, fill="white", alpha=0.5, position="identity" ) +
  
  #facet_grid( category~. ) +
  facet_wrap( category~. ) +
  
  theme_bw(11)+
  
  theme(legend.position="bottom") 

print(plotHist)

########################################################################################

## JEUX DE DONNEES

## data : ToothGrowth_Guinea

pathData = 'D:/RECHERCHES/Club_BioStats_2023/Séance3/'

ToothGrowth = read.csv( paste0( pathData, "ToothGrowth_Guinea.csv"), sep=",", dec=",")

plot = ggplot( data = ToothGrowth ) +
  geom_bar( aes( x = City ) ) 
print(plot)

# split: city et dose

plot = ggplot( data = ToothGrowth ) +
  
  geom_bar( aes( x = City, fill = as.factor( dose ) ) ) +
  
  xlab("Dose (unite/jour)") +
  
  scale_fill_discrete( name = "Dose (unite/jour)") +
  
  theme_bw(11) +
  
  theme(legend.position="bottom") 

# split: city et dose et supp

plot = plot + 
  
  facet_grid(.~supp)

print( plot )

# boxplot

plot = ggplot( data = ToothGrowth ) +
  
  geom_boxplot( aes( x = City, y = len, fill = as.factor(dose) ) )+
  
  geom_point( aes(x = City, y = len ), col = "red", alpha = 1.0 ) +
  
  scale_fill_manual( values = c( "#E69F00" , "#56B4E9", "#009E73" ) ) +
  
  labs(fill="Dose")

print( plot )


## data : ToothGrowth_Guinea2

ToothGrowth2 = read.csv( paste0( pathData, "ToothGrowth_Guinea_2.csv"), sep=";", dec=",")
head(ToothGrowth2)

# ? # question : afficher uniquement la bar d'erreur supérieure

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

## envoyer le fichier de données !


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










