# This file contains the functions necessary to download the dataset and create plot 4
#
# Step 1 install the package dplyr if it not already installed
# > install.packages("dplyr")
#
# Step 2 load the data if it's not already loaded
# > data <- getData()
#
# Step 3 create the plot
# > makePlot4(data)


# load dplyr
library(dplyr)

# Downloads the zip file with the data and unzips it in the directory "working directory/data"
# The directory data is created if it not exists.
downloadData <- function() {
    # Check if data directory exists. Create it if it's not.
    if (!file.exists("data")) {
        dir.create("data")
    }
    
    # Download the file
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "./data/dataset.zip", method = "curl")
    dateDownloaded <- date()
    
    # unzip the file in the data directory 
    unzip("./data/dataset.zip", exdir="./data")
}

getData <- function() {
    # Check if data directory exists. Create it if it's not.
    filename <- "./data/household_power_consumption.txt"
    if (!file.exists(filename)) {
        download(data)
    }
    
    data<- read.table(filename, header=TRUE, na.strings="?", sep=";", stringsAsFactors=FALSE)
    data <- filter(data, Date == "1/2/2007" | Date == "2/2/2007")
    mutate(data, datetime = as.POSIXct(strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")))
}

makePlot4 <- function(data) {
    Sys.setlocale("LC_TIME", "C")
    
    png(file="plot4.png")
    par(mfcol=c(2,2))
    plotA(data)
    plotB(data)
    plotC(data)
    plotD(data)
    dev.off()
}

plotA  <- function(data) {
    plot(data$datetime, data$Global_active_power, type="l", ylab="Global Active Power", xlab="")
}

plotB  <- function(data) {
    minY <- min(data$Sub_metering_1, data$Sub_metering_2, data$Sub_metering_3)
    maxY <- max(data$Sub_metering_1, data$Sub_metering_2, data$Sub_metering_3)
    
    plot(data$datetime,data$Sub_metering_1,ylim = c(minY,maxY),type = "n", ylab="Energy sub metering", xlab="")
    
    lines(data$datetime,data$Sub_metering_1)
    lines(data$datetime,data$Sub_metering_2, col="red")
    lines(data$datetime,data$Sub_metering_3, col="blue")
    legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty="solid", box.lwd=0)
}

plotC  <- function(data) {
    plot(data$datetime, data$Voltage, type="l", ylab="Voltage", xlab="datetime")
}

plotD  <- function(data) {
    plot(data$datetime, data$Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime")
}