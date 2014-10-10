# Rather than read in the whole file which is large, I'm only reading in the two
# days that we're interested in (2007-02-01 & 2007-02-02).  To do so I need to 
# know how many rows to skip at the start of the file and than now many rows are 
# contained within our two days

# Calculating number of rows we need to skip
dts <- c("2006-12-16 17:24:00", "2007-02-01 00:00:00")
skip_span <- as.POSIXct(dts)
skip_rows <- as.numeric(difftime(skip_span[2], skip_span[1], units = "mins"))

# Calculating the number of rows we need to read in
dts2 <- c("2007-02-01 00:00:00", "2007-02-03 00:00:00")
nrows_span <- as.POSIXct(dts2)
nrows_count <- as.numeric(difftime(nrows_span[2], nrows_span[1], units = "mins"))

# Reading in the data for the two days we are interested in
data <- read.table("household_power_consumption.txt", stringsAsFactors = FALSE, 
                   header = FALSE, skip = skip_rows + 1, nrows = nrows_count, 
                   sep = ";", na.strings="?")

# When you use skip and nrows, you lose the header info, so we need to read that 
# in separately and apply it
header <- read.table('household_power_consumption.txt', nrows = 1, 
                     header = FALSE, sep =';', stringsAsFactors = FALSE)

colnames(data) <- unlist(header)

# merge the date and time column into a single column of POSIXct DateTime objects
date_time_str <- paste(data$Date, data$Time)
date_times <- strptime(date_time_str, "%d/%m/%Y %H:%M:%S")
data$date_time <- date_times
data <- subset(data, select = -c(Date,Time) )


# Open a png device
png(filename = "plot2.png")

# Write the required plot to png device
plot(data$date_time, data$Global_active_power, type = "n", 
     ylab = "Global Active Power (kilowatts)", xlab = "")
lines(data$date_time, data$Global_active_power, type = "l")

# Close the device
dev.off()
