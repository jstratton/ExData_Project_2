# The purpose of this script is to graphically evaluate whether fine particulate
# matter pollution has increased from 1999 to 2008.

# Data Source: EPA National Emissions Inventory
# Source Link: http://www.epa.gov/ttn/chief/eiinformation.html

# Load required packages for this assignment
library(dplyr)

# Load the particulate data set
NEI <- readRDS("summarySCC_PM25.rds")

# Make the column names all lower case to ease debugging
colnames(NEI) <- tolower(colnames(NEI))

# Group the emissions by year and then take the sum of the emissions for each year.
total_emissions <- NEI %>% group_by(year) %>% summarise_each(funs(sum), emissions)

# Open the graphics device
png(filename = "Plot1.png")

# Make the Plot

## Since we have four data points, I think a bar graph will be the best depiction.
## I plotted the total emissions using millions of tons as my unit to get rid of
##      the ugly scientific notations that R was putting in by default.
barplot(height = total_emissions$emissions/10^6, names.arg = total_emissions$year,
        col = "red", main = "Total Emissions vs. Year", xlab = "Year",
        ylab = "Total Emissions (Millions of Tons)", ylim = c(0, 8), axes = TRUE)

# Close the graphics device
dev.off()
