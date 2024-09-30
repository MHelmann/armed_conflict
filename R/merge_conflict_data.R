#-----------------------------------------------------------------
# Author: Maksim Helmann
# Last updated: 2024-09-16
#----------------------------------------------------------------

# Load libraries
#| label: load-packages
#| include: false
source(".Rprofile")

# Load covariate dataset
cov_data <- read.csv(here("data", "original", "covariates.csv"), header=TRUE)

# Call R scripts to create the corresponding datasets
source(here("R","clean_disaster.R"))
source(here("R","create_mortality.R"))
source(here("R","binary_armed_conflict.R"))

# Add all data frames into list
all_datasets <- list(conflict_binary, disaster_clean, mortality_full)
# Merge all the data frames in list
final_data_ <- reduce(all_datasets, full_join, by = c("year", "ISO"))

final_mort_data <- cov_data |>
  left_join(final_data_, by = c('ISO', 'year'))
# Check to see if there are 20 rows of data for each country.
dim(final_mort_data)

# replace NAs with 0's for variables: armconf1, drougt, earthquake and totaldeath
final_mort_data <- final_mort_data |> 
  mutate(armconf1 = replace_na(armconf1, 0),
         drought = replace_na(drought, 0),
         earthquake = replace_na(earthquake, 0),
         totdeath = replace_na(totdeath, 0))

# Reorder columns
final_mort_data <- final_mort_data[ , c("country_name", "ISO", "region", "year", "gdp1000", "OECD", "OECD2023", 
                                        "popdens", "urban", "agedep", "male_edu", "temp", "rainfall1000",
                                        "totdeath", "armconf1", "matmor", "infmor", "neomor", "un5mor",
                                        "drought", "earthquake")]

# Save final dataset
write.csv(final_mort_data, file = here("data", "analytical", "final_mort_data.csv"), row.names = FALSE)

