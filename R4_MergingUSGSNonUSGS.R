library(dplyr)

# read site metadata for the well information
siteInfo <- read.csv('P:/FPJ00/analysis/Combined_geochem/inputDatasets/Phase1_2_wellinfo.csv')
siteInfo<-read.csv("P:/FPJ00/analysis/Combined_geochem/inputDatasets/Phase1_2_wellinfo.csv",stringsAsFactors = FALSE)
str(siteInfo)

#the gdat.m data object is from the script RGeochemProj.R
names(gdat.m)
names(siteInfo)


#rbind notes. Read in the USGS QW and the non-USGS QW data

USGSwaterquality <-read.csv("P:/FPJ00/analysis/Combined_geochem/inputDatasets/qwexport.csv")
Otherlabwaterquality <-read.csv("P:/FPJ00/analysis/Combined_geochem/inputDatasets/gdatmcsvexport.csv")


#then do rbind to put datasets together.
g.all.bind <- rbind(USGSwaterquality, Otherlabwaterquality)

#Need to get rid of factors
sapply(g.all.bind, class)
names(g.all.bind)

#dplyr package way to replace all factors
library(dplyr)
g.all.bind %>% mutate_if(is.factor, as.character) -> g.all.bind

#sapply(g.all, class)
#?mutate_if()
#which(sapply(g.all, class) %in% "factor")



#Merging. Works the best so far! No repeats and no erasing of dates.
g.all2 <- merge(g.all.bind,siteInfo,by=c("Site_ID", "medium_cd"), all = TRUE, sort = FALSE)

#Get rid of extra Site_ID column
g.all2$site_no.y <- NULL

#Rename the site_no.x column
names(g.all2)[names(g.all2) == "site_no.x"] <- "site_no"

#download a csv file
write.csv(g.all2, "QwExport2.csv")


#Other scripts that may be useful while getting this data set merged

#filter out the parameters we want for analysis in the USGS data.
USGSwaterquality<-USGSwaterquality[USGSwaterquality$parameter_units!="mg/l NH4",]
USGSwaterquality<-USGSwaterquality[USGSwaterquality$parameter_units!="mg/l asNO3",]
USGSwaterquality<-USGSwaterquality[USGSwaterquality$parameter_units!="code",]
USGSwaterquality<-USGSwaterquality[USGSwaterquality$parameter_units!="tons/ac ft",]
USGSwaterquality<-USGSwaterquality[USGSwaterquality$parameter_nm!="Specific conductance_ water_ unfiltered_ laboratory_ microsiemens per centimeter at 25 degrees Celsius",]
USGSwaterquality<-USGSwaterquality[USGSwaterquality$parameter_nm!="Dissolved solids_ water_ filtered_ sum of constituents_ milligrams per liter",]
USGSwaterquality<-USGSwaterquality[USGSwaterquality$parameter_nm!="Dissolved oxygen_ water_ unfiltered_ percent of saturation",]
#USGSwaterquality$meth_cd[USGSwaterquality$meth_cd=="ALGOR"]<-"USGSNWQL"
write.csv(USGSwaterquality, "CleanedUSGSWQ.csv")
CleanedUSGSWQ <- read.csv('P:/FPJ00/Phase2GeochemistryData/CleanedUSGSWQ.csv')


#then do rbind to put datasets together.
g.all <- rbind(CleanedUSGSWQ, Otherlabwaterquality)



