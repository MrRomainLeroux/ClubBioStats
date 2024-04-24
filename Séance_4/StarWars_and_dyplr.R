#########################################################################################################

# Seance IV: manipulation de données avec le package "dplyr"
# ( from tidyverse package ecosystem )

#########################################################################################################

# ================
# 1 select()
# ================

# take a subset of columns
# Renaming Columns with select() or rename()

# ================
# 2 filter()
# ================

# take a subset of rows
# Subset Rows using Indices with slice()

# ================
# 3 mutate()
# ================

# add or modify existing columns
# Recoding or Creating Indicator Variables using if_else(), case_when(), or recode()

# ================
# 4 summarise()
# ================

# aggregate the data across rows

# ================
# 5 group_by()
# ================

# =================================================
# 6 Chaining Functions with the pipe operator (%>%)
# =================================================

# select(): for selecting a subset of data by column
# filter(): for filtering a subset of data by row using condition
# arrange(): for re-arranging the rows order
# mutate(): for mutating (:confused:) a new or existing variables

#########################################################################################################

library(dplyr)
library(ggplot2)
library(stringr)

# inspect the structure
glimpse( starwars )

# names( starwars )
# df$ ..

# ================
# dyplr syntax
# ================

# example base R

starwars[starwars$species=="Human" & !is.na(starwars$species), ]

# also possible: 
speciesHuman = which( starwars$species=="Human" )
speciesNAremove = which( !is.na( starwars$species ) )
conditionSelection = intersect( speciesHuman, speciesNAremove )
starwars[ conditionSelection, ]   

# easier !
# NA drop automatically
filter( starwars, species == "Human" ) 

# =====================
# The pipe %>% operator
# =====================

# %>% is "and then"
# applied on a dataset
# chain together different methods into one readable code block
# everything is executed sequentially 
# methods applied on all rows of the dataset

# examples: 
# select(): for selecting a subset of data by column
# filter(): for filtering a subset of data by row using condition
# arrange(): for re-arranging the rows order
# mutate(): for mutating (:confused:) a new or existing variables

# =================
# select()
# selecting columns
# =================

# ------------------------------------------------------
#  extracting multiple extracting extracting columns 
# ------------------------------------------------------

starwars %>%
  select( name )

starwars %>%
  select( name, mass, hair_color )  

# same as "select in the starwars dataset all rows for name, mass, hair_color 

# films in the dataset
starwars %>% select(films) %>%
  unlist() %>%
  unique()

# ... with Luke Skywalker
starwars %>% filter( name == "Luke Skywalker" ) %>%
  select(films) %>%
  unlist() %>%
  length()

# ----------------------------------------------------------
# and you can get all columns in a range using unquoted names
# ----------------------------------------------------------

starwars %>%
  select( name:hair_color ) 

starwars %>%
  select( 1:5, 9, 10 )

# ----------------------------------------------------------------------------------
# select everything other than a specified column using the subtraction operator "-"
# ----------------------------------------------------------------------------------

starwars %>%
  select( -hair_color, -mass )

starwars %>%
  select( -c( hair_color, mass ) )

# ----------------------------------------------------------------------------------
# everything other than a range of named columns
# ----------------------------------------------------------------------------------

starwars %>%
  select( -c( name:hair_color ) )

# ----------------------------------------------------------------------------------
# all columns with names that contain the letter m
# ----------------------------------------------------------------------------------

starwars %>%
  select( contains("m") )

# ----------------------------------------------------------------------------------
# all columns with names that start with the letter m
# ----------------------------------------------------------------------------------

starwars %>%
  select( starts_with("m") )

# ----------------------------------------------------------------------------------
# all columns with names that end with the letter s
# ----------------------------------------------------------------------------------

starwars %>%
  select( ends_with("m") )

# ----------------------------------------------------------------------------------
# select columns and rename them
# rename(new_name = old_name)  
# ----------------------------------------------------------------------------------

# "height_cm" to show the unit

