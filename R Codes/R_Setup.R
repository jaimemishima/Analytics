# This document contains basic R codes for a reference use

# Set Working directory
setwd("~/Desktop/Jaime/MBA/R Codes")

# Show working directory
getwd()

# Function example show examples of a function
example(getwd)

# Vector in R
vector_name <- c(1, "string")
vector_name

# Create a 5x4 matrix
exemplo_matriz <- matrix(1:20, nrow = 5, ncol = 4)
exemplo_matriz


# Create a vector com 4 Brazilian States
estado <- c("SP", "RJ", "RS", "PR")

# Create a vector with the population of those states
populacao <- c(45094866, 16718956, 11322895, 11320892)

# Create a dataframe joining both vectors
pop_estados <- data.frame(estado, populacao)
pop_estados
class(pop_estados)
class(pop_estados$estado)
class(pop_estados$populacao)

#Creating functions in R
maior<-function(a,b){if(a<b){return(b)}else{return(a)}}
a<-4
b<-10
maior(a,b)


#Installing packages
install.packages("readxl")
library(readxl)


# Install and load a bunch of different packages
R_packages <- c(
  "randomForest", "neuralnet", "caret", "dplyr", "tidyverse", "sqldf", "RgoogleMaps", "psych", "readxl", "logistf",
  "lubridate", "magrittr", "Information", "arules", "smbinning", "cluster", "flexclust", "ggdendro", "dgof", "descr", "pROC", "gains",
  "ROCR", "randomForest", "keras", "neuralnet", "forecast", "reshape", "scorecard", "mlogit", "e1071", "igraph", "corrplot", "gbm", "tree", "RWeka", "lars", "mboost",
  "sas7bdat", "manipulate", "knitr", "jsonlite", "rvest", "tidyr", "ggplot2", "flexdashboard", "gmodels",
  "plotly", "RSQLite", "tm", "SnowballC", "Wordcloud", "Syuzhet", "quanteda", "olsrr", "HH", "DAAG", "bootstrap", "Amelia", "pscl", "ISLR", "tree", "rpart", "rattle"
)

install.packages(R_packages)

# Load all those packages in a row
lapply(R_packages, library, character.only = TRUE)

#Built-in datasets in R
data()

#Viewing mtcars dataframe
mtcars
View(mtcars)
str(mtcars)

#Basic operations with mtcars dataframe
nrow(mtcars) # Show amount of lines to table mtcars
ncol(mtcars) # Show amount of columns to table mtcars
mtcars_first5lines <- mtcars[1:5, ] # Filter first 5 rows and all columns of table mtcars
mtcars_filter1 <- subset(mtcars, mpg > 20 & cyl > 4) # Selectrows with mpg>20 and cyl>4
mtcars_filter1 # Show object mtcars_filter1
mtcars_filter2 <- subset(mtcars, hp > 200 | wt >= 3.570) # Select rows with wt>200 or wt>3.9
mtcars_filter2 # Show object mtcars_filter1
mtcars_filter3 <- subset(mtcars, carb == 8) # Select rows with carb=8
mtcars_filter3 # Show object mtcars_filter3
mtcars_filter4 <- subset(mtcars, carb == 8, select = c(carb, mpg)) # Select rows with carb=8, retaining just columns carb and mpg
mtcars_filter4 # Show object mtcars_filter4
mtcars_filter5 <- subset(mtcars, carb == 8, select = -c(carb, mpg)) # Select rows with carb=8, keeping all variables, except carb and mpg
mtcars_filter5 # Show object mtcars_filter5
amostra_mtcars <- mtcars[sample(1:nrow(mtcars), 10, replace = FALSE), ] # Select a sample of 10 rows of table mtcars
amostra_mtcars # Show object amostra_mtcars
summary(mtcars) # Show a summary of quantitative variable of table mtcars
summary(mtcars$mpg) # Show a summary of the variable mpg
describeBy(mtcars$mpg, mtcars$cyl) # Descriptive summarization of mpf variable, by cyl variable
quantile(mtcars$hp) # Calculate some descriptive statistics to hp variable
quantile(mtcars$hp, seq(0, 1, 0.25)) # Calculate hp quartiles, from table mtcars
quantile(mtcars$hp, seq(0, 1, 0.1)) # Calculate hp deciles, from table mtcars


