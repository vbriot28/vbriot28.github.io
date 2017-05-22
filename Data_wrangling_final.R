# Data 608_final Project data wrangling

#Data that we will be exploring can be found on NYC Open Data portal:
#  https://data.cityofnewyork.us/Public-Safety/The-Stop-Question-and-Frisk-Data/ftxv-d5ix

#Follow the external link

#In addition, NYC population information was used that can be found at:
#  http://www1.nyc.gov/site/planning/data-maps/nyc-population/american-community-survey.page

------------------------------------------------------------------------------------

library(dplyr)

# Import data for years 2013 - 2016, which are focus of our visualization
df_2003 <- read.csv("data/2003_sqf.csv", header = TRUE, sep = "," ) 
df_2004 <- read.csv("data/2004_sqf.csv", header = TRUE, sep = "," ) 
df_2005 <- read.csv("data/2005_sqf.csv", header = TRUE, sep = "," ) 
df_2006 <- read.csv("data/2006_sqf.csv", header = TRUE, sep = "," ) 
df_2007 <- read.csv("data/2007_sqf.csv", header = TRUE, sep = "," ) 
df_2008 <- read.csv("data/2008_sqf.csv", header = TRUE, sep = "," ) 
df_2009 <- read.csv("data/2009_sqf.csv", header = TRUE, sep = "," ) 
df_2010 <- read.csv("data/2010_sqf.csv", header = TRUE, sep = "," ) 
df_2011 <- read.csv("data/2011_sqf.csv", header = TRUE, sep = "," ) 
df_2012 <- read.csv("data/2012_sqf.csv", header = TRUE, sep = "," ) 
df_2013 <- read.csv("data/2013_sqf.csv", header = TRUE, sep = "," ) 
df_2014 <- read.csv("data/2014_sqf.csv", header = TRUE, sep = "," ) 
df_2015 <- read.csv("data/2015_sqf.csv", header = TRUE, sep = "," ) 
df_2016 <- read.csv("data/2016_sqf.csv", header = TRUE, sep = "," ) 

# correct column name for year for 2016 data set
names(df_2016)[1] <- "year"


# Data set for first visualization Year, City, Race, , age, stop
df_2003_1 <- select(df_2003, year, city, sex, race, age)
df_2004_1 <- select(df_2004, year, city, sex, race, age)
df_2005_1 <- select(df_2005, year, city, sex, race, age)
df_2006_1 <- select(df_2006, year, city, sex, race, age)
df_2007_1 <- select(df_2007, year, city, sex, race, age)
df_2008_1 <- select(df_2008, year, city, sex, race, age)
df_2009_1 <- select(df_2009, year, city, sex, race, age)
df_2010_1 <- select(df_2010, year, city, sex, race, age)
df_2011_1 <- select(df_2011, year, city, sex, race, age)
df_2012_1 <- select(df_2012, year, city, sex, race, age)
df_2013_1 <- select(df_2013, year, city, sex, race, age)
df_2014_1 <- select(df_2014, year, city, sex, race, age)
df_2015_1 <- select(df_2015, year, city, sex, race, age)
df_2016_1 <- select(df_2016, year, city, sex, race, age)

df_list <- list(df_2003_1, df_2004_1, df_2005_1, df_2006_1, df_2007_1, df_2008_1, df_2009_1, df_2010_1, df_2011_1, df_2012_1, df_2013_1, df_2014_1, df_2015_1, df_2016_1)

df_d <- do.call(rbind, df_list )

# Build Data set with years only and remove NA (1 record)
df_d1 <- df_d %>% filter(!is.na(year)) %>% select(year)

data1 <- df_d1 %>% group_by(year) %>% summarise(stops=n())
write.csv(data1, file = "data for visualization/data1.csv", row.names=FALSE)


