library(palmerpenguins)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(multcomp)
library(car)
library(MASS)
library(aplore3)

# -------------------------------------------------------------
# Data and introduction
# -------------------------------------------------------------

# The dataset contains data for 344 penguins of 3 different species: Adelie, Chinstrap and Gentoo.
# The dataset contains 8 variables, but we focus only on the flipper length and the species for this article, so we keep only those 2 variables:

dataPenguins = penguins %>%
  dplyr::select( species, flipper_length_mm )

# remove the NA
dataPenguins = dataPenguins %>%
  filter(!is.na(flipper_length_mm))

# grouped boxplot
ggplot(dataPenguins, aes(x=species , y=flipper_length_mm, fill=species)) +
  geom_boxplot()

# As we can see, the differences in the sample flipper lengths for the 3 groups suggests that there is a difference
# between the population mean flipper lengths for the 3 groups. But is this difference statistically significant?
# This is the type of question we can examine using a one-way ANOVA.

#It is called like this because it compares the “between” variance (the variance between the different groups) and the #variance “within” (the variance within each group). If the between variance is significantly larger than the within #variance, the group means are declared to be different. Otherwise, we cannot conclude one way or the other.

summary(dat)

# Flipper length varies from 172 to 231 mm
# with a mean of 200.9 mm. There are respectively 152, 68 and 124 penguins of the species Adelie, Chinstrap and Gentoo

ggplot(dataPenguins) +
  aes(x = species, y = flipper_length_mm, color = species) +
  geom_jitter() +
  theme(legend.position = "none")

# -------------------------------------------------------------
# Aim and hypotheses of ANOVA
# -------------------------------------------------------------

# study whether measurements are similar across different modalities of a categorical variable

# compare the impact of the different levels of a categorical variable on a quantitative variable
# explain a quantitative variable based on a qualitative variable

## Today : Is the length of the flippers different between the 3 species of penguins?

# -------------------------------------------------------------
# The null and alternative hypothesis of an ANOVA
# -------------------------------------------------------------

# On suppose deux hypothèses complémentaires : H0 et H1,

# l’hypothèse H0 formule ce que l’on souhaite rejeter/réfuter,
# l’hypothèse H1 formule ce que l’on souhaite montrer.

# H0: all mean equals = "the 3 species are equal in terms of flipper length"
# H0: at least one mean is different = "at least one species is different from the other 2 species in terms of flipper length"

# on peut avoir length A diff length B and length C AND length B = length C

# !! Other types of test (known as post-hoc tests and covered in this section) must be performed to test whether all 3 species differ

# -------------------------------------------------------------
# Underlying assumptions of ANOVA
# -------------------------------------------------------------

# variable type:
#mix of one continuous quantitative dependent variable (which corresponds to the measurements to which the question relates) and one # qualitative independent variable

# 1 - Check that your observations are independent.

# 2 - Sample sizes:

#   2.1 - In case of small samples, test the normality of residuals:
#       - If normality is assumed, test the homogeneity of the variances:
#         - If variances are equal, use ANOVA.
#         - If variances are not equal, use the Welch ANOVA.
#       - If normality is not assumed, use the Kruskal-Wallis test.
#   2.2 - In case of large samples normality is assumed, so test the homogeneity of the variances:
#
#       - If variances are equal, use ANOVA.
#       - If variances are not equal, use the Welch ANOVA.

# -------------------------------------------------------------
# Independence
# -------------------------------------------------------------

#Independence of the observations is assumed as data have been collected from a randomly selected portion of the population and measurements #within and between the 3 samples are not related.
#The independence assumption is most often verified based on the design of the experim

# -------------------------------------------------------------
# Normality
# -------------------------------------------------------------

speciesSize = dataPenguins %>%
       group_by(species) %>%
       summarise(size = length(species))

# Since the smallest sample size per group (i.e., per species) is 68, we have large samples. Therefore, we do not need to check normality.

## ANOVA
ANOVAdataPenguins = aov(flipper_length_mm ~ species, data = dataPenguins)

