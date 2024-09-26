#-----------------------------------------------------------------
# Author: Maksim Helmann
# Last updated: 2024-09-16
#----------------------------------------------------------------

# Import liabraries
library("tidyr")
library("dplyr")
library("here")
library("readr")

# Load conflict dataset
conflict_data <- read.csv(here("data", "original", "conflictdata.csv"), header=TRUE)

# Include the indicator of whether the country had a conflict that year
# Armed conflict variable is lagged by a year
conflict_binary <- conflict_data %>% 
  group_by(ISO, year) %>%
  summarize(totaldeath = sum(best)) %>%
  mutate(armconf1 = ifelse(totaldeath < 25, 0, 1)) %>%
  ungroup() %>%
  mutate(year = year + 1)
  
