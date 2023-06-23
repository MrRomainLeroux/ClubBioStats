#############################################################

# Seance IV: manipulation de données avec le package "dplyr"
# ( from tidyverse package ecosystem )

#############################################################

# 1 select()
# Renaming Columns with select() or rename()
# 2 filter()
# Subset Rows using Indices with slice()
# 3 mutate()
# Recoding or Creating Indicator Variables using if_else(), case_when(), or recode()
# 4 summarise()
# 5 group_by()
# 6 Chaining Functions with the pipe operator (%>%)

# select(): for selecting a subset of data by column
# filter(): for filtering a subset of data by row using condition
# arrange(): for re-arranging the rows order
# mutate(): for mutating (:confused:) a new or existing variables

library(dplyr)
library(ggplot2)
library(stringr)

#######################################################

# part 1: data manipulation

#######################################################

df = starwars #assign the star wars data frame (imported when dplyr is loaded) to the label/name "df"

# inspect the structure
glimpse(df)

# -------------
# select()
# -------------

#dplyr::select() makes extracting multiple columns even easier
select(df, name, mass, hair_color) #note that names don't have to be quoted

select(df, name:hair_color) #and you can get all columns in a range using unquoted names

select(df, 1:5, 9, 10)

#select everything other than a specified column using the subtraction operator "-"
select(df, -hair_color, -mass)

#everything other than a range of named columns
select(df, -c(name:hair_color))

#all columns with names that contain the letter m
select(df, contains("m"))

#all columns with names that start with the letter m
select(df, starts_with("m"))

#all columns with names that end with the letter s
select(df, ends_with("s"))

# ? select and matches()

# Renaming Columns with select() or rename()

#select columns and rename them
select(df, nm = name, hgt = height, byear = birth_year)

#returns all columns
rename(df, nm = name, hgt = height, b_year = birth_year)

# -------------
# filter()
# -------------

#na and no na values
filter(starwars, is.na(mass))
filter(starwars, !is.na(mass))

# subset columns
df2 = select(df, name, height, species, homeworld)
unique(df2$homeworld)

# use filter to get a subset of all star wars characters from either Tatooine or Naboo
filter(df2, homeworld == "Tatooine" | homeworld == "Naboo")

# extract rows for characters who are at least 100 cm tall and are from Naboo
filter(df2, height >= 100 & homeworld == "Naboo")

#find string
filter(df2, grepl("Skywalker", name ))

#chaining function
# x %>% f(y) is equivalent to f(x, y)
# z %>% f(x, y, .) is equivalent to f(x, y, z)

starwars %>%
  filter(!str_detect(name, "Jabba"))

filtered_data = starwars %>%
  filter(gender %in% c("feminine", "masculine"))

## Subset Rows using Indices with slice()
dfSliced = slice(df2, 1:5, 9:14, 25:50)

# pull
starwars %>%
  filter(species == "Droid") %>%
  pull(name)

# -------------
# mutate()
# -------------

# mutate() lets you modify and/or create new columns in a data frame.

df2 = select(df, name, height, mass) #extract columns of interest


df3 = mutate(df2,
              height_in_m  = height/100, #convert height from cm to m, store in new column "height_in_m"
              bmi = mass/(height_in_m^2), #add a column called bmi for the calculated body mass index of each character
              bmi = signif(bmi, 1)) #round it to one significant digit/decimal place & assign back to the same name.
df3

## Recoding or Creating Indicator Variables using if_else(), case_when(), or recode()
mutate(select(df, name, height), #apply mutate to a subset of the data using a nested select call
       tall_or_short = if_else(height > 180,
                               "tall",
                               "short"))

# to specify more than 2 conditions/outputs you can use case_when():
mutate(select(df, name, height),
       size_class = case_when(height > 200 ~ "tall", #logical_test ~ value_if_TRUE,
                              height < 200 &  height > 100 ~ "medium",
                              height < 100 ~ "short") )

# you can recode a variable using recode():

recoded_using_recode = mutate(select(df, name, species),
                               hair_color = recode(species , #the variable you want to recode
                                                   "Human" = "HUMAN",#old_value = new_value
                                                   "Droid" = "DROID") #you can recode any number of values this way

)

recoded_using_recode

# -------------
# summarise()
# -------------

summary(starwars$height)

# to turn a data frame into a smaller data frame of summary statistics.
summary1 = summarise(df, #as for the other dplyr functions, the data source is specified as the 1st argument
                      n = n(), #n() is a special function for use in summarize that returns the number of values
                      mean_height = mean(height, na.rm = TRUE), #summary stat name in the output = function(column) in the input
                      median_mass = median(mass, na.rm = TRUE))

summary1

# -------------
# group_by()
# -------------

# To declare a group, you just need to specify the name of variables that you want to set as group identifier
#
# extract just the columns of interest
# df3 = select(df, name, species, height, mass)

# group the data frame "df3" by the variable "species"

# grouped_data = group_by(df3, species)

