
#########################################################

# Seances 1 

# Manipulation des structures de données

#########################################################


#########################################################

# Séance 1: 25/01/2024

#########################################################

# set your working directory
setwd("C:/Users/ADMIN Romain LEROUX/Documents/Club_BioStats_2024")

# =======================================================

# Vectors

# =======================================================

# -------------------------------------------------------
# Create a vector
# -------------------------------------------------------

# vectors of integer
vecInteger = c( 1, 2, 3, 4, 5 )
print( vecInteger )

# vectors of double, character, logical
vecDouble = c( 1.1, 2.0, 3.1 )

# vectors of character (color)
vecColors = c( "blue", "red", "orange" )
vecColors

# convention de nommage des variables: serpent / chameau
# vec_colors_aa_zz_
# vecColorsDeDonnesCsv

# vectors of logical
vecLogicals = c( TRUE, FALSE, TRUE )
vecLogicals

# name data in vector + find the data
vecData = c( "data1" = 1, "data2" = 2, "data3" = 3 )

# format : vecData[]
vecData["data1"]

# vector length
vectorLength = length( vecData )

# create sequence
seq = seq( 1, 2, by = 1)
vecData[ seq ]

# seq_along
seq = seq_along( vecData )

# repeated values & vectors
repeatedValue = rep( 1, 3 )
repeatedValue = rep( "1", 3 )

repeatedValue

# all vec
repeatedVector = rep( vecData, 3 )

# each element
repeatedElements = rep( 1, 3, each =2 )

# ----------------------------
# type of a  vector
# ----------------------------

# type double
# type character
typeof( vecColors )

# type change !
vecColorInteger = c( vecColors, vecInteger  )
typeof( vecColorInteger )

vecTmp = c( "1", "2" )
as.numeric( vecTmp )

vecTmp = c( 1, 2 )
as.character( vecTmp )

# coercion
# convert character to number
# NA due to conversion
# as.double & as.numeric & as.character

vecColorIntegerWithMissingData = as.double( vecColorInteger )

# NA values in vecColorInteger
# indices, remove it

indicesMissingData = is.na( vecColorIntegerWithMissingData )

vecColorIntegerWithMissingData[ indicesMissingData == FALSE ]

# function which 
indicesMissingData = which( indicesMissingData == FALSE  )
vecColorIntegerWithMissingData[ indicesMissingData ]

# -------------------------------------------------------
# Vector operations and functions
# -------------------------------------------------------

# -----------------------------
# Select vector elements
# -----------------------------

# -------------------------
# position
# -------------------------

# select 5th element
vecInteger[c(5)]

# select 1,3,5th element

vecInteger[ c(1,3,5) ]

# select  all except the 5th
vecInteger[ -c( 5 ) ]

# select range 2th and 5th
vecInteger[ -c( 2, 5 ) ]

# select range 2th to 5th
vecInteger[ -c( 2:5 ) ]
vecInteger[ -seq( 2, 5, by = 1 ) ]

# select all except 2th to 5th
vecInteger[ -c(2,5) ]

# -------------------------
# value
# -------------------------

# value == 5
indice = which( vecInteger == 5 )
vecInteger[ indice ]

# value > 2
indice = which( vecInteger > 2 )
vecInteger[ indice ]

vecInteger = seq( 1, 10 , by = 1 )

# value between
minValue = 5
maxValue = 8

indice = which( vecInteger > minValue & vecInteger < maxValue )

vecInteger[ indice ]

# -----------------------------------
# vec boolean nombre true false random
# -----------------------------------

#vecLogicals TRUE
vecLogicals

# indices #vecLogicals TRUE
which( vecLogicals == TRUE  )

# -----------------------------------
# find a string
# -----------------------------------

# data month names
vecMois = month.name
match( c("Mai","May"), vecMois, nomatch = 999 )

# trouver a string dans vecMois
stringToFind = "u"
indiceStringToFind = which( grepl( stringToFind, vecMois ) == TRUE )
vecMois[ indiceStringToFind  ]

# en fonction 
findString = function( stringToFind, data )
{
  indiceStringToFind = which( grepl( stringToFind, data ) == TRUE )
  dataWithString = data[ indiceStringToFind ]
  
  return( dataWithString )
}

# function: find stringToFind in data
stringToFind = "u"
moisWithString = findString( stringToFind, vecMois )
print( moisWithString )

# ======================================================

# Exercise 1

# ======================================================

vec1 = c(1,2,3)
vec2 = c(5,6,7)

vec = c( vec1, vec2 )

# Créer un vecteur x contenant les éléments 1, 4 et 5
x = c(1,4,5)

#Créer un vecteur y contenant les chiffres  de 1 à 9
y = seq(1,9, by = 1)

#Afficher le 2ème élément de y
y[c(2)]

#Afficher tous les éléments de y sauf le 2ème
y[-c(2)]

#Afficher les éléments 2 à 4 de y
y[c(2:4)]

#Créer un vecteur xy contenant le premier, quatri?me et cinqui?me ?l?ment de y
xy=y[c(1,4,5)]

# -----------------------------
# Functions on vector
# -----------------------------

vec = seq( 4,10, by =1)  # rnorm(1000) #seq(4,10,1)

vecMin = min( vec )
vecMax = max( vec )

indMinVec = which( vec == vecMin )
vec[ inMinVec ]

# --------------------------------------
# Function	& Description
# --------------------------------------

# round()	Round numeric values
# min(), max()	Minimum and maximum
# mean(), median()	Arithmetic mean and median
# sum()	Sum
# sd(), var()	Standard deviation and variance
# sqrt()	Square root

# head() show the first elements
# summary()	Numerical summary
# sort()	Sort a vector
# rev()	reverse a vector
# table()	see occurrence of values
# unique() see unique  values
# duplicated() see unique  values

vecInteger = c(1,3,5,2,10,3)

vecIntegerSorted = sort( vecInteger, decreasing = FALSE  )
vecIntegerSorted = sort( vecInteger, decreasing = TRUE  )

vecIntegerRev = rev( vecInteger )

vecIntegerCount = table(  vecInteger )

vecIntegerUnique = unique( vecInteger )

vecIntegerDuplicated = duplicated(  vecInteger )
indiceDuplicated = which( vecIntegerDuplicated == TRUE )
vecInteger[ indiceDuplicated ]

# missing data cf slides

y = c(1:4,NA,rep(0.8,2),NA)

indicesNotMissingData = which( is.na(y) == FALSE  )
y[ indicesNotMissingData ]

mean(y, na.rm = TRUE)

# ==============================================
# Exercise 2
# ==============================================

#Créer un vecteur vec de taille 10 avec la commande rnorm(10)).
vec = rnorm(10)
vec

# histogramme 
hist( vec )

#Calculer le nombre d'éléments positifs de vec.
length(vec[vec>0])

#Calculer yvec dont les éléments sont composés du logarithme des éléments de vec.
yvec = log(vec)
yvec

#Créer le vecteur vec2 avec seulement les éléments non manquants de yvec.
vec2 = yvec[!is.na(yvec)]
vec2

#Afficher le nombre d'éléments de vec2.
length(vec2)







