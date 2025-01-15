# load library ------------------------------------------------------------

library(tidyverse)

# load data ---------------------------------------------------------------
if (!file.exists("UCI EPC Dataset")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, destfile = "UCI EPC Dataset.zip")
  unzip("UCI EPC Dataset.zip")
}

data <- read.table("./household_power_consumption.txt", # file path
                   header = TRUE, 
                   sep = ";",
                   na.strings = "?", # read "?" as NA
                   colClasses = "character") # Read all column as "character"

## subset dates 
data.1 <- data[data$Date %in% c("1/2/2007", "2/2/2007"), ]

## make variables into numerics 
data.2 <- data.1 %>%
  mutate(DateTime = strptime(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")) %>% 
  # Combine and edit Date and Time with strptime function
  mutate(across(Global_active_power:Sub_metering_3, \(x) as.numeric(x)))


# make plots --------------------------------------------------------------
png(file="plot3.png", width = 480, height = 480)

with(data.2, plot(DateTime, Sub_metering_1, 
                  type='l', 
                  ylab="Energy sub metering", 
                  xlab="", 
                  xaxt="n"))

lines(data.2$DateTime, data.2$Sub_metering_2, type='l', col="red")
lines(data.2$DateTime, data.2$Sub_metering_3, type='l', col="blue")

axis(1, 
     at = as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"), format = "%Y-%m-%d"), 
     labels = c("Thu", "Fri", "Sat")) # x-axis label

legend("topright", lty=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()
