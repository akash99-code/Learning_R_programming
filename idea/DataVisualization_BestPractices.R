library("readr")
library("tidyverse")

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

# https://stackoverflow.com/questions/59008974/why-is-stat-identity-necessary-in-geom-bar-in-ggplot
####### What is the trend of Infosys Revenue ?
print(infosys_data$Revenues_Crores)
print(infosys_data$Year)
# Plot using geom_bar() with stat="identity"
ggplot(data=infosys_data)+
  geom_bar(stat="identity",mapping = aes(x=Year,y=Revenues_Crores))
# Or Plot using geom_col()
ggplot(data=infosys_data)+
  geom_col(mapping = aes(x=Year,y=Revenues_Crores))
#Best Practice#1: Plot with Light Color Pallete ( Ex:Blue - R-136,G-189,B-230)
# Convert Decimal to Hexadecimal
v <- c(136,189,230)
sprintf("%x",v)
# Bar chart with Blue color bars
ggplot(data=infosys_data)+
  geom_col(mapping = aes(x=Year,y=Revenues_Crores), fill="#88bde6")
# Best Practice#2: One can Highlight a specific bar to draw attention
# Ex: Highlght Year 2020 with Dark Blue Color
# Alpha value - https://ggplot2.tidyverse.org/reference/scale_manual.html
ggplot(infosys_data) +
  geom_col(
    mapping = aes(x=Year,y=Revenues_Crores,alpha = Year == 2020),
    fill = "#88bde6", ,
    position = position_dodge()) +
  scale_alpha_manual(values = c(0.7, 1))

######### Dark Color Palette
v <- c(38,93,171)
sprintf("%x",v)
ggplot(infosys_data) +
  geom_col(
    mapping = aes(x=Year,y=Revenues_Crores,alpha = Year == 2020),
    fill = "#265dab", ,
    position = position_dodge()) +
  scale_alpha_manual(values = c(0.65, 1))

# Seaborn - sns.set_theme(style="whitegrid,...
# How to Change Theme in GGPlot
#Several functions are available in ggplot2 package for changing quickly the theme of plots :
# theme_gray : gray background color and white grid lines
# theme_bw : white background and gray grid lines
# theme_linedraw : black lines around the plot
# theme_light : light gray lines and axis (more attention towards the data)
# theme_minimal: no background annotations
# theme_classic : theme with axis lines and no grid lines
ggplot(infosys_data) +
  geom_col(
    mapping = aes(x=Year,y=Revenues_Crores,alpha = Year == 2020),
    fill = "#265dab") +
  scale_alpha_manual(values = c(0.65, 1)) +
  theme_bw()

# Horizontal Bar Chart
ggplot(infosys_data) +
  geom_col(
    mapping = aes(x=Year,y=Revenues_Crores,alpha = Year == 2020),
    fill = "#265dab") +
  scale_alpha_manual(values = c(0.65, 1)) +
  theme_bw() +
   coord_flip()

############ GGplot with Different Scales
print(infosys_data$Operating_margin)
print(infosys_data$Revenues_Crores)
scalecoeff <- 1000
ggplot(data=infosys_data) +        # Create ggplot2 plot
  geom_line(mapping = aes(x=Year,y=Operating_margin)) +
  geom_line(mapping = aes(x=Year,y=(Revenues_Crores/scalecoeff))) +
  scale_y_continuous(
    "Operating Margin",
    sec.axis = sec_axis(~ . * scalecoeff, name = "Revenue Crores")
  )


# https://plotly.com/r/multiple-axes/
library(plotly)

fig <- plot_ly()
# Add traces
fig <- fig %>% add_trace(x = infosys_data$Year, y = infosys_data$Operating_margin, name = "Operating Margin", mode = "lines+markers", type = "scatter")
fig
ay <- list(
  tickfont = list(color = "red"),
  overlaying = "y",
  side = "right",
  title = "<b>secondary</b> yaxis title")

fig <- fig %>% add_trace(x = infosys_data$Year, y = infosys_data$Revenues_Crores, name = "Revenue Crores", yaxis = "y2", mode = "lines+markers", type = "scatter")

# Set figure title, x and y-axes titles
fig <- fig %>% layout(
  title = "Double Y Axis Example", yaxis2 = ay,
  xaxis = list(title="xaxis title "),
  yaxis = list(title="<b>primary</b> yaxis title")
)%>%
  layout(plot_bgcolor='#e5ecf6',
         xaxis = list(
           zerolinecolor = '#ffff',
           zerolinewidth = 2,
           gridcolor = 'ffff'),
         yaxis = list(
           zerolinecolor = '#ffff',
           zerolinewidth = 2,
           gridcolor = 'ffff')
  )
fig