## Test for checking normality: visual

par(mfrow = c(1, 2)) # combine plots
# histogram
hist(ANOVAdataPenguins$residuals)
# QQ-plot
#library(car)
qqPlot(ANOVAdataPenguins$residuals, id = FALSE )

## Test for checking normality: statistical test

# H0: data come from a normal distribution
# H1: data do not come from a normal distribution

shapiroTest = shapiro.test(ANOVAdataPenguins$residuals)
shapiroTest$p.value

# -------------------------------------------------------------
# Equality of variances
# -------------------------------------------------------------

# Assuming residuals follow a normal distribution
# check whether the variances are equal across species or not.

## Test for equality of variances: visual

#boxplot

# Rappel
#The first quartile (Q1) is greater than 25% of the data and less than the other 75%.
#The second quartile (Q2) sits in the middle, dividing the data in half.
#Q2 is also known as the median.
#The third quartile (Q3) is larger than 75% of the data, and smaller than the remaining 25%


ANOVAdataPenguins %>%
  ggplot( aes(x=species, y=flipper_length_mm, fill=species)) +
  geom_boxplot() +

  geom_jitter(color="black", size=0.4, alpha=0.9) +

  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("boxplot flipper_length_mm") +
  xlab("")

# violon plot
ANOVAdataPenguins %>%
  ggplot( aes(x=species, y=flipper_length_mm, fill=species)) +
  geom_violin() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("Violin chart flipper_length_mm") +
  xlab("")

# Both the boxplot and the dotplot show a similar variance for the different species. In the boxplot, this can be seen by the fact that the boxes and the whiskers have a comparable size for all species.

## Test for equality of variances: statistical test

#H0: variances are equal
#H1: at least one variance is different

# Levene's test
#library(car)

leveneTest = leveneTest(flipper_length_mm ~ species, data = dataPenguins)
leveneTest$`Pr(>F)`

#The p-value being larger than the significance level of 0.05, we do not reject the null hypothesis, so we cannot # reject the hypothesis that variances are equal between species

# -------------------------------------------------------------
# outliers
# -------------------------------------------------------------

# Any observations that are more than 1.5 IQR below Q1 or more than 1.5 IQR above Q3 are considered outliers.

outliers = boxplot.stats(dataPenguins$flipper_length_mm)$out

# -------------------------------------------------------------
# ANOVA
# -------------------------------------------------------------

# all assumptions of the ANOVA are met.

# see the data

ggplot(dataPenguins) +
  aes(x = species, y = flipper_length_mm) +
  geom_boxplot()


group_by(dataPenguins, species) %>%
  summarise(
    mean = mean(flipper_length_mm, na.rm = TRUE),
    sd = sd(flipper_length_mm, na.rm = TRUE)
  )

## “Is the length of the flippers different between the 3 species of penguins?”.

ANOVAPenguins = aov(flipper_length_mm ~ species, data = dataPenguins)

summary(ANOVAPenguins)

#two outputs above,
#the test statistic (F = in the first method and F value in the second one)
#and the p-value (p-value in the first method and Pr(>F) in the second one)

# p-valeur = une estimation ponctuelle de la probabilité critique de se tromper en rejetant H0 alors que H0 est vraie.

## Interpretations of ANOVA results

#Given that the p-value is smaller than 0.05, we reject the null hypothesis, so we reject the hypothesis that all means are equal. # Therefore, we can conclude that at least one species is different than the others in terms of flippers length (


# But most of the time, when we showed thanks to an ANOVA that at least one group is different, we are also interested in knowing # which one(s) is(are) different. Results of an ANOVA, however, do NOT tell us which group(s) is(are) different from the others.

#To test this, we need to use other types of test, referred as post-hoc tests (in Latin, “after this”, so after obtaining #statistically significant ANOVA results) or multiple pairwise-comparison tests.

# -------------------------------------------------------------
# Post-hoc test
# -------------------------------------------------------------

# Issue of multiple testing

#In order to see which group(s) is(are) different from the others, we need to compare groups 2 by 2.

