#-----------------------------------------------------------------
# Author: Maksim Helmann
# Last updated: 2024-09-16
#----------------------------------------------------------------

# Load raw data from .csv file
rawdat <- read.csv(here("data", "original", "disaster.csv"), header=TRUE)

# Filer the data to subset the data set to include years 2000–2019 and disaster types “Earthquake” and “Drought
# Subset the data set to only include the following variables: Year, ISO, Disaster.type.
subdat <- filter(rawdat, rawdat$Year %in% c(2000:2019), rawdat$Disaster.Type== "Earthquake" | rawdat$Disaster.Type=="Drought") %>% 
  select(c("Year","ISO","Disaster.Type"))

# Create a dummy binary variable drought and another dummy variable earthquake
subdat$earthquake <- ifelse(subdat$Disaster.Type == "Drought", 1, 0)
subdat$drought <- ifelse(subdat$Disaster.Type == "Earthquake", 1, 0)

# Use the group_by() and summarize() functions to create a data set where only one row of observation exists for each country and each year
disaster_clean <- subdat %>% select(-c("Disaster.Type")) %>%
  group_by(Year, ISO) %>%
  summarize(earthquake=max(earthquake), drought=max(drought))