starwars %>%
  select( nm = name, height_cm = height, byear = birth_year )

# ----------------------------------------------------------------------------------
# sort data: arrange()
# ----------------------------------------------------------------------------------

# ascending order
starwars %>% 
  select( name:homeworld )  %>% 
  arrange( height )

# descending order
starwars %>% 
  select( name:homeworld )  %>% 
  arrange( desc( height ) )

# ----------------------------------------------------------------------------------
# sort on multiple columns at the same time
# ----------------------------------------------------------------------------------

# sort by homeworld name and descending height
starwars %>% 
  select( name:homeworld )  %>% 
  arrange( homeworld, desc( height ) )

# ----------------------------------------------------------------------------------
# select rows by position : slice()
# ----------------------------------------------------------------------------------

# rows number 1,2,3
starwars %>% 
  slice(1:3) %>% 
  select( name:homeworld )

starwars %>% 
  slice( c(1,4,5) ) %>% 
  select( name:homeworld )

# example: name and homweworld of the 3 smallest charachter
starwars %>% 
  arrange( height ) %>%
  slice(1:3) %>% 
  select( name, homeworld   )

# ============================================
# filter()
# subset our data based on values in the rows.
# ============================================

# ----------------------------------------------------------------------------------
# filter NA and no NA values for one col
# ----------------------------------------------------------------------------------

starwars %>%
  filter( is.na( homeworld ) )

starwars %>%
  filter( !is.na( homeworld ) )

# ----------------------------------------------------------------------------------
# subset columns
# select name, height, species, homeworld
# ----------------------------------------------------------------------------------

starwars %>%
  select( starwars, name, height, species, homeworld )

# example: name, homeworld, height 
starwars %>% 
  arrange( height ) %>%
  filter( !is.na( homeworld ) ) %>%
  select( name, homeworld, height )

# -------------------------------------------------------------------------------------
# get a subset of all star wars characters from either Tatooine or Naboo
# -------------------------------------------------------------------------------------

# strings 
starwars %>% 
  filter( homeworld == "Tatooine" | homeworld == "Naboo")

# -------------------------------------------------------------------------------------
# extract rows for characters whose birth year is one of 15, 19 or 21
# -------------------------------------------------------------------------------------

# numbers
starwars %>% 
  filter( height %in% c( 80:100 ) )

# -------------------------------------------------------------------------------------
# extract rows for characters who are at least 100 cm tall and are from Naboo
# -------------------------------------------------------------------------------------

# strings & numbers
starwars %>% 
  filter( height %in% c( 200:300 ) & homeworld == "Naboo" )


starwars %>% 
  filter( height >= 100 & homeworld == "Naboo" )

starwars %>% 
  select( name, species, homeworld, height, mass, birth_year) %>% 
  filter( species == "Human" & homeworld == "Tatooine" )  %>% 
  filter( birth_year %in% c( 19:30 ) )

# -------------------------------------------------------------------------------------
# find string
# -------------------------------------------------------------------------------------

starwars %>% 
  filter( grepl( "Skywalker", name ) )

starwars %>%
  filter(!str_detect(name, "Jabba"))

# -------------------------------------------------------------------------------------
# robust filtering: pull()
# used to extract a single column from a data frame as a vector
# used when you only need one column of data to perform operations or analyses
# -------------------------------------------------------------------------------------

# all the character names from starwars into a vector
starwars %>% 
  pull( name )

# create a generic filter
# example on droids: birth_year for maintenance 

# select 2 droids at random
droidNames = starwars %>%
  filter( species == "Droid" ) %>%
  sample_n(2) 

starwars %>%
  select( name, birth_year ) %>% 
  filter( name %in% pull( droidNames, name ) )

# ================================================================== 
# mutate()
# mutate() lets you modify and/or create new columns in a data frame.
# ================================================================== 

