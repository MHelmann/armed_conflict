#-----------------------------------------------------------------
# Author: Maksim Helmann
# Last updated: 2024-09-16
#----------------------------------------------------------------

# Load libraries
library("tidyr")
library("dplyr")
library("here")
library("readr")

# Load covariate dataset
cov_data <- read.csv(here("data", "original", "covariates.csv"), header=TRUE)

# Call R scripts to create the corresponding datasets
source(here("R","clean_disaster.R"))
source(here("R","create_mortality.R"))
source(here("R","binary_armed_conflict.R"))


# Change column name of disaster dataset from "Year" -> "year"
colnames(disaster_clean)[1] <- "year"

# Add all data frames into list
all_datasets <- list(conflict_binary, disaster_clean, mortality_full, cov_data)
# Merge all the data frames in list
final_mortality_data <- reduce(all_datasets, full_join, by = c("year", "ISO"))
# Check to see if there are 20 rows of data for each country.
dim(final_mortality_data)

# replace NAs with 0's for variables: armconf1, drougt, earthquake and totaldeath
final_mortality_data <- final_mortality_data |> 
  mutate(armconf1 = replace_na(armconf1, 0),
         drought = replace_na(drought, 0),
         earthquake = replace_na(earthquake, 0),
         totaldeath = replace_na(totaldeath, 0))

# Save final dataset
write.csv(final_mortality_data, file = here("data", "analytical", "final_data.csv"), row.names = FALSE)

