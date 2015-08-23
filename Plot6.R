# The purpose of this script is to graphically compare how fine particulate
# matter emissions due to motor vehicle sources in Baltimore City, MD and Los
# Angeles County, CA have changed from 1999 to 2008.

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

# I'm going to make the assumption that by "motor vehicles", the assignment
# is really asking about cars since that is the common use of the term.

# Fortunately, all of the car related roads have the term "On-Road" in them
car_rows <- grep(pattern = "On-Road", SCC$ei.sector, fixed = TRUE)

# Now we simply subset NEI to get the coal data.
data_rows <- NEI$scc %in% SCC[car_rows, 1]
NEI_cars <- NEI[data_rows, ]

# Extract the car data for Baltimore, MD (fips = 24510) and Los Angeles County,
# CA (fips = 06037), group the emissions by year, and then take the sum of the
# emissions for each year.
total_cars <- NEI_cars %>% filter(fips == "24510" | fips == "06037") %>%
        group_by(fips, year) %>%
        summarise_each(funs(sum), emissions)

# Change the values in the fips columns to be the city names
total_cars$fips <- gsub(pattern = "24510", replacement = "Baltimore, MD",
                        x = total_cars$fips)

total_cars$fips <- gsub(pattern = "06037", replacement = "Los Angeles County, MD",
                        x = total_cars$fips)

# Open the graphics device
#png(filename = "Plot6.png", width = 640, height = 640)

# Make the Plot
#myplot <- qplot(x = year, y = emissions, data = total_cars, facets = . ~ fips,
 #               main = "Comparison of Particulate Emissions due to Cars in Maryland, MD and Los Angeles, CA vs. Time",
  #              xlab = "Year", ylab = "Total PM2.5 Emissions (Tons)")

print(myplot)

# Close the graphics device
#dev.off()