starwars %>% 
  select( name, height, mass )  %>%
  mutate(
    height_in_m  = height/100, # convert height from cm to m, store in new column "height_in_m"
    bmi = mass/( height_in_m^2 ), # add a column called bmi for the calculated body mass index of each character
    bmi = round( bmi, 1 ) ) #r ound it to one significant digit/decimal place & assign back to the same name.

# add indicator that shows which characters are over 2m tall

starwars %>% 
  select( name:mass ) %>% 
  mutate( 
    height_in_m  = height/100,
    over_2m = ifelse( height_in_m > 2, 1, 0) )

# -------------------------------------------------------------------------------------
# multiple logical conditions: case_when()
# -------------------------------------------------------------------------------------

# with a function and TRUE
starwars %>% 
  select( name:mass ) %>% 
  mutate( 
    height_in_m  = height/100,
    height_group = case_when(	is.na( height ) ~ "Missing",
                              height_in_m < 1 ~ "Under 1m", 
                              height_in_m > 2 ~ "Over  2m", 
                              TRUE ~ "Between 1m-2m" ) ) # dont forget other NA values

# only for classification
starwars %>% 
  select( name, height ) %>% 
  mutate(
    size_class = case_when(height > 200 ~ "tall", 
                           height < 200 &  height > 100 ~ "medium",
                           height < 100 ~ "short") )

#if_else()
starwars %>% 
  select( name, height ) %>% 
  mutate(
    tall_or_short = if_else(height > 180, "tall", "short" ) )


# -------------------------------------------------------------------------------------
# you can recode a variable: recode()
# -------------------------------------------------------------------------------------

starwars %>% 
  select( name, species)%>% 
  mutate(
    hair_color = recode( species , #the variable you want to recode
                         "Human" = "HUMAN", #old_value = new_value
                         "Droid" = "DROID" ) ) #you can recode any number of values this way

# -------------------------------------------------------------------------------------
# summaries of data & preserve the original data set
# -------------------------------------------------------------------------------------

# add a new column that contains the average height from all characters 
starwars %>% 
  select( name:mass ) %>% 
  mutate( avg_height = mean( height, na.rm=T ) ) 

# who is taller or shorter than average ?
starwars %>% 
  select( name:mass ) %>% 
  mutate( avg_height = mean(height, na.rm=T),                
          height_index = height/avg_height,                  
          height_group = case_when(height_index<=.8  ~ "short",
                                   height_index>=1.2 ~ "tall", 
                                   TRUE  ~ "average")) %>%
  arrange( height_index ) 

# =====================
# summarise()
# =====================

# summary statistics across the whole data set

summary( starwars$height )

starwars %>% 
  summarise(num_records = n(),                              # Number of records in the table
            distinct_species = n_distinct( species ), # Number of unique values of "species"
            avg_mass = mean( mass, na.rm=T ),             # Average mass excluding any missing values
            median_mass = median( mass, na.rm=T ),    # Median mass excluding any missing values
            shortest = min( height, na.rm=T),        # Min value of height excluding any missing values
            tallest = max( height, na.rm=T ) )          # Max value of height excluding any missing values

# =====================
# group_by()
# =====================

# summary statistics for different groups within the data set

starwars %>% 
  group_by(species, gender)

starwars %>% 
  group_by(species, gender) %>% 
  group_vars()

# -------------------------------------------------------------------------------------
# count the number of rows in each group
# -------------------------------------------------------------------------------------

starwars %>% 
  group_by(species, gender) %>% 
  tally()

starwars %>% 
  group_by(species, gender) %>% 
  tally( sort = TRUE )

# -------------------------------------------------------------------------------------
# one group
# -------------------------------------------------------------------------------------

starwars %>% 
  group_by( species ) %>% 
  summarise( avg_height= mean( height, na.rm = T ) )

# -------------------------------------------------------------------------------------
#  multiple groups at the same time
# -------------------------------------------------------------------------------------

