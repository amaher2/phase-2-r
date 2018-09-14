library(dataRetrieval)

#this is all of the site IDs from phase 1 and phase 2
sites<-c("450814094315001",
         "450814094315002",
         "450814094315003",
         "450814094315004",
         "450814094315006",
         "450832094321201",
         "450832094321202",
         "450832094321203",
         "450832094321204",
         "450832094321205",
         "450832094321206",
         "450821094320601",
         "450837094321601",
         "450820094320801",
         "450828094320601",
         "450851094321201",
         "464110092531401",
         "464110092531402",
         "464110092531403",
         "464112092531401",
         "464112092531402",
         "464112092531403",
         "464112092531404",
         "464112092531405",
         "464109092530701",
         "464111092531401",
         "465652094394801",
         "465652094394802",
         "465652094394803",
         "465652094394804",
         "465653094394701",
         "465651094394001",
         "465652094394701",
         "465652094394501",
         "465711094392601",
         "465712094404201",
         "465725094403207",
         "444630095002202",
         "444630095002203",
         "444630095002204",
         "444630095002205",
         "444630095002206",
         "444630095002207",
         "444630095002208",
         "444630095002209",
         "444630095002201",
         "444630095002201",
         "444639095002201",
         "444639095002201",
         "444639095002201",
         "444637095013701")

qw<-readNWISqw(siteNumber=sites, parameterCd="All",expanded=TRUE,startDate="",endDate="",tz="America/Chicago")

#qw has all of the data in it in a long format.  This is what you will use to append to the dataset we just built with
#data from the other labs.  

#view all USGS parameter codes
pcode<-readNWISpCode(parameterCd="all")
names(pcode)
head(pcode)
#subset to just the pcodes in our data set
pcode.sub<-pcode[(which(pcode$parameter_cd %in% unique(qw$parm_cd))),]
#add "x" to parameter_cd column so leading 0's don't get deleted in excel csv file.
pcode.sub$parameter_cd<-paste("x",pcode.sub$parameter_cd,sep="")

#then I suggest exporting this pcode.sub file 
write.csv(pcode.sub,file="FPJ_pcodes.csv")
#open in excel and add a column of names (named "analyte" perhaps) that are more datbase/R friendly (for example: NO3NO2_mgl)
#make sure the name matches other names that you already assigned in other data sets.
#You may want to review the srsname column, maybe some of these will work for you. 

#you will then have to reimport your edited version
pcode.sub.edit<-read.csv(file="P:/FPJ00/analysis/Combined_geochem/Geochem_DataSet_2/FPJ_pcodes.csv",header=TRUE,sep=",")

#remove the x
pcode.sub.edit$parameter_cd<-gsub(pattern = "x",replacement = "",x=pcode.sub.edit$parameter_cd)

#and merge it with your qw file so that user friendly names can become columns names when you make your data set wide. 
qw<-merge(x=qw, y=pcode.sub.edit,by.x = "parm_cd",by.y="parameter_cd",all.x = TRUE)

#then decide which columns you want to keep for the final data set for making graphs and figures.  

#then check for factor columns, if so, change to character.  

qw$casrn <- NULL
qw$parameter_group_nm <- NULL
qw$X <- NULL
qw$sample_start_time_datum_cd <- NULL
qw$startDateTime <- NULL
qw$result_lab_cm_tx <- NULL
qw$anl_dt <- NULL
qw$anl_set_no <- NULL
qw$prep_dt <- NULL
qw$prep_set_no <- NULL
qw$rpt_lev_cd <- NULL
qw$dqi_cd <- NULL
qw$val_qual_tx <- NULL
qw$sample_lab_cm_tx <- NULL
qw$hyd_event_cd <- NULL
qw$samp_type_cd <- NULL
qw$hyd_cond_cd <- NULL
qw$body_part_id <- NULL
qw$tu_id <- NULL
qw$aqfr_cd <- NULL
qw$project_cd <- NULL
qw$tm_datum_rlbty_cd <- NULL
qw$sample_start_time_datum_cd_reported <- NULL
qw$sample_end_tm <- NULL
qw$sample_end_dt <- NULL
qw$sample_tm <- NULL
qw$lab_std_va <- NULL
qw$parm_cd <- NULL
qw$agency_cd <- NULL


#export csv
write.csv(qw, "qwexport.csv")