# class(grouped_data)
#
# glimpse(grouped_data) #note that the structure now has a groups attribute
#
# slice(grouped_data, 1) #look at the 1st row of each group
#

# count the number of rows in each group

by_species = starwars %>% group_by(species)
by_sex_gender = starwars %>% group_by(sex, gender)

# the names of the grouping variables
by_species %>% group_vars()
by_sex_gender %>% group_vars()

#count the number of rows in each group
by_species %>% tally()
by_sex_gender %>% tally(sort = TRUE)

# cluster group
height_breaks = c(0, 100, 150, 170, 190, 200)

starwars %>%
  group_by(height_cat = cut(height, breaks=height_breaks)) %>%
  tally()

# which group each row belongs to with
by_species %>% group_indices()

## with select

#f ind the tallest character of each species
by_species %>%
  select(name, species, height) %>%
  filter(height == max(height))

# eliminates all groups that only have a single member
by_species %>%
  filter(n() != 1) %>%
  tally()

# slice
slice(starwars, 1:3, 10)

# summarise
starwars %>% group_by(species) %>%
  summarise(mean_height = mean(height, na.rm = T),
            mean_mass = mean(mass, na.rm = T))

# -------------------------------------------------
#  Chaining Functions with the pipe operator (%>%)
# -------------------------------------------------

starwars %>%
  select(name)

starwars %>%
  select(name, species, homeworld, gender, mass, height)

starwars %>%
  select(name, species, homeworld, gender, mass, height) %>%
  filter(species == "Human")

starwars %>%
  select(name, species, homeworld, gender, mass, height) %>%
  filter(species == "Human") %>%
  mutate(bmi = mass / height * 100)

tmp = starwars %>%
  select(name, species, homeworld, gender, mass, height) %>%
  filter(species == "Human") %>%
  mutate(bmi = mass / height * 100) %>%
  group_by(homeworld, gender)

sorted_mass_by_sw_species_chained = starwars %>%

  select(species, mass) %>% # extract species and mass

  group_by(species) %>% # group it by species

  summarise(mean_mass = mean(mass, na.rm = T)) %>% # summarise() the grouped data frame to get the mean mass per group

  arrange(desc(mean_mass)) # arrange the grouped summary by the mean mass column in descending order

## summarize by groups

starwars %>%
  group_by(species) %>%
  summarise(
    n = n(),
    mass = mean(mass, na.rm = TRUE)
  ) %>%
  filter(n > 1,
         mass > 50 )

#######################################################

# part 2: ggplot

#######################################################

ggplot(starwars, aes(height, mass)) + geom_point()

starwars2 = filter(starwars, name != "Jabba Desilijic Tiure")

ggplot(starwars2, aes(height, mass)) + geom_point()

ggplot(starwars2, aes(height, mass, colour = species)) + geom_point()


ggplot(starwars, aes(x = sex, fill = species)) +
  theme_bw()+
  geom_bar()+
  labs( x=" Gender of the starwars characters",
        title = "Gender filled with Species")

starwars %>%
  filter(!str_detect(name, "Jabba")) %>%
  ggplot() +
  geom_point(aes(height, mass, size = birth_year, colour = gender))

#######################################################

# part 3: Joining data using dplyr

#######################################################

# inner_join	includes all rows in x and y (intersection)
# left_join	includes all rows in x
# right_join	includes all rows in y
# full_join	includes all rows in x or y (union)

# left_join(x, y):
# Return all rows from x, and all columns from x and y.
# Rows in x with no match in y will have NA values in the new columns.
# If there are multiple matches between x and y, all combinations of the matches are returned.

# right_join(x, y): Same as left_join(y, x), and hence redundant.

# full_join(x, y): Return all rows and all columns that exist in x or in y.
# If there are non-matching values, return NA for the ones missing.

# inner_join(x, y): Return all rows from x where there are matching values in y,
# and all columns from x and y. If there are multiple matches between x and y,
# all combination of the matches are returned.

# semi_join(x, y)
# keeps all observations in x that have a match in y
# (i.e., observations in x without a match in y are dropped).

# anti_join(x, y) drops all observations in x that have a match in y
# (i.e., observations in x without a match in y are kept).
#

# Determine the top 3 homeworlds of Humans:
top_3_human_homes = starwars %>%
  filter(species == "Human") %>%
  group_by(homeworld) %>%
  count() %>%
  arrange(desc(n)) %>%
  head(3)

# Which individuals (human and non-human) are from these homeworlds?
semi_join(starwars, top_3_human_homes, by = "homeworld")  # => 31 individuals

# Split up the data set so we can practice joining them back together
humans_droids =
  starwars %>%
  filter(species %in% c("Human", "Droid")) %>%
  select(name, homeworld) %>%
  print()

humans =
  starwars %>%
  filter(species=="Human") %>%
  select(name, species) %>%
  print()

# inner_join
inner_join(humans_droids, humans, by="name")

#left_join
left_join(humans_droids, humans, by="name")

#full_join
full_join(humans, humans_droids, by="name")