# species  & gender: average height
starwars %>% 
  group_by( species, gender) %>% 
  summarise( avg_height= mean( height, na.rm = T ) ) %>% 
  
  starwars %>% 
  filter(gender == "masculine") %>%
  group_by( species, gender) %>% 
  summarise( avg_height= mean( height, na.rm = T ) ) 

# -------------------------------------------------------------------------------------
# cluster group
# -------------------------------------------------------------------------------------

# Inf: upper bound of the last category
height_breaks = c( 0, 100, 150, 170, 190, 200, Inf )

starwars %>%
  filter( !is.na( height ) ) %>%
  group_by( height_cat = cut( height, breaks = height_breaks ) ) %>%
  summarise( count = n() )


# more Droids or humans in the Star Wars movies?
starwars %>% select(species) %>%
  filter(species=="Droid" | species=="Human") %>%
  group_by(species) %>%
  summarize(n=n())

# -------------------------------------------------------------------------------------
# combine different group_by()  
# store the average height for each species and average height by homeworld
# -------------------------------------------------------------------------------------

# example
starwars %>% 
  select( name, height, species, homeworld ) %>%    
  
  group_by( species ) %>%
  mutate( avg_height_species = mean( height, na.rm = T ) ) %>% 
  
  group_by( homeworld ) %>% 
  mutate( avg_height_homeworld = mean( height, na.rm = T ) )

# the tallest 3 characters per homeworld, more than 1 individual by group
starwars %>% 
  select(name, height, homeworld ) %>% 
  arrange( desc(height ) ) %>%            
  group_by( homeworld ) %>%                
  slice( 1:3 ) %>% 
  filter( n()>1 )

# Determine the top 3 homeworlds of Humans:
starwars %>%
  filter(species == "Human") %>%
  group_by(homeworld) %>%
  count() %>%
  arrange(desc(n)) %>%
  head(3)

# ======================================================
# apply functions across multiple columns using across()
# ======================================================

# call the same function to run across multiple columns all at the same time

starwars %>%
  mutate( across( where( is.numeric ), mean, na.rm = TRUE ),                 # Calculate mean for numeric variables
          across( where( is.character ), toupper ) )                         # Convert character variables to uppercase


#######################################################

# part 2: ggplot

#######################################################

# -------------------------------------------------------------------------------------
# plot height, mass
# -------------------------------------------------------------------------------------

ggplot( starwars, aes( height, mass ) ) + geom_point()


# find outliers
starwars %>% 
  select( name, height, mass ) %>%     
  filter(!is.na( mass ) ) %>%                   
  mutate(avg_mass = mean( mass ),      
         SD_mass = sd( mass ),            
         outlier = ifelse( mass>( avg_mass+( 3*SD_mass ) ),1,0 ) ) %>%  
  arrange ( desc( outlier ) ) 

# filter outliers & plot
starwars2 = filter(starwars, name != "Jabba Desilijic Tiure")

ggplot(starwars2, aes(height, mass, colour = species)) + geom_point(na.rm = TRUE)


# -------------------------------------------------------------------------------------
# combine data processing and plot
# -------------------------------------------------------------------------------------

starwars %>% 
  
  select( name, height, mass ) %>%     
  
  filter(!is.na( mass ) ) %>%                   
  
  mutate(avg_mass = mean( mass ),      
         SD_mass = sd( mass ),            
         outlier = ifelse( mass>( avg_mass+( 3*SD_mass ) ),1,0 ) ) %>%  
  
  arrange ( desc( outlier ) ) %>%  
  
  ggplot(aes(x=height, y=mass)) +    
  
  geom_point(aes(colour = as.factor(outlier)), na.rm = TRUE, size=3) + 
  
  geom_text( aes( label=ifelse(outlier==1, as.character(name),'')), hjust=0.5, vjust=2) + 
  
  theme(legend.position="none")


starwars %>%
  filter(!str_detect(name, "Jabba")) %>%
  ggplot() +
  geom_point(aes(height, mass, size = birth_year, colour = gender ), na.rm = TRUE )