df_list2 <- list(df_2006_1, df_2007_1, df_2008_1, df_2009_1, df_2010_1, df_2011_1, df_2012_1, df_2013_1, df_2014_1, df_2015_1)
df_d2 <- do.call(rbind, df_list2)

# convert city to character and streamline name
df_d2$city <- as.character((df_d2$city))
df_d2$city[df_d2$city == 'BRONX'] <- 'Bronx'
df_d2$city[df_d2$city == 'BROOKLYN'] <- 'Brooklyn'
df_d2$city[df_d2$city == 'MANHATTAN'] <- 'Manhattan'
df_d2$city[df_d2$city == ' MANHATTAN'] <- 'Manhattan'
df_d2$city[df_d2$city == 'QUEENS'] <- 'Queens'
df_d2$city[df_d2$city == 'STATEN IS'] <- 'Staten_Island'
df_d2$city[df_d2$city == 'STATEN ISLAND'] <- 'Staten_Island'

# Only Select records with city specified (records ignored)
df_d2 <- df_d2 %>% filter(city=='Bronx' | city=='Brooklyn' | city=='Manhattan' | city =='Queens' | city =='Staten Island')

data2 <- df_d2 %>% group_by(year, city) %>% summarise(stops=n())

write.csv(data2, file = "data for visualization/data2.csv", row.names=FALSE)

#---------------------------------------------------------------------------#

# Build .csv for number of stops by Race

# Filter race that is unknown

df_d2_r <- df_d2 %>% filter(race != 'U') 

# Collapse hispanic population P & Q into one category H
df_d2_r$race <- as.character(df_d2_r$race)
df_d2_r$race[df_d2_r$race == 'P'] <- 'H'
df_d2_r$race[df_d2_r$race == 'Q'] <- 'H'

df_d3_r <- df_d2_r %>% group_by(year, city, race) %>% summarise(cnt=n())

df_tmp <- ungroup(df_d3_r)

d <- df_tmp %>% group_by(year, race) %>% summarise(city ='New York', cnt=sum(cnt))
d1 <- d[c('year','city','race','cnt')]
df_tmp2 <- rbind.data.frame(df_tmp, d1)

df_tmp2$type <- 'stops'

df_tmp3 <- df_tmp2  %>%  group_by(year,city) %>% mutate(perc_stops = round(cnt/sum(cnt)*100,1))
names(df_tmp3)[4] <- "cnt_stops" 

#This .csv file is derived from NYC population data
#data extracted manually from pdf
df_pop <- read.csv("data_final/population_percentage.csv", header = TRUE, sep = "," ) 


df_pop <- df_pop %>% select(year, city, race, cnt, percentage)
names(df_pop)[4] <- "cnt_pop" 
names(df_pop)[5] <- "perc_pop" 


#df_tmp4 <- rbind.data.frame(df_tmp3,df_pop)

df_tmp4 <- inner_join(df_tmp3, df_pop, by=c('year', 'city', 'race'))
df_tmp4$cnt_pop <- as.numeric((df_tmp4$cnt_pop))

df_tmp4$race <- as.character((df_tmp4$race))
df_tmp4$race[df_tmp4$race == 'A'] <- 'Asian'
df_tmp4$race[df_tmp4$race == 'B'] <- 'Black'
df_tmp4$race[df_tmp4$race == 'H'] <- 'Hispanic'
df_tmp4$race[df_tmp4$race == 'I'] <- 'Native American'
df_tmp4$race[df_tmp4$race == 'W'] <- 'White'
df_tmp4$race[df_tmp4$race == 'Z'] <- 'Other'

#write.csv(data3, file = "data for visualization/data3.csv", row.names=FALSE)
write.csv(df_tmp4, file = "data for visualization/data3_p1.csv", row.names=FALSE)

#---------------------------------------------------------------------------

