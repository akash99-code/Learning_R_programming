#library(ggplot2)

library(tidyverse)# QUESTION: How can you find out what other datasets are included with ggplot2 ?

data(package="ggplot2")
#data(package="tidyverse")
# Question : Can you List all datasets that are loaded in the memory currently ?
data()

# miles per gallon Dataset
# Fuel economy data from 1999 and 2008 for 38 popular models of car
# http://fueleconomy.gov.
mpg

# Basic Data
nrow(mpg)
ncol(mpg)
names(mpg)
class(mpg)
dim(mpg)
head(mpg)
summary(mpg)

##### DATA SET ####
# 1 Gallon = 3.78 Litres
# 1 Mile = 1.6 km
#• cty and hwy record miles per gallon (mpg) for city and highway driving.
#• displ is the engine displacement in litres.
#       Volume displaced by Pistons
#• drv is the drivetrain: front wheel (f), rear wheel (r) or four wheel (4).
#       The drivetrain (also called driveline) is the sum of components which
#       are delivering the engine power to the wheels. For example, on a rear-wheel drive (RWD) vehicle,
#       the drivetrain consists of: clutch (or torque converter), gearbox (manual or automatic),
#       propeller shaft, differential and drive shafts.
#• model is the model of car. There are 38 models, selected because they had
#   a new edition every year between 1999 and 2008.
#• class, is a categorical variable describing the “type” of car:
#      two seater, SUV, compact, etc.
#• fl, fuel type

############# How to get Unique strings ######
unique(mpg$manufacturer)
unique(mpg$model)
unique(mpg$class)
unique(mpg$fl)

### Questions for thought.
# 1. Do certain manufacturers produce cars with better mileage?
# 2. How fuel economy improved in the decade in question ( 1999-2008) ?

## Exercise
# 1. Which manufacturer has the most the models in this dataset?

### Answer
#library(dplyr)
# group_by(col,..) %>% summarise(action)
by_manufacturer <- group_by(mpg,manufacturer)
numberofModels <- summarise(by_manufacturer, count = n_distinct(model))

## Please further explore package dplyr
# at R Prompt : browseVignettes(package = "dplyr")

#######  ggplot key components - Function call Structure #######
# 1. data (mpg) and x,y var(Aesthetic mapping) are supplied to ggplot
# 2. A layer can be added using '+'

# https://ggplot2.tidyverse.org/reference/geom_point.html
# Scatter Plot defined by
#This produces a scatterplot defined by:
#1. Data: mpg.
#2. Aesthetic mapping: engine size mapped to x position, fuel economy to y
#   position.
#3. Layer: points.
# sns.scatterplot(data=mpg, x="displ", y="hwy")
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

# sns.scatterplot(data=mpg, x="displ", y="hwy", hue="class")
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color=class))

# sns.scatterplot(data=mpg, x="displ", y="hwy", hue="class")
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size=cyl))

# sns.scatterplot(data=mpg, x="displ", y="hwy", hue="day", style="class")
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color=cyl,size=cyl))

# Warning: The shape palette can deal with a maximum of 6 discrete values
# The ColorBrewer scales are documented online at http://colorbrewer2.org/
# Ex: Set1,Set2,Set3,Dark2 etc
# sns.scatterplot(data=tips, x="total_bill", y="tip", hue="size", palette="deep")
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color=drv)) +
  scale_color_brewer(palette = "Set1")
# sns.scatterplot(data=mpg, x="displ", y="hwy", hue="class")
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color=drv)) +
scale_color_brewer(palette = "Dark2")
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color=drv)) +
  scale_color_brewer(palette = "Set3")


# scale_*_gradientn creates a n-colour gradient. For binned variants of these scales, see the color steps scales.
# sns.scatterplot(data=mpg, x="displ", y="hwy", hue="class", size="class")

# http://www.sthda.com/english/wiki/ggplot2-point-shapes

###### CONCLUSION from GRAPH
#as the engine size gets bigger, the fuel economy gets worse.( -ve Correlation)