#In practice, since there are 3 species, we are going to compare species 2 by 2 as follows:

# 1. Chinstrap versus Adelie
# 2. Gentoo vs. Adelie
# 3. Gentoo vs. Chinstrap

# !!!!
# In theory, we could compare species thanks to 3 Student’s t-tests
# if several t-tests are performed, the issue of multiple testing (also referred as multiplicity) arises
# P[ at least 1 significant result] = 1-P[no significant result]
#                                   = 1-(1-0.05)**3
#with as few as 3 tests being considered, we already have a 14.26% chance of observing at least one significant result, even if all #of the tests are actually not significant.

## Post-hoc test:
# 1- Tukey HSD, used to compare all groups to each other (so all possible comparisons of 2 groups).
# 2- Dunnett, used to make comparisons with a reference group. For example, consider 2 treatment groups and one control group. If you only want to compare the 2 treatment groups with respect to the control group, and you do not want to compare the 2 treatment groups to each other, the Dunnett’s test is preferred.
# 3- Bonferroni correction if one has a set of planned comparisons to do.

# -------------------------------------------------------------
# Tukey HSD test
# -------------------------------------------------------------

# no “reference” species

#library(multcomp)

# Tukey HSD test:
TukeyHSDTest = glht(ANOVAdataPenguins, linfct = mcp(species = "Tukey") )

summary(TukeyHSDTest)

# In the output of the Tukey HSD test, we are interested in the table displayed after Linear Hypotheses:

#The first column shows the comparisons which have been made;
#the last column (Pr(>|t|)) shows the adjusted7 p-values for each comparison

#Chinstrap versus Adelie (line Chinstrap - Adelie == 0)
#Gentoo vs. Adelie (line Gentoo - Adelie == 0)
#Gentoo vs. Chinstrap (line Gentoo - Chinstrap == 0)

#All three ajusted p-values are smaller than 0.05, so we reject the null hypothesis for all comparisons,
#which means that all species are significantly different in terms of flippers length.

par(mar = c(3, 8, 3, 3))
plot(post_test)

#if a statistic is significantly different from 0 at the 0.05 level, then the 95% confidence interval will not contain 0

# -------------------------------------------------------------
# Dunnett’s test
# -------------------------------------------------------------

# We have seen in this section that as the number of groups increases, the number of comparisons also increases.

# And as the number of comparisons increases, the post-hoc analysis must lower the individual significance level even further, which leads to lower statistical power (so a difference between group means in the population is less likely to be detected).

# One method to mitigate this and increase the statistical power is by reducing the number of comparisons. This reduction

# utilisation d'un group de reference

#the Dunnett’s test allows to only make comparisons with a reference group, but with the benefit of more power

#Now, again for the sake of illustration, consider that the species Adelie is the reference species and we are only

#library(multcomp)

# Dunnett's test:
DunnettTest = glht(ANOVAdataPenguins, linfct = mcp(species = "Dunnett") )

summary(DunnettTest)

#Chinstrap versus Adelie (line Chinstrap - Adelie == 0)
#Gentoo vs. Adelie (line Gentoo - Adelie == 0)
#Both adjusted p-values (displayed in the last column) are below 0.05, so we reject the null hypothesis for both comparisons.

#This means that both the species Chinstrap and Gentoo are significantly different from the reference species Adelie in terms of flippers length.

par(mar = c(3, 8, 3, 3))
plot(post_test)

# Reference category: sorted lexicographic
# Change reference category:
dataPenguins$species = relevel(dataPenguins$species, ref = "Gentoo")

# Check that Gentoo is the reference category:
levels(dataPenguins$species)

# anova & Dunnett test
ANOVA_2_dataPenguins = aov(flipper_length_mm ~ species, data = dataPenguins)

DunnettTest = glht(ANOVA_2_dataPenguins, linfct = mcp(species = "Dunnett"))
summary(DunnettTest)

par(mar = c(3, 8, 3, 3))
plot(DunnettTest)


##################################################################

# PART 2: anova 2 factors

##################################################################

