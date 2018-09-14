library(dplyr)

#Cleaning up USGS data so that only certain srsname are in the datatable

#rbind notes. Read in the USGS QW and the non-USGS QW data

USGSwaterquality <-read.csv("P:/FPJ00/analysis/Combined_geochem/inputDatasets/qwexport.csv")
Otherlabwaterquality <-read.csv("P:/FPJ00/analysis/Combined_geochem/inputDatasets/gdatmcsvexport.csv")

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
CleanedUSGSWQ <- read.csv('P:/FPJ00/analysis/Combined_geochem/Geochem_DataSet_2/CleanedUSGSWQ.csv')




#then do rbind to put datasets together.
CleanedUSGSWQ$X <- NULL
g.all.3 <- rbind(CleanedUSGSWQ, Otherlabwaterquality)


#Merging. Works the best so far! No repeats and no erasing of dates.
g.all.3 <- merge(g.all.3,siteInfo,by=c("Site_ID", "medium_cd"), all = TRUE, sort = FALSE)

#Get rid of extra Site_ID column
g.all.3$site_no.y <- NULL

#Rename the site_no.x column
names(g.all.3)[names(g.all.3) == "site_no.x"] <- "site_no"


#download a csv file
write.csv(g.all.3, "QwExport3.csv")
