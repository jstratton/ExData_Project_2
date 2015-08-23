# The purpose of this script is to graphically evaluate how fine particulate
# matter emissions due to motor vehicle sources in Baltimore City, MD have
# changed from 1999 to 2008.

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

# Extract the car data for Baltimore, MD, group the emissions by year, and then take
# the sum of the emissions for each year.
total_cars <- NEI_cars %>% filter(fips == "24510") %>%
                           group_by(year) %>%
                           summarise_each(funs(sum), emissions)

# Open the graphics device
png(filename = "Plot5.png", width = 640, height = 640)

# Make the Plot
## Since we have four data points, I think a bar graph will be the best depiction.
barplot(height = total_cars$emissions, names.arg = total_cars$year, col = "red",
        main = "Baltimore City, MD Fine Particulate Emissions due to Cars vs. Year",
        xlab = "Year", ylab = "Total PM2.5 Emissions (Tons)", ylim = c(0, 400),
        axes = TRUE)

# Close the graphics device
dev.off()