df_2006_2 <- select(df_2006, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
df_2007_2 <- select(df_2007, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
df_2008_2 <- select(df_2008, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
df_2009_2 <- select(df_2009, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
df_2010_2 <- select(df_2010, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
df_2011_2 <- select(df_2011, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
df_2012_2 <- select(df_2012, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
df_2013_2 <- select(df_2013, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
df_2014_2 <- select(df_2014, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
df_2015_2 <- select(df_2015, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)
#df_2016_2 <- select(df_2016, year, city, race, arstmade, sumissue, adtlrept, pistol, contrabn, riflshot, asltweap, knifcuti, machgun, othrweap)

tp_list2 <- list(df_2006_2, df_2007_2, df_2008_2, df_2009_2, df_2010_2, df_2011_2, df_2012_2, df_2013_2, df_2014_2, df_2015_2)

tp <- do.call(rbind, tp_list2)


# convert city to character and streamline name
tp$city <- as.character((tp$city))
tp$city[tp$city == 'BRONX'] <- 'Bronx'
tp$city[tp$city == 'BROOKLYN'] <- 'Brooklyn'
tp$city[tp$city == 'MANHATTAN'] <- 'Manhattan'
tp$city[tp$city == ' MANHATTAN'] <- 'Manhattan'
tp$city[tp$city == 'QUEENS'] <- 'Queens'
tp$city[tp$city == 'STATEN IS'] <- 'Staten_Island'
tp$city[tp$city == 'STATEN ISLAND'] <- 'Staten_Island'

# Only Select records with city specified (records ignored)
tp_out <- tp %>% filter(city=='Bronx' | city=='Brooklyn' | city=='Manhattan' | city =='Queens' | city =='Staten Island')

tp_1 <- mutate(tp_out, outcome = (arstmade=='Y' | sumissue == 'Y' | adtlrept == 'Y' | pistol == 'Y' | contrabn == 'Y'| riflshot == 'Y' | asltweap == 'Y' | knifcuti == 'Y'| machgun == 'Y' | othrweap=='Y'))


tp_2 <- select(tp_1, year, city, race, outcome)

tp_2 <- tp_2 %>% filter(race != 'U') 
tp_2$race <- as.character(tp_2$race)

tp_2$race[tp_2$race == 'P'] <- 'H'
tp_2$race[tp_2$race == 'Q'] <- 'H'

tp_2$race[tp_2$race == 'A'] <- 'Asian'
tp_2$race[tp_2$race == 'B'] <- 'Black'
tp_2$race[tp_2$race == 'H'] <- 'Hispanic'
tp_2$race[tp_2$race == 'I'] <- 'Native American'
tp_2$race[tp_2$race == 'W'] <- 'White'
tp_2$race[tp_2$race == 'Z'] <- 'Other'

tp_3 <- tp_2 %>% group_by(year, city, race) %>% summarise(positive=sum(outcome), cnt=n()) %>%  mutate(negative = cnt-positive)

tp_tmp <- ungroup(tp_3)

t <- tp_tmp %>% group_by(year, race) %>% summarise(city ='New York', positive=sum(positive), cnt=sum(cnt))
t <- t %>% mutate(negative = cnt-positive)

tp_4 <- t[c('year','city','race', 'positive', 'cnt', 'negative')]

tp_5 <- rbind.data.frame(tp_3, tp_4)

tp_6 <- tp_5  %>%  group_by(year,city) %>% mutate(perc_positive = round(positive/sum(cnt)*100,1))


tp_7 <- tp_6 %>% select(year, city, race, positive, perc_positive)


data3 <-inner_join(df_tmp4, tp_7, by=c('year', 'city', 'race'))
names(data3)[8] <- "cnt_positive"

write.csv(data3, file = "data for visualization/data3_p2.csv", row.names=FALSE)

tp_8 <- tp_5  %>%  group_by(year,city) %>% mutate(perc_positive = round(positive/sum(positive)*100,1), perc_negative = round(negative/sum(negative)*100,1))


write.csv(tp_8, file = "data for visualization/data4.csv", row.names=FALSE)



