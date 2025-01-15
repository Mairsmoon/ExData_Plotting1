
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
png(file="plot1.png", width = 480, height = 480)

hist(data.2$Global_active_power, 
     col="red", 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)")

dev.off()