#mpg histogram plot
hist(mtcars$mpg, col=rainbow(12))

#Importing a csv file
germancredit<-read.csv("german_credit_data.csv", sep=",")
View(germancredit)

#Importing a xslx file
library(readxl)
HR_Analytics<-read_excel("HR_Analytics.xlsx", sheet="Plan1")
View(HR_Analytics)

#Estimating processing time
system.time(flights<-read.csv("BrFlights2.csv", sep=","))
View(flights)
remove(flights)
install.packages("data.table")
library(data.table)
system.time(flights<-fread("BrFlights2.csv"))

#Exporting frames to Excel
install.packages("XLConnect")
library(XLConnect)
writeWorksheetToFile("mtcars.xlsx", mtcars, sheet="mtcars_R", header=TRUE)

modelo_mtcars<-lm(mpg ~ wt, data=mtcars)
writeWorksheetToFile("modelo_mtcars.xlsx", data=as.data.frame(summary(modelo_mtcars)$coef),
                                                              sheet="summary", header=TRUE)


#Working with dates in R
install.packages("lubridate")
library(lubridate)
admiss<-read_excel("Datas.xlsx", sheet="Plan1")
View(admiss)
day(admiss$Dt_Admissao)
month(admiss$Dt_Admissao)
year(admiss$Dt_Admissao)
admiss$Fim_EXper<-admiss$Dt_Admissao+90
admiss$Fim_EXper1<-as.Date(admiss$Dt_Admissao)+90
View(admiss)
Sys.Date()
admiss$tp_admiss_day<-difftime(Sys.Date(),admiss$Dt_Admissao, units="days")
admiss$tp_admiss_month<-round((difftime(Sys.Date(),admiss$Dt_Admissao, units="days")/30),0)
admiss$tp_admiss_year<-round((difftime(Sys.Date(),admiss$Dt_Admissao, units="days")/365),0)
View(admiss)
admiss$dia_semana<-wday(admiss$Dt_Admissao)
View(admiss)

#Data Filtering
mtcars_filter1 <- subset(mtcars, mpg > 20 & cyl > 4) # Select rows with mpg>20 and cyl>4
mtcars_filter2 <- subset(mtcars, hp > 200 | wt >= 3.570) # Select rows with wt>200 or wt>3.9
mtcars_filter3 <- subset(mtcars, carb == 8) # Select rows with carb=8
mtcars_filter4 <- subset(mtcars, carb == 8, select = c(carb, mpg)) # Select rows with carb=8, 
#retaining just columns carb and mpg
mtcars_filter5 <- subset(mtcars, carb == 8, select = -c(carb, mpg)) # Select rows with carb=8, 
#keeping all variables,except carb and mpg


#Using tidyverse concept in R
install.packages("tidyverse")
library(tidyverse)
#Renamings variables in R
admiss<-rename(admiss, Data_de_admissao=Dt_Admissao, 
               Data_de_Referencia=Referencia)
View(admiss)


# Importing TopBabyNamesbyState.csv
TopBabyNamesByState <- read.csv("TopBabyNamesbyState.csv")
# View imported dataframe
View(TopBabyNamesByState)

# Tamanho do historico temporal (Variavel YEAR)
summary(TopBabyNamesByState$Year)

# Most frequent names - ARIZONA STATE
TopBabyNamesByState %>%
  filter(State == "AZ") %>%
  group_by(Top.Name) %>%
  summarise(soma = sum(Occurences)) %>%
  arrange(-soma) %>%
  head(3)

# Most frequent names - DELAWARE STATE
TopBabyNamesByState %>%
  filter(State == "DE") %>%
  group_by(Top.Name) %>%
  summarise(soma = sum(Occurences)) %>%
  arrange(-soma) %>%
  head(3)

# Most frequent names - KENTUCKY STATE
TopBabyNamesByState %>%
  filter(State == "KY") %>%
  group_by(Top.Name) %>%
  summarise(soma = sum(Occurences)) %>%
  arrange(-soma) %>%
  head(3)


