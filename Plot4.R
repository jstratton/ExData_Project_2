# The purpose of this script is to graphically evaluate how fine particulate
# matter emissions do to coal combustion has changed from 1999 to 2008.

# Data Source: EPA National Emissions Inventory
# Source Link: http://www.epa.gov/ttn/chief/eiinformation.html

# Load required packages for this assignment
library(dplyr)

# Load the particulate data set and source code identifiers
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Make the column names all lower case to ease debugging
colnames(NEI) <- tolower(colnames(NEI))
colnames(SCC) <- tolower(colnames(SCC))

# We can easily find the coal combustion sources using the ei.sector column in
# SCC by using the key words "Fuel" for combustion and "Coal".
coal_rows <- grep(pattern = "^Fuel(.*)Coal$", SCC$ei.sector, ignore.case = TRUE)

# Now we simply subset NEI to get the coal data.
data_rows <- NEI$scc %in% SCC[coal_rows, 1]
NEI_coal <- NEI[data_rows, ]

# Group the emissions by year and then take the sum of the emissions for each year.
total_coal <- NEI_coal %>% group_by(year) %>% summarise_each(funs(sum), emissions)

# Open the graphics device
png(filename = "Plot4.png")

# Make the Plot

## Since we have four data points, I think a bar graph will be the best depiction.
## To get rid of the ugly scientific notations, I'm going to divide by 10^3
barplot(height = total_coal$emissions/10^3, names.arg = total_coal$year, col = "red", main = "USA Coal Combustion Related Particulate Emissions vs. Year", xlab = "Year", ylab = "Total PM2.5 Emissions (Thousands of Tons)", ylim = c(0, 600), axes = TRUE)

# Close the graphics device
dev.off()
