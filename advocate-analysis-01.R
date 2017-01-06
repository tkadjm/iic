## advocate analysis

# *** SETUP ***
rm(list=ls())
install.packages("data.table")
install.packages("doBy")
install.packages("plyr")
install.packages("reshape")

library(doBy)
library(plyr)
library(data.table)
library(reshape)

setwd("/Users/thomaskeane/Documents/github/iic")
iic<-read.csv("iiccase.csv")
iic_clean<-iic
iic_clean[,"Site.Name"]<-sub("-.*", "", iic_clean[,"Site.Name"])

plot(iic[iic$Code.Description=="Ablate Bone Tumor(s) Perq",]$Gross.Coll)
plot(iic[iic$Code.Description=="X-ray Of Lower Spine Disk",]$Gross.Coll)

cdata <- ddply(iic, c("Code.Description"), summarise,
               N    = length(Code.Description),
               average.charge = mean(Gross.Charges),
               sd.charge = sd(Gross.Charges),
               average.collection = mean(Gross.Coll),
               sd.collection = sd(Gross.Coll),
               tot = sum(Gross.Coll)
)
head(cdata)
# write.csv(as.data.table(cdata), "cdata.csv")

ddata <- ddply(iic, c("Doctor.Name.Variable"), summarise,
               N    = length(Code.Description),
               average.charge = mean(Gross.Charges),
               sd.charge = sd(Gross.Charges),
               average.collection = mean(Gross.Coll),
               sd.collection = sd(Gross.Coll),
               tot = sum(Gross.Coll),
               rvus = sum(RVU)
)
head(ddata)
# write.csv(as.data.table(ddata), "ddata.csv")

sdata <- ddply(iic, c("Site.Name"), summarise,
               N    = length(Code.Description),
               average.charge = mean(Gross.Charges),
               sd.charge = sd(Gross.Charges),
               average.collection = mean(Gross.Coll),
               sd.collection = sd(Gross.Coll),
               collections = sum(Gross.Coll)
)
head(sdata)
# write.csv(as.data.table(sdata), "sdata.csv")


site_data<- ddply(iic_clean, c("Site.Name", "Doctor.Name.Variable"), summarise,
               N    = length(Code.Description),
               RVU  = sum(RVU),
               average.charge = mean(Gross.Charges),
               sd.charge = sd(Gross.Charges),
               average.collection = mean(Gross.Coll),
               sd.collection = sd(Gross.Coll),
               collections = sum(Gross.Coll)
)
head(site_data)
write.csv(as.data.table(site_data), "site_data.csv")



