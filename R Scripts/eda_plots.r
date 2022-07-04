library(tidyverse)
library(psych)
library(reshape2)

ins<- read.csv('insurance.csv')
head(ins,3)

##############################################################################################################################

#Basic EDA

#dimensions of the dataframe and data types of each feature 
dim(ins)

options(digits= 10)
ins$bmi<- as.double(ins$bmi)
#ins$expenses<- as.double(ins$expenses)
str(ins)

#descriptive stats of numerical cols, (age,bmi,children,expenses)
nums<- list(ins$age, ins$bmi, ins$children, ins$expenses)
nums_df= data.frame(ins$age, ins$bmi, ins$children, ins$expenses)
str(nums_df)
describe(nums_df)
summary(nums_df)

#distribution of numerical columns and associated skewness
nums_df %>%
  gather() %>%
  ggplot(aes(value)) +
    facet_wrap(~ key, scales= "free") + 
    geom_density()

num_skew= list(skew(nums_df))
num_skew

#outlier detection using boxplots
#boxplot(nums_df, col= rainbow(ncol(nums_df)))
par(mfrow= c(1,ncol(nums_df)))
invisible(lapply(1:ncol(nums_df), function(i) boxplot(nums_df[,i])))
#from here we can see that the bmi and the expenses columns have outliers. 

################################################################################################################

#Data Viusualization

#the mean values of the smokers and nonsmokers might give us an insight into who pays more taxes. 
X <- split(ins$expenses, f= list(ins$smoker))
X
str(X)
no<- data.frame(X[1])
yes<- data.frame(X[2])
means<- c(mean(no$no), mean(yes$yes))
smoker_tax= data.frame(name= c('non-smokers','smokers'),means)
ggplot(smoker_tax,aes(name,means))+
  geom_bar(stat= "identity")+
  geom_text(aes(label= signif(means)))
#from here we can see that the smokers pay more tax than the non-smokers

bmi_mean= mean(ins$bmi)
ds= split(ins$expenses, ins$bmi > bmi_mean)
str(ds)
lower<- data.frame(ds[1])
upper<- data.frame(ds[2])
means_0<- c(mean(lower$FALSE.), mean(upper$TRUE.))
bmi_insurance<- data.frame(name= c('lower bmi', 'higher bmi'), means_0)
ggplot(bmi_insurance,aes(name,means_0))+
  geom_bar(stat= "identity")+
  geom_text(aes(label= signif(means_0)))
#from this we can see that people with higher bmi pay more insurance amount than people with a lower bmi

age_insurance= data.frame(nums_df$ins.age, ins$expenses)
head(age_insurance,5)
X<- split(age_insurance, cut(age_insurance$nums_df.ins.age, c(18,25,34,44,54,64),include.lowest= TRUE))
str(X)
str(X[1])
X1<-data.frame(X$`[18,25]`$ins.expenses)
colnames(X1)<- c('exps')
X2<- data.frame(X$`(25,34]`$ins.expenses)
colnames(X2)<- c('exps')
X3<- data.frame(X$`(34,44]`$ins.expenses)
colnames(X3)<- c('exps')
X4<- data.frame(X$`(44,54]`$ins.expenses)
colnames(X4)<- c('exps')
X5<- data.frame(X$`(54,64]`$ins.expenses)
colnames(X5)<- c('exps')
means<- c(mean(X1$exps),mean(X2$exps),mean(X3$exps),mean(X4$exps),mean(X5$exps))
df<- data.frame(name= c('[18,25]','[25,34]','[34,44]','[44,54]','[54,64]'), means)
df
ggplot(df,aes(name,means))+
  geom_bar(stat= "identity")+
  geom_text(aes(label= signif(means)))
#from this plot we can clearly see that as the age increases, the insurance expenses increase. There is a direct relation.

X <- split(ins$expenses, f= list(ins$region))
X
str(X)
ne<- data.frame(X[1])
nw<- data.frame(X[2])
se<- data.frame(X[3])
sw<- data.frame(X[4])
means<- c(mean(ne$northeast), mean(nw$northwest), mean(se$southeast), mean(sw$southwest))
region_tax= data.frame(name= c('northeast','northwest','southeast','southwest'),means)
ggplot(region_tax,aes(name,means))+
  geom_bar(stat= "identity")+
  geom_text(aes(label= signif(means)))
#from here we can see that the northwest and the southwest regions have similar insurance expenses but the northeast and the southeast have higher expenses.
#we can make out from this that the west regions have lesser insurance expenses than the east region. 

new_df<- data.frame(ins$sex, ins$region, nums_df$ins.expenses)
