# Insurance.csv
######  EDA
# Basic EDA
# 1.Find the shape of the data,data type of individual columns
# 2.Descriptive stats of numerical columns
# 3.Find the distribution of numerical columns and the asssociated skeweness
# 4.Are there any outliers for Numeric features (Use Box Plots)
#
# ######## Data Visualization
# Please answer following Queries using
# 1. Does Smokers pay more insurance amount than non smokers? What are your observations ?
# 2. Does People with Higher BMI pay Higher insurance amount thans those with lower BMI ? What are your observations ?
# 3. Can we comment about the effect of age on insurance amount being paid?
# 4. is Some Region paying more insurance charges than other regions ?
# - Box Plot across Regions Among Male/Female or Smoker/NonSmoker
# - is it possible to Customize as per the Given Figure ( Medium/High/Low)
# - Strip Plot Across Regions Among Male/Female or Smoker/NonSmoker
# 5. What is the distribution of charges ? is it skewed ? What are your observations ?
# 6. What's the inference from the Pairplot of Numeric Variables
# 7. Save the Pairplot as Jpeg/SVG files.


library("readr")
library("tidyverse")
library("moments")

insurance_data = read_csv("insurance.csv")
#1.Find the shape of the data,data type of individual columns
dim(insurance_data)
names(insurance_data)
str(insurance_data)

datanum = select_if(insurance_data, is.numeric)
# 2.Descriptive stats of numerical columns
summary(datanum)

#3.Find the distribution of numerical columns and the asssociated skeweness
datanum %>%
  gather() %>%
  group_by(key) %>%
  mutate(skewness = moments::skewness(value),
         label = paste0(key, "\n","Skewness: ", round(skewness, 2))) %>%
  ggplot(aes(value)) +
  facet_wrap(~ label, scales = "free", ncol = 2, strip.position = "bottom") +
  geom_histogram(aes(y = ..density..), binwidth = 1, fill = "grey") +
  geom_density(colour = "black")

# 4.Are there any outliers for Numeric features (Use Box Plots)
FindOutliers <- function(data) {
  lowerq = quantile(data)[2]
  upperq = quantile(data)[4]
  iqr = IQR(data)
  uppThresh = (iqr * 1.5) + upperq
  lowThresh = lowerq - (iqr * 1.5)
  result <- which(data > uppThresh | data < lowThresh)
  return(length(result))
}

datanum %>%
  gather() %>%
  group_by(key) %>%
  mutate(outlier = FindOutliers(value),
         label = paste0(key, "\n","Outliers - ", outlier)) %>%
  ggplot(aes(y=value)) +
  facet_wrap(~ label, scales = "free", ncol = 2, strip.position = "bottom") +
  geom_boxplot()



# ######## Data Visualization
# Please answer following Queries using
# 1. Does Smokers pay more insurance amount than non smokers? What are your observations ?

res = setNames(aggregate(insurance_data['expenses'], list(insurance_data$smoker), mean), c("smoker","mean_insurance_amount"))
res[1,1]="non-smoker"
res[2,1]="smoker"
res
pie(res$mean_insurance_amount, res$smoker, main="Mean Insurace Amount")

# 2. Does People with Higher BMI pay Higher insurance amount thans those with lower BMI ? What are your observations ?

ggplot(insurance_data, aes(bmi, expenses)) +
  geom_point()+
  geom_smooth(method=lm)+
  annotate(x=45, y=60000,
           label=paste("R = ", round(cor(insurance_data$bmi, insurance_data$expenses),3)),
           geom="text", size=4)

# 3. Can we comment about the effect of age on insurance amount being paid?

ggplot(insurance_data, aes(age, expenses)) +
  geom_point()+
  geom_smooth(method=lm)+
  annotate(x=45, y=60000,
           label=paste("R = ", round(cor(insurance_data$age, insurance_data$expenses),3)),
           geom="text", size=4)

# 4. is Some Region paying more insurance charges than other regions ?

res = setNames(aggregate(insurance_data['expenses'], list(insurance_data$region), mean), c("region","mean"))
res= merge(setNames(aggregate(insurance_data['expenses'], list(insurance_data$region), sum), c("region","sum")), res)
res
ggplot(res, aes(region, sum)) +
  geom_bar(stat= "identity")+
  geom_text(aes(label= signif(mean)))

# - Box Plot across Regions Among Male/Female or Smoker/NonSmoker
insurance_data %>%
  group_by(region) %>%
  ggplot() +
  facet_wrap(~region, scales = "free", ncol = 2) +
  geom_boxplot(aes(color=sex))


# 5. What is the distribution of charges ? is it skewed ? What are your observations ?
ggplot(insurance_data, aes(expenses)) +
  geom_density(colour = "black")+
  annotate(x=40000, y=4e-05,
           label=paste("Skewness = ", moments::skewness(insurance_data$expenses)),
                                          geom="text", size=4)

# 6. What's the inference from the Pairplot of Numeric Variables
library(GGally)
ggpairs(data=datanum)+theme_bw()

# 7. Save the Pairplot as Jpeg/SVG files.
jpeg("tips_pairs_plot.jpg")