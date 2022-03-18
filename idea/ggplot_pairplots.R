library("readr")
library("tidyverse")

tips_data =  read_csv("tips.csv")
# Similar to df.dtypes in python
str(tips_data)

# Pairplots in R
# Only Numeric features/Columns can be used
data<-dplyr::select(tips_data,tip,total_bill,size)
head(data)
pairs(data)
str(data)
#install.packages("GGally")
library(GGally)
ggpairs(data=data)+theme_bw()

# Hpw to save a file in R
# Step#1 - Open a specific pdf/jpg/svg file
# pdf - for distribution of file
# jpg - used for inserting an image in power point presentation
# svg - for Demo purposes
# Step#2- Plot the Graph
# Step#3 - Close the Device
#Open a svg file
svg("tips_pairs_plot.svg")
# pdf("tips_pairs_plot.pdf")
jpeg("tips_pairs_plot.jpg")
# Plot the Graph
ggpairs(data=data)+theme_bw()
# Close the Device
dev.off()

# File Formats available
#pdf(“rplot.pdf”): pdf file
#png(“rplot.png”): png file
#jpeg(“rplot.jpg”): jpeg file
#postscript(“rplot.ps”): postscript file
#bmp(“rplot.bmp”): bmp file
#win.metafile(“rplot.wmf”): windows metafile