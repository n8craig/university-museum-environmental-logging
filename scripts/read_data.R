# This script accompanies museum-temperature-humidity-logging.qmd
# By Nathan Craig

#### IMPORTANT--NEED TO CHANGE FILE PATH FOR EACH LOGGER DF!!!!

# Libraries ---------------------------------------------------------------

library(tidyverse)
library(readr)
library(xts)

# Textile Room ------------------------------------------------------------

# Read file
df_textile <- read_csv(here::here("data/um_textile_2022_05_20.csv"), 
                       skip = 11)

# Clean col names
df_textile <- df_textile %>% 
  rename(.,
         date_time = `Date / Time (UTC)`,
         temperature_f = `Channel 1 (°F)`,
         humidity_percent_rh = `Channel 2 (%RH)`,
         dew_point = `Channel 3 (°F)`) %>% 
  select(., -`...6`) %>% 
  mutate(logger = "Textile Room", .before = Reading)

# Change date field
df_textile$date_time <- lubridate::as_datetime(df_textile$date_time)
df_textile <- janitor::clean_names(df_textile)


## Textile Time Series -----------------------------------------------------

# Create time series for temp
df_textile %>% 
  select(date_time, temperature_f)
textile_temp <- xts(df_textile$temperature_f, df_textile$date_time)

# Create time series for RH
df_textile %>% 
  select(date_time, humidity_percent_rh)
textile_rh <- xts(df_textile$humidity_percent_rh, df_textile$date_time)

# Create time series for Dew Point
df_textile %>% 
  select(date_time, dew_point)
textile_dp <- xts(df_textile$dew_point, df_textile$date_time)


## Textile Pivot Longer ----------------------------------------------------

# Pivot df longer
df_textile <- df_textile %>% pivot_longer(.,
                                          4:6,
                                          names_to = "observation_type",
                                          values_to = "value")

# Make Factor
df_textile$observation_type <- as_factor(df_textile$observation_type)

# Reorder Factor
df_textile$observation_type <- fct_relevel(df_textile$observation_type,
                                           "temperature_f")


# Wet Lab -----------------------------------------------------------------

# Read file
df_wl <- read_csv(here::here("data/um_wl_2022_05_20.csv"), 
                  skip = 11)

# Clean col names
df_wl <- df_wl %>% 
  rename(.,
         date_time = `Date / Time (UTC)`,
         temperature_f = `Channel 1 (°F)`,
         humidity_percent_rh = `Channel 2 (%RH)`,
         dew_point = `Channel 3 (°F)`) %>% 
  select(., -`...6`) %>% 
  mutate(logger = "Wet Lab", .before = Reading)

# Change date field
df_wl$date_time <- lubridate::as_datetime(df_wl$date_time)

df_wl <- janitor::clean_names(df_wl)


## Wet Lab Time Series -----------------------------------------------------

# Create time series for temp
df_wl %>% 
  select(date_time, temperature_f)
wl_temp <- xts(df_wl$temperature_f, df_wl$date_time)

# Create time series for RH
df_wl %>% 
  select(date_time, humidity_percent_rh)
wl_rh <- xts(df_wl$humidity_percent_rh, df_wl$date_time)

# Create time series for Dew Point
df_wl %>% 
  select(date_time, dew_point)
wl_dp <- xts(df_wl$dew_point, df_wl$date_time)


## Wet Lab Pivot Longer ----------------------------------------------------

# Pivot longer
df_wl <- df_wl %>% pivot_longer(.,
                                4:6,
                                names_to = "observation_type",
                                values_to = "value")

# Make Factor
df_wl$observation_type <- as_factor(df_wl$observation_type)

# Reorder Factor
df_wl$observation_type <- fct_relevel(df_wl$observation_type,
                                      "temperature_f")

# East Gallery ------------------------------------------------------------

# Read data
df_eg <- read_csv(here::here("data/um_eg_2022_05_20.csv"), 
                  skip = 11)

# Clean col names
#### Note some of the col names are different for this logger.
#### Not sure why that is the case

df_eg <- df_eg %>% 
  rename(.,
         date_time = `Date / Time (UTC)`,
         temperature_f = `Temperature (°F)`,
         humidity_percent_rh = `Humidity (%RH)`,
         dew_point = `Dew Point (°F)`) %>% 
  select(., -`...6`) %>% 
  mutate(logger = "East Gallery", .before = Reading)

# Change date field
df_eg$date_time <- lubridate::as_datetime(df_eg$date_time)

df_eg <- janitor::clean_names(df_eg)


