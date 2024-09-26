#-----------------------------------------------------------------
# Author: Maksim Helmann
# Last updated: 2024-09-16
# What: Read in raw data, 
#         subset column,
#         convert column names
#----------------------------------------------------------------

# import libraries
library("tidyr")
library("dplyr")
library("here")
library("readr")
library("purrr")
library("countrycode")

# Turn off warnings
# options(warn = -1)

# Function to manipulate a dataset
clean_dataset <- function(data, col_name){
  # Subset data to have only the variables Country.Name, X2000 – X2019
  # Change format to long and remove prefix
  subdat <- select(data, c("Country.Name", "X2000":"X2019")) %>% 
    pivot_longer(cols = starts_with("X"), names_prefix = "X")
  # Rename column names
  colnames(subdat) <- c("Country.Name", "year", col_name)
  # Convert year type to numeric
  subdat$year <- as.numeric((subdat$year))
  subdat
}

# Load raw data from .csv file
maternal_raw <- read.csv(here("data", "original", "maternalmortality.csv"), header=TRUE)
infant_raw <- read.csv(here("data", "original", "infantmortality.csv"), header=TRUE)
neonatal_raw <- read.csv(here("data", "original", "neonatalmortality.csv"), header=TRUE)
under5_raw <- read.csv(here("data", "original", "under5mortality.csv"), header=TRUE)

# Manipulated data
maternal_clean <- clean_dataset(maternal_raw, col_name="MatMor")
infant_clean <- clean_dataset(maternal_raw, col_name="InfantMor")
neonatal_clean <- clean_dataset(maternal_raw, col_name="NeoMor")
under5_clean <- clean_dataset(maternal_raw, col_name="Under5Mor")

# Use reduce() and full_join() functions to merge the four data sets to create one new data set 
mortality_list <- list(maternal_clean, infant_clean, neonatal_clean, under5_clean)
mortality_full <- reduce(mortality_list, full_join, by = c("Country.Name", "year"))

# Add the ISO-3 country code variable
mortality_full$ISO <- countrycode(mortality_full$Country.Name,
                            origin = "country.name",
                            destination = "iso3c") 
# Remove Country.Name column
mortality_full <- mortality_full %>% select(-Country.Name)
