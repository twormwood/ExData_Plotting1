#Load library
library(dplyr)
library(lubridate)

#Download zip file and unzip

if(!file.exists("./data")) {dir.create("./data")}
zipUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(zipUrl,destfile="./data/power.zip")
unzip("/Users/Tracy/Desktop/ExData_Plotting1/data/power.zip", exdir="/Users/Tracy/Desktop/ExData_Plotting1")


#read into R Studio

power<-read.table("./household_power_consumption.txt", sep=";", header=TRUE)

#subset for dates required and remove original power file
power2<-filter(power, Date=="1/2/2007" | Date=="2/2/2007")
rm(power)


#change date to date format, combine date and hour variables, lubridate by parsing
power3<-mutate(power2, Date=as.Date(power2$Date, format="%d/%m/%Y"))
power3$New<-paste(power3$Date, power3$Time)
parsed_time<-parse_date_time(power3$New, "ymd HMS")
power3<-cbind(power3, parsed_time)

#change columns Global_active_power: Sub_metering_3 to numeric class
power3<-mutate_at(power3, vars(3:9), as.numeric)



#Plot 1
#standard png size is 480x480 pixels so no need to declare this in the png command.
png(filename="Plot1.png")
hist(power3$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.off()