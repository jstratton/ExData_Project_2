# The purpose of this script is to graphically evaluate whether fine particulate
# matter pollution has increased in Baltimore, MD from 1999 to 2008.

# Data Source: EPA National Emissions Inventory
# Source Link: http://www.epa.gov/ttn/chief/eiinformation.html

# Load required packages for this assignment
library(dplyr)

# Load the particulate data set
NEI <- readRDS("summarySCC_PM25.rds")

# Make the column names all lower case to ease debugging
colnames(NEI) <- tolower(colnames(NEI))

# Extract the emissions for Baltimore, MD (fips = 24510), group the emissions by
# year, and then take the sum of the emissions for each year.
total_emissions <- NEI %>% filter(fips == "24510") %>%
                           group_by(year) %>%
                           summarise_each(funs(sum), emissions)

# Open the graphics device
png(filename = "Plot2.png")

# Make the Plot
# Since we have four data points, I think a bar graph will be the best depiction.
barplot(height = total_emissions$emissions, names.arg = total_emissions$year,
        col = "red", main = "Fine Particulate Matter Emmisions in Baltimore City, MD vs. Year",
        xlab = "Year", ylab = "Total PM2.5 Emissions (Tons)", ylim = c(0, 3500),
        axes = TRUE)

# Close the graphics device
dev.off()