##Exercises
# Describe the data, aesthetic mappings and layers used for each of the
# following plots.
ggplot(mpg, aes(cty, hwy)) + geom_point()
ggplot(diamonds, aes(carat, price)) + geom_point()
ggplot(economics, aes(date, unemploy)) + geom_line()
ggplot(mpg, aes(cty)) + geom_histogram()


## More Examples
ggplot(mpg, aes(displ, hwy)) + geom_point()
ggplot(mpg, aes(displ, hwy)) + geom_point(colour = "blue")
## OBSERVATION: Points in BLUE color

ggplot(mpg, aes(displ, hwy)) + geom_point(aes(colour = "bluei"))
## OBSERVATION: Points in PINK color and Legend "blue"
# The second plot maps (not sets) the colour to the value ‘darkblue’.
# This effectively creates a new variable containing only the value ‘darkblue’
# and then scales it with a colour scale. Because this value is discrete, the
# default colour scale uses evenly spaced colours on the colour wheel, and since
# there is only one value this colour is pinkish
## See vignette("ggplot2-specs") for the values needed for colour and other aesthetics.

### We can override default scale
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = "darkblue")) +
  scale_colour_identity()


##### Exercise
# Experiment with the colour, shape and size aesthetics. What happens
# when you map them to continuous values? What about categorical values?
#   What happens when you use more than one aesthetic in a plot?
## cty is a continous variable
mpg$cty
ggplot(mpg, aes(displ, hwy, colour = cty)) +
    geom_point()
# Any relation to min,max etc??
summary(mpg$cty)

##### Facetting ######
# There are two types of facetting: grid and wrapped.
# Wrapped is the most useful
# To facet a plot you simply add a facetting specification with facet wrap(),
# which takes the name of a variable preceded by ˜.
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~class)

### When to use Aesthetics and when to use Facetting
# Facetting is an alternative to using aesthetics (like colour, shape or size) to
# differentiate groups
## Aesthetics
ggplot(mpg, aes(displ, hwy, colour = class)) + geom_point()



#######  Plot Geoms #######
# 1.geom smooth() fits a smoother to the data and displays the smooth and its
# standard error.
# 2.geom boxplot() produces a box-and-whisker plot to summarise the distribution
# of a set of points.
# 3.geom histogram() and geom freqpoly() show the distribution of continuous
# variables.
# 4.geom bar() shows the distribution of categorical variables.
# 5.geom path() and geom line() draw lines between the data points. A line plot
# is constrained to produce lines that travel from left to right, while paths
# can go in any direction. Lines are typically used to explore how things
# change over time.


####### Adding a Smoother to a Plot
# If you have a scatterplot with a lot of noise, it can be hard to see the dominant
# pattern. In this case it’s useful to add a smoothed line to the plot with geom smooth()
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth()

# Regression Method
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_smooth(method = "lm")

####### Adding a Box-plot
ggplot(mpg, aes(drv, hwy)) + geom_boxplot()

####### Histograms and Frequency Polygons
ggplot(mpg, aes(hwy)) + geom_histogram()
ggplot(mpg, aes(hwy)) + geom_freqpoly()

ggplot(mpg, aes(hwy)) +
  geom_freqpoly(binwidth = 1)

# To compare the distributions of different subgroups, you can map
# a categorical variable to either fill (for geom histogram()) or
# colour (for geom freqpoly()).
p1 <- ggplot(mpg, aes(displ, colour = drv)) +
  geom_freqpoly(binwidth = 0.5)
p2 <- ggplot(mpg, aes(displ, fill = drv)) +
  geom_histogram(binwidth = 0.5) +
  facet_wrap(~drv, ncol = 1)
p1
p2
####### Histograms and Frequency Polygons
library(gridExtra)
grid.arrange(p1, p2, nrow = 1)

### Bar Charts
t <- ggplot(mpg, aes(manufacturer)) +
  geom_bar()
t
#### Changing titles
t + labs(title ="Bar Chart for Manufacturer", x = "New x", y = "New y")