# Most Frequent Female Names - 1980 a 2010
TopBabyNamesByState %>%
  filter(Year >= 1980 & Year <= 2010 & Gender == "F") %>%
  group_by(Top.Name) %>%
  summarise(soma = sum(Occurences)) %>%
  arrange(-soma) %>%
  head(5)

# Most Frequent Female Names - 1960 a 1979
TopBabyNamesByState %>%
  filter(Year >= 1960 & Year <= 1979 & Gender == "F") %>%
  group_by(Top.Name) %>%
  summarise(soma = sum(Occurences)) %>%
  arrange(-soma) %>%
  head(5)


# Importing sheet Plan1 from Video_Game_Sales
VideoGameSales <- read_excel("Video_GAme_Sales.xlsx", sheet = "Plan1")
View(VideoGameSales)

# Amount of sales by decade
table(VideoGameSales$Year)
VideoGameSales$Decada <- ifelse(VideoGameSales$Year <= 1989, "01_1980 a 1989",
                                ifelse(VideoGameSales$Year <= 1999, "02_1990 a 1999",
                                       ifelse(VideoGameSales$Year <= 2009, "03_2000 a 2009",
                                              ifelse(VideoGameSales$Year <= 2017, "04_2010 a 2017", "05_Sem info")
                                       )
                                )
)


VideoGameSales %>%
  group_by(Decada) %>%
  summarise(Total_Vendas = sum(Global_Sales)) %>%
  arrange(Total_Vendas)

VideoGameSales %>%
  summarise(
    Media_Vendas_EU = mean(EU_Sales),
    Media_Vendas_NA = mean(NA_Sales),
    Media_Vendas_JP = mean(JP_Sales),
    Media_Vendas_Other = mean(Other_Sales)
  )


# Soldest games by region between 2012 e 2016 - NA (NORTH AMERICA)
VideoGameSales %>%
  filter(Year >= 2012 & Year <= 2016) %>%
  group_by(Name) %>%
  summarise(Vendas_NA = sum(NA_Sales)) %>%
  arrange(-Vendas_NA) %>%
  head(5)

# Soldest games by region between 2012 e 2016 - EU (EUROPE)
VideoGameSales %>%
  filter(Year >= 2012 & Year <= 2016) %>%
  group_by(Name) %>%
  summarise(Vendas_EU = sum(EU_Sales)) %>%
  arrange(-Vendas_EU) %>%
  head(5)

# Soldest games by region between 2012 e 2016 - JP (JAPAN)
VideoGameSales %>%
  filter(Year >= 2012 & Year <= 2016) %>%
  group_by(Name) %>%
  summarise(Vendas_JP = sum(JP_Sales)) %>%
  arrange(-Vendas_JP) %>%
  head(5)

# Soldest games by region between 2012 e 2016 - OTHER (OTHER REGIONS)
VideoGameSales %>%
  filter(Year >= 2012 & Year <= 2016) %>%
  group_by(Name) %>%
  summarise(Vendas_OT = sum(Other_Sales)) %>%
  arrange(-Vendas_OT) %>%
  head(5)

# Soldest games by genre  - NA (NORTH AMERICA)
VideoGameSales %>%
  group_by(Genre) %>%
  summarise(Vendas_NA = sum(NA_Sales)) %>%
  arrange(-Vendas_NA) %>%
  head(5)

# Soldest games by genre - EU (EUROPE)
VideoGameSales %>%
  group_by(Genre) %>%
  summarise(Vendas_EU = sum(EU_Sales)) %>%
  arrange(-Vendas_EU) %>%
  head(5)

# Soldest games by genre - JP (JAPAN)
VideoGameSales %>%
  group_by(Genre) %>%
  summarise(Vendas_JP = sum(JP_Sales)) %>%
  arrange(-Vendas_JP) %>%
  head(5)

# Soldest games by genre - OT (OTHER REGIONS)
VideoGameSales %>%
  group_by(Genre) %>%
  summarise(Vendas_OT = sum(Other_Sales)) %>%
  arrange(-Vendas_OT) %>%
  head(5)