# -------------------------------------------------------------
# Data
# -------------------------------------------------------------

head(lowbwt)

#Hosmer and Lemeshow (2004) present data on 189 births to women participating in a larger study at Baystate
#Medical Center (Springfield, MA), with information on the following variables

# show character variable values

table(lowbwt$low)
table(lowbwt$race)
table(lowbwt$smoke)
table(lowbwt$ht)

# -------------------------------------------------------------
# Regression logistique
# -------------------------------------------------------------

# objectif : predict the probability of a low birth weight as it depends on
# the mother’s age, weight at last menstrual period, race, and number of first trimester physician
# visits.
#
# Regression logistique:
# Pour analyser une variable binaire (dont les valeurs seraient VRAI/FAUX, 0/1, ou encore OUI/NON) en fonction dune variable explicative quantitative, on peut utiliser une régression logistique.
#
# Avec un modèle de régression linéaire classique, on considère le modèle suivant:
# Y=αX+β
#
# On prédit donc lespérance de Y de la manière suivante :
# E(Y)=αE(X)+β
#
# du fait de la distribution binaire de Y, les relations ci-dessus ne peuvent pas sappliquer. Pour "généraliser" le modèle linéaire, on considère donc que
# g(E(Y))=αE(X)+β
# où g est une fonction de lien.
#
# pour une régression logistique, la fonction de lien correspond à la fonction logit
# logit(p)=log(p/(1−p))

# log(p/(1−p)) = = β0 +β1x1 +β2x2 +...+βnxn

# logistic regression
lowbwt.1 = glm(low ~ age + lwt + race + smoke + ptl + ht + ui + ftv + bwt, data = lowbwt, family = "binomial")
lowbwt.1 = glm(low ~ age + lwt + race + ftv, data = lowbwt, family = "binomial")
summary(lowbwt.1)

# variable selection
lowbwt.2 = step(lowbwt.1, test="Chisq")

# In R, stepAIC is one of the most commonly used search method for feature selection
# minimizing the stepAIC value to come up with the final set of features
#At the very last step stepAIC has produced the optimal set of features

step.model = stepAIC(lowbwt.1, direction = "both", trace = FALSE)
summary(step.model)
step.model$anova

# new model
lowbwt.3 = glm(low ~ lwt + race, data = lowbwt, family = "binomial")
summary(lowbwt.3)

# lwt         -0.015223   0.006439  -2.364   0.0181 *
# raceBlack    1.081066   0.488052   2.215   0.0268 *

# wt is quantitative and has a negative slope. This says that if weight at last menstrual period increases,
# the probability of the baby being of low birth weight decreases, slightly but significantly.

# race is categorical, and the missing race White is the baseline
# a Black woman is a fair bit more likely than a White woman to deliver a low birthweight baby
# Other-race woman is somewhat more likely than a White woman to do so

# -------------------------------------------------------------
# Prediction
# -------------------------------------------------------------

# Make a data frame containing all combinations of the weight at last menstrual period and race  whose values you obtained in the previous part.

# Predict the probability of a low-birth-weight baby for each of these, and display the results side by side with the values they are predictions for.

wts = quantile(lowbwt$lwt,c(0.25,0.75))
races = levels(lowbwt$race)
new = crossing(lwt=lwts, race=races)

p = predict(lowbwt.3, new, type="response")
cbind(new,p)

## Analysis

# see how the probabilities change when your explanatory variable of interest is changed and the other one is held constant.
#
# In our predictions, pick a race, say Black, and note that as lwt increases from 110 to 140,
# the probability of a low birth weight baby decreases (in this case from 0.55 to 0.44).
#
# It doesn’t matter which race you pick; the effect of a change in lwt is the same for all of them.
#
# This is what we said before: increasing weight decreases the probability.
#
# To assess the effect of race, pick a value for lwt, say 110.
#
# The probability of a low birth weight baby is highest for a Black woman and lowest for a White one.
#
# This is what we found before, and the effect is the same at the other lwt value of 140 as well.

##################################################################################################
# END CODE
##################################################################################################



















