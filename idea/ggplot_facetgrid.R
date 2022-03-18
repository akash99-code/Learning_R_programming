library("readr")
library("tidyverse")

# Web Reference - https://ggplot2.tidyverse.org/reference/facet_grid.html
# Similar to pandas.read_csv()
infosys_data = read_csv("infosys.csv")
# First 5 rows of Data
head(infosys_data)
# Columns or features
names(infosys_data)
# Basic Statistics - pandas.DataFrame.describe()
summary(infosys_data)
#
class(infosys_data)

# Display the Struture of an arbitrary R object - similar to pandas.DataFrame.dtypes
# help("str")
str(infosys_data)

# Graphics - BEst practices
# Shapes vs Colors - Colors Preferred
# Horizontal Bar Chart

tips_data =  read_csv("tips.csv")
str(tips_data)
# Facet_Grid - python
# g = sns.FacetGrid(tips, col="time",  row="sex")
# g.map(sns.scatterplot, "total_bill", "tip")
# Facet_Grid -R
# help("facet_grid")
# traditional interface - ~
ggplot(data = tips_data, aes(x=total_bill, y=tip)) +
       geom_point()+
       facet_grid(time~sex)

ggplot(data = tips_data) +
  geom_point(mapping = aes(x=total_bill, y=tip))+
  facet_grid(sex~time)

ggplot(data = tips_data) +
  geom_point(mapping = aes(x=total_bill, y=tip))+
  facet_grid(sex~.)

ggplot(data = tips_data) +
  geom_point(mapping = aes(x=total_bill, y=tip))+
  facet_grid(.~sex)

# New Definition - syntax diffrent
# facet_grid(
#   rows = NULL,
#   cols = NULL,
#   ....)
ggplot(data = tips_data) +
  geom_point(mapping = aes(x=total_bill, y=tip))+
  facet_grid(rows=vars(time), cols = vars(sex))

ggplot(data = tips_data) +
  geom_point(mapping = aes(x=total_bill, y=tip),colour ="green")+
  facet_grid(rows=vars(time), cols = vars(sex))


# Geom_Hstogram - color inside aes(), vs outside
# inside aes() treated like categorical variable
ggplot(data = tips_data) +
  geom_histogram(mapping = aes(x=total_bill))

ggplot(data = tips_data) +
  geom_histogram(mapping = aes(x=total_bill), color="blue")

ggplot(data = tips_data) +
  geom_histogram(mapping = aes(x=total_bill,color=sex))

# seaborn - python
# g = sns.FacetGrid(tips, col="time",  row="sex")
# g.map_dataframe(sns.histplot, x="total_bill")
# Equivalent in R
ggplot(data = tips_data) +
  geom_histogram(mapping = aes(x=total_bill))+
  facet_grid(cols = vars(time),rows=vars(sex))

# Can we bars in Blue Color - Just like Seaborn ?
ggplot(data = tips_data) +
  geom_histogram(mapping = aes(x=total_bill), colour="blue")+
  facet_grid(cols = vars(time),rows=vars(sex))

# Can we bars in Blue Color - Just like Seaborn ?
ggplot(data = tips_data) +
  geom_histogram(mapping = aes(x=total_bill), color="blue")+
  facet_grid(cols = vars(time),rows=vars(sex))

# Fill Bars with Blue Color
ggplot(data = tips_data) +
  geom_histogram(mapping = aes(x=total_bill), fill="blue")+
  facet_grid(cols = vars(time),rows=vars(sex))

ggplot(data = tips_data) +
  geom_histogram(mapping = aes(x=total_bill), fill="#8080ff",binwidth = 2) +
  facet_grid(cols = vars(time),rows=vars(sex))

# seaborn - python

# Seaborn Python
#g = sns.FacetGrid(tips, col="time", row="sex")
#g.map_dataframe(sns.histplot, x="total_bill", binwidth=2, binrange=(0, 60))
ggplot(data = tips_data) +
  geom_histogram(mapping = aes(x=total_bill), fill="blue",binwidth = 2)+
  facet_grid(cols = vars(time),rows=vars(sex))
# Explore: http://www.sthda.com/english/wiki/ggplot2-histogram-plot-quick-start-guide-r-software-and-data-visualization

# Seaborn -
#g = sns.FacetGrid(tips, col="time", hue="sex")
#g.map_dataframe(sns.scatterplot, x="total_bill", y="tip")
#g.add_legend()
ggplot(data = tips_data) +
  geom_point(mapping=aes(x=total_bill,y=tip)) +
  facet_grid(cols=vars(time))
# facet_grid in R doesn't have option for color/hue - can give in geom.
ggplot(data = tips_data) +
  geom_point(mapping=aes(x=total_bill,y=tip,color=sex)) +
  facet_grid(cols=vars(time))

# Seaborn
#g = sns.FacetGrid(tips, col="time", margin_titles=True)
#g.map_dataframe(sns.scatterplot, x="total_bill", y="tip")
#g.refline(y=tips["tip"].median())
# Need to add a new geom for median line
ggplot(data = tips_data) +
  geom_point(mapping=aes(x=total_bill,y=tip)) +
  geom_hline(aes(yintercept=median(tip)),
           color="blue", linetype="dashed", size=1)


#### Seaborn
# g = sns.FacetGrid(tips, col="sex", row="time", margin_titles=True)
#g.map_dataframe(sns.scatterplot, x="total_bill", y="tip")
#g.set_axis_labels("Total bill ($)", "Tip ($)")
#g.set_titles(col_template="{col_name} patrons", row_template="{row_name}")
#g.set(xlim=(0, 60), ylim=(0, 12), xticks=[10, 30, 50], yticks=[2, 6, 10])
#g.tight_layout()
#g.savefig("facet_plot.png")

####### Changing Facet_grid Labels
# Add Feature Name next to Labels
ggplot(data = tips_data) +
  geom_point(mapping=aes(x=total_bill,y=tip,)) +
  facet_grid(cols=vars(sex),rows=vars(time), labeller = label_both)

# c function for combine
new_labels <- c("Male Patrons", "Female Patrons")
names(new_labels) <- c("Male", "Female")
ggplot(data = tips_data) +
  geom_point(mapping=aes(x=total_bill,y=tip,)) +
  facet_grid(cols=vars(sex),rows=vars(time), labeller =  labeller(sex=new_labels))

# Adding a title - +ggtitle("Your Title Here")
# Changing axis labels - +labs(y= "y axis name", x = "x axis name")
# Changing the legend title - +labs(colour = "Legend Title")
new_labels <- c("Male Patrons", "Female Patrons")
names(new_labels) <- c("Male", "Female")
ggplot(data = tips_data) +
  geom_point(mapping=aes(x=total_bill,y=tip,)) +
  facet_grid(cols=vars(sex),rows=vars(time), labeller =  labeller(sex=new_labels)) +
  labs(y= "Tip ($)", x = "Total bill ($)")

new_labels
str(new_labels)