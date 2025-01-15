
# load library ------------------------------------------------------------

library(tidyverse)

# load data ---------------------------------------------------------------
getwd()
data<-read.table("C:/Users/julie/OneDrive/문서/exdata_data_household_power_consumption/household_power_consumption.txt", 
                 sep=";", head=TRUE, na.strings = "?")
object.size(data) ## 읽기 전에 미리 아는 방법? 
str(data)

##  dates 2007-02-01 and 2007-02-02 사이만 읽기 ?? 
data.1 <- read.table(pipe("grep '^1/2/2007\\|^2/2/2007' ./exdata_data_household_power_consumption/household_power_consumption.txt"), 
                     sep = ";", header = FALSE, stringsAsFactors = FALSE)

## subset dates 
data.1 <- data[data$Date %in% c("1/2/2007", "2/2/2007"), ]
str(data)

data.2 <- data.1 %>%
  mutate(Date = dmy(Date), 
         Time = hms(Time), 
         Global_active_power = as.numeric(Global_active_power),
         Global_intensity = as.numeric(Global_intensity), 
         Sub_metering_1 = as.numeric(Sub_metering_1),
         Sub_metering_2 = as.numeric(Sub_metering_2))

str(data.2)
sum(is.na(data.1))
sum(is.na(data))
# make plots --------------------------------------------------------------
# examine how household energy usage varies over a 2-day period in February, 2007. 
# for each plot, save it to a PNG file, width 480 pixels and height 480 pixels.
png(file="plot2.png", width = 480, height = 480)

with(data.2, plot(Global_active_power, 
                  type = 'l', 
                  ylab = "Global Active Power (kilowatts)", 
                  xaxt = "n",
                  xlab = ""))  # Suppress default x-axis

# Customize the x-axis
axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat")) ## axis 설정? 

dev.off()

