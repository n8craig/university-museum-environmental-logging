# This script accompanies museum-temperature-humidity-logging.qmd
# By Nathan Craig

#### IMPORTANT--NEED TO CHANGE FILE PATH FOR EACH LOGGER DF!!!!

# Libraries ---------------------------------------------------------------

library(tidyverse)
library(readr)
library(xts)

# West Gallery ------------------------------------------------------------

# Read file
df_wg <- read_csv(here::here("projects/2022-07-26-omdp/data/um_west_gallery_2022_07_26.csv"), 
                       skip = 11)

# Clean col names
df_wg <- df_wg %>% 
  rename(.,
         date_time = `Date / Time (UTC)`,
         temperature_f = `Channel 1 (°F)`,
         humidity_percent_rh = `Channel 2 (%RH)`,
         dew_point = `Channel 3 (°F)`) %>% 
  select(., -`...6`) %>% 
  mutate(logger = "West Gallery", .before = Reading)

# Change date field
df_wg$date_time <- lubridate::as_datetime(df_wg$date_time)
df_wg <- janitor::clean_names(df_wg)


## West Gallery Time Series -----------------------------------------------------

# Create time series for temp
df_wg %>% 
  select(date_time, temperature_f)
wg_temp <- xts(df_wg$temperature_f, df_wg$date_time)

# Create time series for RH
df_wg %>% 
  select(date_time, humidity_percent_rh)
wg_rh <- xts(df_wg$humidity_percent_rh, df_wg$date_time)

# Create time series for Dew Point
df_wg %>% 
  select(date_time, dew_point)
wg_dp <- xts(df_wg$dew_point, df_wg$date_time)


## Textile Pivot Longer ----------------------------------------------------

# Pivot df longer
df_wg <- df_wg %>% pivot_longer(.,
                                          4:6,
                                          names_to = "observation_type",
                                          values_to = "value")

# Make Factor
df_wg$observation_type <- as_factor(df_wg$observation_type)

# Reorder Factor
df_wg$observation_type <- fct_relevel(df_wg$observation_type,
                                           "temperature_f")


# OMDP1 -----------------------------------------------------------------

# Read file
df_omdp1 <- read_csv(here::here("projects/2022-07-26-omdp/data/um_omdp1_2022_07_26.csv"))

# Clean col names
df_omdp1 <- df_omdp1 %>% 
  rename(.,
         date_time = `Timestamp for sample frequency every 1 min min`,
         temperature_f = `Temperature_Fahrenheit`,
         humidity_percent_rh = `Relative_Humidity`) %>% 
  # select(., -`...6`) %>% 
  mutate(reading = row_number(),
         logger = "OMDP 1", .before = date_time)

# Change date field
df_omdp1$date_time <- lubridate::as_datetime(df_omdp1$date_time)

df_omdp1 <- janitor::clean_names(df_omdp1)


## OMDP1 Time Series -----------------------------------------------------

# Create time series for temp
df_omdp1 %>% 
  select(date_time, temperature_f)
omdp1_temp <- xts(df_omdp1$temperature_f, df_omdp1$date_time)

# Create time series for RH
df_omdp1 %>% 
  select(date_time, humidity_percent_rh)
omdp1_rh <- xts(df_omdp1$humidity_percent_rh, df_omdp1$date_time)

## Note Govee Logger does not track dew point
# # Create time series for Dew Point
# df_omdp1 %>% 
#   select(date_time, dew_point)
# omdp1_dp <- xts(df_omdp1$dew_point, df_omdp1$date_time)


## OMDP1 Pivot Longer ----------------------------------------------------

# Pivot longer
df_omdp1 <- df_omdp1 %>% pivot_longer(.,
                                4:5,
                                names_to = "observation_type",
                                values_to = "value")

# Make Factor
df_omdp1$observation_type <- as_factor(df_omdp1$observation_type)

# Reorder Factor
df_omdp1$observation_type <- fct_relevel(df_omdp1$observation_type,
                                      "temperature_f")




# OMDP2 -----------------------------------------------------------------

# Read file
df_omdp2 <- read_csv(here::here("projects/2022-07-26-omdp/data/um_omdp2_2022_07_26.csv"))

# Clean col names
df_omdp2 <- df_omdp2 %>% 
  rename(.,
         date_time = `Timestamp for sample frequency every 1 min min`,
         temperature_f = `Temperature_Fahrenheit`,
         humidity_percent_rh = `Relative_Humidity`) %>% 
  # select(., -`...6`) %>% 
  mutate(reading = row_number(),
         logger = "OMDP 1", .before = date_time)

# Change date field
df_omdp2$date_time <- lubridate::as_datetime(df_omdp2$date_time)

df_omdp2 <- janitor::clean_names(df_omdp2)


## OMDP2 Time Series -----------------------------------------------------

# Create time series for temp
df_omdp2 %>% 
  select(date_time, temperature_f)
omdp2_temp <- xts(df_omdp2$temperature_f, df_omdp2$date_time)

# Create time series for RH
df_omdp2 %>% 
  select(date_time, humidity_percent_rh)
omdp2_rh <- xts(df_omdp2$humidity_percent_rh, df_omdp2$date_time)

## Note Govee Logger does not track dew point
# # Create time series for Dew Point
# df_omdp2 %>% 
#   select(date_time, dew_point)
# omdp2_dp <- xts(df_omdp2$dew_point, df_omdp2$date_time)


## omdp2 Pivot Longer ----------------------------------------------------

# Pivot longer
df_omdp2 <- df_omdp2 %>% pivot_longer(.,
                                      4:5,
                                      names_to = "observation_type",
                                      values_to = "value")

# Make Factor
df_omdp2$observation_type <- as_factor(df_omdp2$observation_type)

# Reorder Factor
df_omdp2$observation_type <- fct_relevel(df_omdp2$observation_type,
                                         "temperature_f")



# Combine time series into list and remove temp files ---------------------

# Create multi-col time series for each variable
ts_temp <- cbind(wg_temp, omdp1_temp, omdp2_temp)
ts_rh <- cbind(wg_rh, omdp1_rh, omdp2_rh)
# ts_dp <- cbind(textile_dp, wl_dp, eg_dp, base_dp)

ts_list <- list("wg_temp" = wg_temp,
                "wg_rh" = wg_rh,
                "omdp1_temp" = omdp1_temp,
                "omdp1_rh" = omdp1_rh,
                "omdp2_temp" = omdp2_temp,
                "omdp2_rh" = omdp2_rh,
                "temp_merge" = ts_temp,
                "rh_merge" = ts_rh)

rm(omdp1_rh, 
   omdp1_temp, 
   omdp2_temp, 
   omdp2_rh, 
   wg_dp, 
   wg_rh, 
   wg_temp,
   ts_rh,
   ts_temp)

# Combine temp data frames and remove -------------------------------------



df <- rbind(df_omdp1, df_omdp2, df_wg)
df$logger <- as_factor(df$logger)
rm(df_omdp1, df_omdp2, df_wg)
