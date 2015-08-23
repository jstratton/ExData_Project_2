# The purpose of this script is to graphically evaluate whether fine particulate
# matter pollution for a given source in Baltimore, MD has increased from 1999
# to 2008.

# Data Source: EPA National Emissions Inventory
# Source Link: http://www.epa.gov/ttn/chief/eiinformation.html

# Load required packages for this assignment
library(dplyr)
library(ggplot2)

# Load the particulate data set
NEI <- readRDS("summarySCC_PM25.rds")

# Make the column names all lower case to ease debugging
colnames(NEI) <- tolower(colnames(NEI))

# Extract the emissions for Baltimore, MD (fips = 24510), group the emissions by
# year and source type, and then take the sum of the emissions for each year.
total_emissions <- NEI %>% filter(fips == "24510") %>%
        group_by(year, type) %>%
        summarise_each(funs(sum), emissions)

# Open the graphics device
png(filename = "Plot3.png", width = 640, height = 640)

# Make the Plot
myplot <- qplot(x = year, y = emissions, data = total_emissions, facets = . ~ type,
      main = "Baltimore City, MD PM2.5 Emissions by Type vs. Year",
      xlab = "Year", ylab = "PM2.5 Emissions (Tons)")

print(myplot)

# Close the graphics device
dev.off()