#Random sampling ina  dataframe
amostra_mtcars <- mtcars[sample(1:nrow(mtcars), 10, replace = FALSE), ] # Select a sample of 10 rows of table mtcars
amostra_mtcars # Show object amostra_mtcars
View(amostra_mtcars)


#Deduplicating data in R
A1<-c("A", "A", "A", "B", "B", "B", "C", "C")
A2<-c(1,1,2,4,1,1,2,2)
dados<-data.frame(A1,A2)
View(dados)
duplicated(dados)
dados[duplicated(dados),]
dados[!duplicated(dados),]
View(unique(dados))

#Ordering data in R
set.seed(1)
data<-data.frame(w=rep(c("A","B"),2), x=rep(c("D","C"),2), 
                 y=rnorm(4), z=rnorm(4), stringsAsFactors = FALSE)
View(data)
arrange(data, desc(z))
arrange(data, desc(w),desc(z))

#Generating random data in R
megasena<-View(as.data.frame(t(replicate(sort(sample(1:60,6, replace=FALSE)), n=1000))))
View(megasena)

#Uso da distribuicao uniforme para geracao de numeros aleatorios
amostra_100mil<-runif(100000,0,1)
amostra_100mil
summary(amostra_100mil)


# Create data sequence
seq(from = 1, to = 5, by = 2)
seq(from = 100, to = 0, by = -10)
rep(1, times = 20)
sequencia_0_15 <- 0:15
sequencia_0_15
sequencia_9_0 <- 9:0
sequencia_9_0

#Adding variables to a dataframe
#Method I - data.frame()
base<-data.frame(renda1=rnorm(5000,500,26), renda2=rnorm(5000,7500,1400))
View(base)
renda3<-rnorm(5000,10000,3100)
base<-data.frame(base, renda3)
View(base)
base<-base[c(-3)]
View(base)
#Method II - cbind()
base<-cbind(base, renda3)
View(base)
base<-base[c(-3)]
View(base)
#Method III - Using operator $
base$renda3<-rnorm(5000,10000,3100)
View(base)

#Removing variables from a dataframe, musing dplyr
excluir<-c('renda2', 'renda3')
base<-dplyr::select(base,-which(names(base) %in% excluir))
View(base)

#Selecting variables from a dataframe, musing dplyr
View(mtcars)
manter<-c("mpg", "wt", "carb", "cyl")
mtcars_select<-dplyr::select(mtcars, which(names(mtcars) %in% manter))
View(mtcars_select)

#Generating frequency tables
set.seed(1337)
sex<-sample(c("Man", "Woman"), 100, replace=TRUE)
jazz<-sample(c(0,1), 100, replace=TRUE)
rock<-sample(c(TRUE, FALSE), 100, replace=TRUE)
electronic<-sample(c("Y", "N"), 100, replace=TRUE)
weights<-runif(100)*2
df<-data.frame(sex,jazz,rock,electronic, weights)  
View(df)
table(df$sex)
prop.table(table(df$sex))
table(df$jazz)
prop.table(table(df$jazz))
table(df$rock)
prop.table(table(df$rock))
table(df$electronic)
prop.table(table(df$lectronic))
df1<-data.frame(sex=df$sex, jazz=df$jazz, rock=df$rock,electronic=df$electronic)
apply(df1,2,table)

#Identifying and recoding missing values
vetor<-c(1,2,3,4,5,NA)
is.na(vetor)
Name<-c("John", "Tim", NA)
Sex<-c("Man", "Man", "Woman")
Age<-c(45,53,NA)
dt<-data.frame(Name, Sex, Age)
View(dt)
sum(is.na(dt))
mean(is.na(dt))
dt$Age[is.na(dt$Age)]<-0
View(dt)

#Removing missing data
Name<-c("John", "Tim", NA)
Sex<-c("Man", "Man", "Woman")
Age<-c(45,53,NA)
dt<-data.frame(Name, Sex, Age)
View(dt)
dt<-na.omit(dt)
View(dt)

#Intro to Cluster Analysis
wines<-read_excel("wines.xlsx", sheet="Plan1")
View(wines)
install.packages("cluster")
install.packages("cluster")
library(cluster)
library(flexclust)
wine_standard<-scale(wines)
View(wine_standard)

