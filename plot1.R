# This file contains the functions necessary to download the dataset and create plot 1
#
# Step 1 install the package dplyr if it not already installed
# > install.packages("dplyr")
#
# Step 2 load the source file
#> source("plot1.R")
#
# Step 3 load the data if it's not already loaded
# > data <- getData()
#
# Step 4 create the plot
# > makePlot1(data)


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

# Loads the file into a data frame. The data is downloaded if it's not present
# Only data from first and second february 2007 is selected.
# A new column datetime is added to the data frame
getData <- function() {
    filename <- "./data/household_power_consumption.txt"
    if (!file.exists(filename)) {
        download(data)
    }
    
    data<- read.table(filename, header=TRUE, na.strings="?", sep=";", stringsAsFactors=FALSE)
    data <- filter(data, Date == "1/2/2007" | Date == "2/2/2007")
    mutate(data, datetime = as.POSIXct(strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")))
}

# writes the plot to a png file
makePlot1 <- function(data) {
    png(file="plot1.png")
    hist(data$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")   
    dev.off()
}