## East Gallery Time Series -----------------------------------------------------

# Create time series for temp
df_eg %>% 
  select(date_time, temperature_f)
eg_temp <- xts(df_eg$temperature_f, df_eg$date_time)

# Create time series for RH
df_eg %>% 
  select(date_time, humidity_percent_rh)
eg_rh <- xts(df_eg$humidity_percent_rh, df_eg$date_time)

# Create time series for Dew Point
df_eg %>% 
  select(date_time, dew_point)
eg_dp <- xts(df_eg$dew_point, df_eg$date_time)


## East Gallery Pivot Longer ----------------------------------------------------

# Pivot longer
df_eg <- df_eg %>% pivot_longer(.,
                                4:6,
                                names_to = "observation_type",
                                values_to = "value")

# Make Factor
df_eg$observation_type <- as_factor(df_eg$observation_type)

# Reorder Factor
df_eg$observation_type <- fct_relevel(df_eg$observation_type,
                                      "temperature_f")

# Basement ----------------------------------------------------------------

# Read file
df_base <- read_csv(here::here("data/um_basement_2022_05_20.csv"), 
                    skip = 11)

# Clean col names
#### Note some of the col names are different for this logger.
#### Not sure why that is the case
#### I think some of the loggers have different field names
#### Can probably configure this

# Clean col names
df_base <- df_base %>% 
  rename(.,
         date_time = `Date / Time (UTC)`,
         temperature_f = `Temperature (°F)`,
         humidity_percent_rh = `Humidity (%RH)`,
         dew_point = `Dew Point (°F)`) %>%  
  select(., -`...6`) %>% 
  mutate(logger = "Basement", .before = Reading)

# Change date field
df_base$date_time <- lubridate::as_datetime(df_base$date_time)

df_base <- janitor::clean_names(df_base)


## Basement Time Series -----------------------------------------------------

# Create time series for temp
df_base %>% 
  select(date_time, temperature_f)
base_temp <- xts(df_base$temperature_f, df_base$date_time)

# Create time series for RH
df_base %>% 
  select(date_time, humidity_percent_rh)
base_rh <- xts(df_base$humidity_percent_rh, df_base$date_time)

# Create time series for Dew Point
df_base %>% 
  select(date_time, dew_point)
base_dp <- xts(df_base$dew_point, df_base$date_time)


## Basement Pivot Longer ----------------------------------------------------


# Pivot longer
df_base <- df_base %>% pivot_longer(.,
                                    4:6,
                                    names_to = "observation_type",
                                    values_to = "value")

# Make Factor
df_base$observation_type <- as_factor(df_base$observation_type)

# Reorder Factor
df_base$observation_type <- fct_relevel(df_base$observation_type,
                                        "temperature_f")



# Combine time series into list and remove temp files ---------------------


# ts_merged <- cbind(textile_temp, 
#                    textile_rh, 
#                    textile_dp,
#                    wl_temp,
#                    wl_rh, 
#                    wl_dp,
#                    eg_temp, 
#                    eg_rh, 
#                    eg_dp,
#                    base_temp, 
#                    base_rh, 
#                    base_dp)

# Create multi-col time series for each variable
ts_temp <- cbind(textile_temp, wl_temp, eg_temp, base_temp)
ts_rh <- cbind(textile_rh, wl_rh, eg_rh, base_rh)
ts_dp <- cbind(textile_dp, wl_dp, eg_dp, base_dp)

ts_list <- list("textile_temp" = textile_temp,
                "textile_rh" = textile_rh,
                "textile_dp" = textile_dp,
                "wl_temp" = wl_temp,
                "wl_rh" = wl_rh,
                "wl_dp" = wl_dp,
                "eg_temp" = eg_temp,
                "eg_rh" = eg_rh,
                "eg_dp" = eg_dp,
                "base_temp" = base_temp,
                "base_rh" = base_rh,
                "base_dp" = base_dp,
                "temp_merge" = ts_temp,
                "rh_merge" = ts_rh,
                "dp_merge" = ts_dp)

rm(textile_temp, 
   textile_rh, 
   textile_dp,
   wl_temp, 
   wl_rh, 
   wl_dp,
   eg_temp, 
   eg_rh, 
   eg_dp,
   base_temp, 
   base_rh, 
   base_dp,
   ts_temp,
   ts_rh,
   ts_dp)

# Combine temp data frames and remove -------------------------------------

df <- rbind(df_base, df_eg, df_textile, df_wl)
df$logger <- as_factor(df$logger)
rm(df_base, df_eg, df_textile, df_wl)