kmeans_wine<-kmeans(wine_standard,3)
attributes(kmeans_wine)

kmeans_wine$cluster
kmeans_wine$size

clusplot(wine_standard, kmeans_wine$cluster,
         main = "Representacao dos clusters",
         color = TRUE, shade = TRUE,
         labels = 2, lines = 0)

concordancia <- table(wines$type, kmeans_wine$cluster)
concordancia
randIndex(concordancia)

# Clusterize wine dataframe using hierachical cluster method
distancia <- dist(as.matrix(wine_standard))
hc <- hclust(distancia)
plot(hc)
plot(hc, hang = -1)

# Clusterize mtcars dataframe using hierachical cluster method
distancia <- dist(as.matrix(mtcars))
hc <- hclust(distancia)
plot(hc)
plot(hc, hang = -1)

# Create a dendrogram, using ggdendro package
install.packages("ggdendro")
library(ggdendro)
ggdendrogram(hc, rotate = TRUE, size = 4, theme_dendro = FALSE, color = "tomato")

#Boosting predictive models with cluster analysis
HR<-read_excel("HR_Analytics.xlsx", sheet="Plan1")
View(HR)
#General churn risk model
modelo<-glm(left ~ ., family = binomial (link = 'logit'), data=HR[,2:11])
summary(modelo)
HR_pred<-predict(modelo, HR, type="response")
HR<-data.frame(HR, HR_pred)
View(HR)
install.packages("dgof")
library(dgof)
ks.test(HR$HR_pred[HR$left==0],
        HR$HR_pred[HR$left==1])
#Testing segmented models, using clusterization made on IBM Statistics
install.packages("foreign")
library(foreign)
HR_cluster<-read.spss("HR_Analytics_Cluster.sav", to.data.frame=TRUE)
View(HR_cluster)
HR_cluster_I<-subset(HR_cluster, HR_cluster$QCL_1==1)
HR_cluster_II<-subset(HR_cluster, HR_cluster$QCL_1==2)
HR_cluster_III<-subset(HR_cluster, HR_cluster$QCL_1==3)

modelo_cluster_I<-glm(left ~ ., family = binomial (link = 'logit'), data=HR_cluster_I[,2:11])
HR_pred_cluster_I<-predict(modelo_cluster_I, HR_cluster_I, type="response")
HR_cluster_I<-data.frame(HR_cluster_I,HR_pred_cluster_I )
View(HR_cluster_I)
ks_cluster_I<-ks.test(HR_cluster_I$HR_pred_cluster_I[HR_cluster_I$left==0],
        HR_cluster_I$HR_pred_cluster_I[HR_cluster_I$left==1])

modelo_cluster_II<-glm(left ~ ., family = binomial (link = 'logit'), data=HR_cluster_II[,2:11])
HR_pred_cluster_II<-predict(modelo_cluster_II, HR_cluster_II, type="response")
HR_cluster_II<-data.frame(HR_cluster_II,HR_pred_cluster_II )
View(HR_cluster_II)
ks_cluster_II<-ks.test(HR_cluster_II$HR_pred_cluster_II[HR_cluster_II$left==0],
        HR_cluster_II$HR_pred_cluster_II[HR_cluster_II$left==1])

modelo_cluster_III<-glm(left ~ ., family = binomial (link = 'logit'), data=HR_cluster_III[,2:11])
HR_pred_cluster_III<-predict(modelo_cluster_III, HR_cluster_III, type="response")
HR_cluster_III<-data.frame(HR_cluster_III,HR_pred_cluster_III )
View(HR_cluster_III)
ks_cluster_III<-ks.test(HR_cluster_III$HR_pred_cluster_III[HR_cluster_III$left==0],
        HR_cluster_III$HR_pred_cluster_III[HR_cluster_III$left==1])

#Weighted K-S
round(((nrow(HR_cluster_I)*ks_cluster_I$statistic + 
nrow(HR_cluster_II)*ks_cluster_II$statistic +
nrow(HR_cluster_III)*ks_cluster_III$statistic)/nrow(HR_cluster)),4)










