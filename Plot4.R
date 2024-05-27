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

#Add ID column
power3$ID<-seq.int(nrow(power3))


#Plot 4
png(filename="Plot4.png")
par(mfrow=c(2,2))
with(power3, plot(ID, Global_active_power, type="l", ylab="Global Active Power", xlab="", xaxt = "n"))
axis(1, at=c(0, 1440, 2880), labels=c("Thu", "Fri", "Sat"))
with(power3, plot(ID, Voltage, type="l", ylab="Voltage", xlab="datetime", xaxt = "n"))
axis(1, at=c(0, 1440, 2880), labels=c("Thu", "Fri", "Sat"))
with(power3, plot(ID, type="n", ylab="Energy sub metering", xlab="", xaxt="n", yaxt="n", ylim=c(0,40)))
axis(2, at=c(0, 10, 20, 30))
axis(1, at=c(0,1440,2880), labels=c("Thu", "Fri", "Sat"))
points(power3$ID, power3$Sub_metering_1, type="l", col="black")
points(power3$ID, power3$Sub_metering_2, type="l", col="red")
points(power3$ID, power3$Sub_metering_3, type="l", col="blue")
legend("topright", lty="solid", col=c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n")
with(power3, plot(ID, Global_reactive_power, type="l", xlab="datetime", xaxt="n"))
axis(1, at=c(0,1440,2880), labels=c("Thu", "Fri", "Sat"))
dev.off()