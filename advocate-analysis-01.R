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

code_data <- ddply(iic, c("Code.Description"), summarise,
               N    = length(Code.Description),
               average.charge = mean(Gross.Charges),
               sd.charge = sd(Gross.Charges),
               average.collection = mean(Gross.Coll),
               sd.collection = sd(Gross.Coll),
               tot = sum(Gross.Coll)
)
head(code_data)
write.csv(as.data.table(code_data), "code_data.csv")

md_data <- ddply(iic, c("Doctor.Name.Variable"), summarise,
               N    = length(Code.Description),
               average.charge = mean(Gross.Charges),
               sd.charge = sd(Gross.Charges),
               average.collection = mean(Gross.Coll),
               sd.collection = sd(Gross.Coll),
               tot = sum(Gross.Coll),
               rvus = sum(RVU)
)
head(md_data)
write.csv(as.data.table(md_data), "md_data.csv")

site_data_expanded<- ddply(iic, c("Site.Name"), summarise,
               N    = length(Code.Description),
               average.charge = mean(Gross.Charges),
               sd.charge = sd(Gross.Charges),
               average.collection = mean(Gross.Coll),
               sd.collection = sd(Gross.Coll),
               collections = sum(Gross.Coll)
)
head(site_data_expanded)
write.csv(as.data.table(site_data_expanded), "site_data_expanded.csv")
 

site_data_collapsed<- ddply(iic_clean, c("Site.Name", "Doctor.Name.Variable"), 
               summarise,
               N    = length(Code.Description),
               RVU  = sum(RVU),
               average.charge = mean(Gross.Charges),
               sd.charge = sd(Gross.Charges),
               average.collection = mean(Gross.Coll),
               sd.collection = sd(Gross.Coll),
               collections = sum(Gross.Coll)
)
head(site_data_collapsed)
write.csv(as.data.table(site_data_collapsed), "site_data_collapsed.csv")

site_data_short<-ddply(site_data_collapsed, c("Site.Name"),
                       summarize,
                       N    = sum(N),
                       RVU  = sum(RVU),
                       sd.charge = sd(average.charge),
                       average.charge = mean(average.charge),
                       average.collection = mean(average.collection),
                       sd.collection = sd(sd.collection),
                       collections = sum(collections)
                      )

site_data_short<-site_data_short[order(site_data_short$collections),]
par(mai=c(1,2,1,1))
barplot(sort(site_data_short$collections), main="Collections by site", 
        horiz=TRUE, xlab="Site", names.arg =site_data_short$Site.Name, 
        las=1, cex.names = .65, cex.lab=.5, cex.axis = .75)



