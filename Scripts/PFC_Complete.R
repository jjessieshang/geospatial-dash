library(tidyverse)

# Load Data

traveldata <- read_csv('HA_distance_duration.csv')

# Set Desired Constants

fm_wait <- 0.5
fm_appt <- 0.26

ed_los_CTAS_III <- 3.9
ed_los_CTAS_V <- 2.7

hosp_los <- 53.6

virtual_wait <- 0.27
virtual_appt <- 0.35

wage <- 30.54

caregiver_0_14 <- 1
caregiver_15 <- 0.5
caregiver_hosp_0_14 <- 0.75
caregiver_hosp_15 <- 0.25

distance_NH <- (traveldata[traveldata$`HA Name` == "Northern", "Street Distance"])*2
distance_IH <- (traveldata[traveldata$`HA Name` == "Interior", "Street Distance"])*2
distance_VCH <- (traveldata[traveldata$`HA Name` == "Vancouver Coastal", "Street Distance"])*2
distance_FH <- (traveldata[traveldata$`HA Name` == "Fraser", "Street Distance"])*2
distance_VIH <- (traveldata[traveldata$`HA Name` == "Vancouver Island", "Street Distance"])*2

duration_NH <- (traveldata[traveldata$`HA Name` == "Northern", "Street Duration"])*2/60
duration_IH <- (traveldata[traveldata$`HA Name` == "Interior", "Street Duration"])*2/60
duration_VCH <- (traveldata[traveldata$`HA Name` == "Vancouver Coastal", "Street Duration"])*2/60
duration_FH <- (traveldata[traveldata$`HA Name` == "Fraser", "Street Duration"])*2/60
duration_VIH <- (traveldata[traveldata$`HA Name` == "Vancouver Island", "Street Duration"])*2/60

park_fm_NH <- 2
park_fm_IH <- 3
park_fm_VCH <- 8
park_fm_FH <- 3
park_fm_VIH <- 2

park_ed_NH <- 1.5
park_ed_IH <- 4.5
park_ed_VCH <- 18
park_ed_FH <- 7.5
park_ed_VIH <- 4.5

park_hosp_NH <- 18
park_hosp_IH <- 12
park_hosp_VCH <- 37.5
park_hosp_FH <- 16.5
park_hosp_VIH <- 26.75

meal_cost <- 15 
accomm <- 100

car_cost_per_km <- 0.48

data_usage <- 1.25

### UNIT COSTS 

pfc <- data.frame(matrix(ncol = 10, nrow = 0))
x <- c("variable_name", "cost_type", "service_type", "health_authority", "ctas_admit", "age", "cost_value", "lost_productivity", "informal_caregiving", "out_of_pocket")
colnames(pfc) <- x

## Family Medicine

# Lost Productivity
FM_LP_NH_1 <- 0 
FM_LP_NH_2 <- (fm_appt + fm_wait + duration_NH)*wage
FM_LP_NH_3 <- 0
FM_LP_IH_1 <- 0
FM_LP_IH_2 <- (fm_appt + fm_wait + duration_IH)*wage
FM_LP_IH_3 <- 0
FM_LP_VCH_1 <- 0
FM_LP_VCH_2 <- (fm_appt + fm_wait + duration_VCH)*wage
FM_LP_VCH_3 <- 0
FM_LP_FH_1 <- 0
FM_LP_FH_2 <- (fm_appt + fm_wait + duration_FH)*wage
FM_LP_FH_3 <- 0
FM_LP_VIH_1 <- 0
FM_LP_VIH_2 <- (fm_appt + fm_wait + duration_VIH)*wage
FM_LP_VIH_3 <- 0

# Informal Caregiving
FM_IC_NH_1 <- (fm_appt + fm_wait + duration_NH)*wage*caregiver_0_14
FM_IC_NH_2 <- (fm_appt + fm_wait + duration_NH)*wage*caregiver_15
FM_IC_NH_3 <- (fm_appt + fm_wait + duration_NH)*wage*caregiver_15
FM_IC_IH_1 <- (fm_appt + fm_wait + duration_IH)*wage*caregiver_0_14
FM_IC_IH_2 <- (fm_appt + fm_wait + duration_IH)*wage*caregiver_15
FM_IC_IH_3 <- (fm_appt + fm_wait + duration_IH)*wage*caregiver_15
FM_IC_VCH_1 <- (fm_appt + fm_wait + duration_VCH)*wage*caregiver_0_14
FM_IC_VCH_2 <- (fm_appt + fm_wait + duration_VCH)*wage*caregiver_15
FM_IC_VCH_3 <- (fm_appt + fm_wait + duration_VCH)*wage*caregiver_15
FM_IC_FH_1 <- (fm_appt + fm_wait + duration_FH)*wage*caregiver_0_14
FM_IC_FH_2 <- (fm_appt + fm_wait + duration_FH)*wage*caregiver_15
FM_IC_FH_3 <- (fm_appt + fm_wait + duration_FH)*wage*caregiver_15
FM_IC_VIH_1 <- (fm_appt + fm_wait + duration_VIH)*wage*caregiver_0_14
FM_IC_VIH_2 <- (fm_appt + fm_wait + duration_VIH)*wage*caregiver_15
FM_IC_VIH_3 <- (fm_appt + fm_wait + duration_VIH)*wage*caregiver_15

# Out of Pocket
FM_OOP_NH_1 <- (distance_NH*car_cost_per_km)+park_fm_NH
FM_OOP_NH_2 <- (distance_NH*car_cost_per_km)+park_fm_NH
FM_OOP_NH_3 <- (distance_NH*car_cost_per_km)+park_fm_NH
FM_OOP_IH_1 <- (distance_IH*car_cost_per_km)+park_fm_IH
FM_OOP_IH_2 <- (distance_IH*car_cost_per_km)+park_fm_IH
FM_OOP_IH_3 <- (distance_IH*car_cost_per_km)+park_fm_IH
FM_OOP_VCH_1 <- (distance_VCH*car_cost_per_km)+park_fm_VCH
FM_OOP_VCH_2 <- (distance_VCH*car_cost_per_km)+park_fm_VCH
FM_OOP_VCH_3 <- (distance_VCH*car_cost_per_km)+park_fm_VCH
FM_OOP_VIH_1 <- (distance_VIH*car_cost_per_km)+park_fm_VIH
FM_OOP_VIH_2 <- (distance_VIH*car_cost_per_km)+park_fm_VIH
FM_OOP_VIH_3 <- (distance_VIH*car_cost_per_km)+park_fm_VIH
FM_OOP_FH_1 <- (distance_FH*car_cost_per_km)+park_fm_FH
FM_OOP_FH_2 <- (distance_FH*car_cost_per_km)+park_fm_FH
FM_OOP_FH_3 <- (distance_FH*car_cost_per_km)+park_fm_FH

# Total Unit
FM_PFC_NH_1 <- FM_LP_NH_1 + FM_IC_NH_1 + FM_OOP_NH_1
FM_PFC_NH_2 <- FM_LP_NH_2 + FM_IC_NH_2 + FM_OOP_NH_2
FM_PFC_NH_3 <- FM_LP_NH_3 + FM_IC_NH_3 + FM_OOP_NH_3
FM_PFC_IH_1 <- FM_LP_IH_1 + FM_IC_IH_1 + FM_OOP_IH_1
FM_PFC_IH_2 <- FM_LP_IH_2 + FM_IC_IH_2 + FM_OOP_IH_2
FM_PFC_IH_3 <- FM_LP_IH_3 + FM_IC_IH_3 + FM_OOP_IH_3
FM_PFC_VCH_1 <- FM_LP_VCH_1 + FM_IC_VCH_1 + FM_OOP_VCH_1
FM_PFC_VCH_2 <- FM_LP_VCH_2 + FM_IC_VCH_2 + FM_OOP_VCH_2
FM_PFC_VCH_3 <- FM_LP_VCH_3 + FM_IC_VCH_3 + FM_OOP_VCH_3
FM_PFC_VIH_1 <- FM_LP_VIH_1 + FM_IC_VIH_1 + FM_OOP_VIH_1
FM_PFC_VIH_2 <- FM_LP_VIH_2 + FM_IC_VIH_2 + FM_OOP_VIH_2
FM_PFC_VIH_3 <- FM_LP_VIH_3 + FM_IC_VIH_3 + FM_OOP_VIH_3
FM_PFC_FH_1 <- FM_LP_FH_1 + FM_IC_FH_1 + FM_OOP_FH_1
FM_PFC_FH_2 <- FM_LP_FH_2 + FM_IC_FH_2 + FM_OOP_FH_2
FM_PFC_FH_3 <- FM_LP_FH_3 + FM_IC_FH_3 + FM_OOP_FH_3

# Add to costs database
pfc[nrow(pfc) + 1,] <- c("FM_PFC_NH_1", "societal", "family medicine", "Northern", NA, "0-14", FM_PFC_NH_1, FM_LP_NH_1, FM_IC_NH_1, FM_OOP_NH_1)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_NH_2", "societal", "family medicine", "Northern", NA, "15-64", FM_PFC_NH_2, FM_LP_NH_2, FM_IC_NH_2, FM_OOP_NH_2)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_NH_3", "societal", "family medicine", "Northern", NA, "65+", FM_PFC_NH_3, FM_LP_NH_3, FM_IC_NH_3, FM_OOP_NH_3)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_IH_1", "societal", "family medicine", "Interior", NA, "0-14", FM_PFC_IH_1, FM_LP_IH_1, FM_IC_IH_1, FM_OOP_IH_1)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_IH_2", "societal", "family medicine", "Interior", NA, "15-64", FM_PFC_IH_2, FM_LP_IH_2, FM_IC_IH_2, FM_OOP_IH_2)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_IH_3", "societal", "family medicine", "Interior", NA, "65+", FM_PFC_IH_3, FM_LP_IH_3, FM_IC_IH_3, FM_OOP_IH_3)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_VCH_1", "societal", "family medicine", "Vancouver Coastal", NA, "0-14", FM_PFC_VCH_1, FM_LP_VCH_1, FM_IC_VCH_1, FM_OOP_VCH_1)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_VCH_2", "societal", "family medicine", "Vancouver Coastal", NA, "15-64", FM_PFC_VCH_2, FM_LP_VCH_2, FM_IC_VCH_2, FM_OOP_VCH_2)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_VCH_3", "societal", "family medicine", "Vancouver Coastal", NA, "65+", FM_PFC_VCH_3, FM_LP_VCH_3, FM_IC_VCH_3, FM_OOP_VCH_3)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_VIH_1", "societal", "family medicine", "Vancouver Island", NA, "0-14", FM_PFC_VIH_1, FM_LP_VIH_1, FM_IC_VIH_1, FM_OOP_VIH_1)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_VIH_2", "societal", "family medicine", "Vancouver Island", NA, "15-64", FM_PFC_VIH_2, FM_LP_VIH_2, FM_IC_VIH_2, FM_OOP_VIH_2)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_VIH_3", "societal", "family medicine", "Vancouver Island", NA, "65+", FM_PFC_VIH_3, FM_LP_VIH_3, FM_IC_VIH_3, FM_OOP_VIH_3)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_FH_1", "societal", "family medicine", "Fraser", NA, "0-14", FM_PFC_FH_1, FM_LP_FH_1, FM_IC_FH_1, FM_OOP_FH_1)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_FH_2", "societal", "family medicine", "Fraser", NA, "15-64", FM_PFC_FH_2, FM_LP_FH_2, FM_IC_FH_2, FM_OOP_FH_2)
pfc[nrow(pfc) + 1,] <- c("FM_PFC_FH_3", "societal", "family medicine", "Fraser", NA, "65+", FM_PFC_FH_3, FM_LP_FH_3, FM_IC_FH_3, FM_OOP_FH_3)

## ED

# Lost Productivity

ED_LP_NH_CTAS_III_1 <- 0
ED_LP_NH_CTAS_III_2 <- (ed_los_CTAS_III + duration_NH)*wage
ED_LP_NH_CTAS_III_3 <- 0
ED_LP_NH_CTAS_V_1 <- 0
ED_LP_NH_CTAS_V_2 <- (ed_los_CTAS_V + duration_NH)*wage
ED_LP_NH_CTAS_V_3 <- 0
ED_LP_IH_CTAS_III_1 <- 0
ED_LP_IH_CTAS_III_2 <- (ed_los_CTAS_III + duration_IH)*wage
ED_LP_IH_CTAS_III_3 <- 0
ED_LP_IH_CTAS_V_1 <- 0
ED_LP_IH_CTAS_V_2 <- (ed_los_CTAS_V + duration_VCH)*wage
ED_LP_IH_CTAS_V_3 <- 0
ED_LP_VCH_CTAS_III_1 <- 0
ED_LP_VCH_CTAS_III_2 <- (ed_los_CTAS_III + duration_VCH)*wage
ED_LP_VCH_CTAS_III_3 <- 0
ED_LP_VCH_CTAS_V_1 <- 0
ED_LP_VCH_CTAS_V_2 <- (ed_los_CTAS_V + duration_VCH)*wage
ED_LP_VCH_CTAS_V_3 <- 0
ED_LP_VIH_CTAS_III_1 <- 0
ED_LP_VIH_CTAS_III_2 <- (ed_los_CTAS_III + duration_VIH)*wage
ED_LP_VIH_CTAS_III_3 <- 0
ED_LP_VIH_CTAS_V_1 <- 0
ED_LP_VIH_CTAS_V_2 <- (ed_los_CTAS_V + duration_VIH)*wage
ED_LP_VIH_CTAS_V_3 <- 0
ED_LP_FH_CTAS_III_1 <- 0
ED_LP_FH_CTAS_III_2 <- (ed_los_CTAS_III + duration_FH)*wage
ED_LP_FH_CTAS_III_3 <- 0
ED_LP_FH_CTAS_V_1 <- 0
ED_LP_FH_CTAS_V_2 <- (ed_los_CTAS_V + duration_FH)*wage
ED_LP_FH_CTAS_V_3 <- 0

# Informal Caregiving
ED_IC_NH_CTAS_III_1 <- (ed_los_CTAS_III + duration_NH)*wage*caregiver_0_14
ED_IC_NH_CTAS_III_2 <- (ed_los_CTAS_III + duration_NH)*wage*caregiver_15
ED_IC_NH_CTAS_III_3 <- (ed_los_CTAS_III + duration_NH)*wage*caregiver_15
ED_IC_NH_CTAS_V_1 <- (ed_los_CTAS_V + duration_NH)*wage*caregiver_0_14
ED_IC_NH_CTAS_V_2 <- (ed_los_CTAS_V + duration_NH)*wage*caregiver_15
ED_IC_NH_CTAS_V_3 <- (ed_los_CTAS_V + duration_NH)*wage*caregiver_15
ED_IC_IH_CTAS_III_1 <- (ed_los_CTAS_III + duration_IH)*wage*caregiver_0_14
ED_IC_IH_CTAS_III_2 <- (ed_los_CTAS_III + duration_IH)*wage*caregiver_15
ED_IC_IH_CTAS_III_3 <- (ed_los_CTAS_III + duration_IH)*wage*caregiver_15
ED_IC_IH_CTAS_V_1 <- (ed_los_CTAS_V + duration_IH)*wage*caregiver_0_14
ED_IC_IH_CTAS_V_2 <- (ed_los_CTAS_V + duration_IH)*wage*caregiver_15
ED_IC_IH_CTAS_V_3 <- (ed_los_CTAS_V + duration_IH)*wage*caregiver_15
ED_IC_VCH_CTAS_III_1 <- (ed_los_CTAS_III + duration_VCH)*wage*caregiver_0_14
ED_IC_VCH_CTAS_III_2 <- (ed_los_CTAS_III + duration_VCH)*wage*caregiver_15
ED_IC_VCH_CTAS_III_3 <- (ed_los_CTAS_III + duration_VCH)*wage*caregiver_15
ED_IC_VCH_CTAS_V_1 <- (ed_los_CTAS_V + duration_VCH)*wage*caregiver_0_14
ED_IC_VCH_CTAS_V_2 <- (ed_los_CTAS_V + duration_VCH)*wage*caregiver_15
ED_IC_VCH_CTAS_V_3 <- (ed_los_CTAS_V + duration_VCH)*wage*caregiver_15
ED_IC_VIH_CTAS_III_1 <- (ed_los_CTAS_III + duration_VIH)*wage*caregiver_0_14
ED_IC_VIH_CTAS_III_2 <- (ed_los_CTAS_III + duration_VIH)*wage*caregiver_15
ED_IC_VIH_CTAS_III_3 <- (ed_los_CTAS_III + duration_VIH)*wage*caregiver_15
ED_IC_VIH_CTAS_V_1 <- (ed_los_CTAS_V + duration_VIH)*wage*caregiver_0_14
ED_IC_VIH_CTAS_V_2 <- (ed_los_CTAS_V + duration_VIH)*wage*caregiver_15
ED_IC_VIH_CTAS_V_3 <- (ed_los_CTAS_V + duration_VIH)*wage*caregiver_15
ED_IC_FH_CTAS_III_1 <- (ed_los_CTAS_III + duration_FH)*wage*caregiver_0_14
ED_IC_FH_CTAS_III_2 <- (ed_los_CTAS_III + duration_FH)*wage*caregiver_15
ED_IC_FH_CTAS_III_3 <- (ed_los_CTAS_III + duration_FH)*wage*caregiver_15
ED_IC_FH_CTAS_V_1 <- (ed_los_CTAS_V + duration_FH)*wage*caregiver_0_14
ED_IC_FH_CTAS_V_2 <- (ed_los_CTAS_V + duration_FH)*wage*caregiver_15
ED_IC_FH_CTAS_V_3 <- (ed_los_CTAS_V + duration_FH)*wage*caregiver_15

# Out of Pocket
ED_OOP_NH_CTAS_III_1 <- (distance_NH*car_cost_per_km) + meal_cost + park_ed_NH
ED_OOP_NH_CTAS_III_2 <- (distance_NH*car_cost_per_km) + meal_cost + park_ed_NH
ED_OOP_NH_CTAS_III_3 <- (distance_NH*car_cost_per_km) + meal_cost + park_ed_NH
ED_OOP_NH_CTAS_V_1 <- (distance_NH*car_cost_per_km) + meal_cost + park_ed_NH
ED_OOP_NH_CTAS_V_2 <- (distance_NH*car_cost_per_km) + meal_cost + park_ed_NH
ED_OOP_NH_CTAS_V_3 <- (distance_NH*car_cost_per_km) + meal_cost + park_ed_NH
ED_OOP_IH_CTAS_III_1 <- (distance_IH*car_cost_per_km) + meal_cost + park_ed_IH
ED_OOP_IH_CTAS_III_2 <- (distance_IH*car_cost_per_km) + meal_cost + park_ed_IH
ED_OOP_IH_CTAS_III_3 <- (distance_IH*car_cost_per_km) + meal_cost + park_ed_IH
ED_OOP_IH_CTAS_V_1 <- (distance_IH*car_cost_per_km) + meal_cost + park_ed_IH
ED_OOP_IH_CTAS_V_2 <- (distance_IH*car_cost_per_km) + meal_cost + park_ed_IH
ED_OOP_IH_CTAS_V_3 <- (distance_IH*car_cost_per_km) + meal_cost + park_ed_IH
ED_OOP_VCH_CTAS_III_1 <- (distance_VCH*car_cost_per_km) + meal_cost + park_ed_VCH
ED_OOP_VCH_CTAS_III_2 <- (distance_VCH*car_cost_per_km) + meal_cost + park_ed_VCH
ED_OOP_VCH_CTAS_III_3 <- (distance_VCH*car_cost_per_km) + meal_cost + park_ed_VCH
ED_OOP_VCH_CTAS_V_1 <- (distance_VCH*car_cost_per_km) + meal_cost + park_ed_VCH
ED_OOP_VCH_CTAS_V_2 <- (distance_VCH*car_cost_per_km) + meal_cost + park_ed_VCH
ED_OOP_VCH_CTAS_V_3 <- (distance_VCH*car_cost_per_km) + meal_cost + park_ed_VCH
ED_OOP_VIH_CTAS_III_1 <- (distance_VIH*car_cost_per_km) + meal_cost + park_ed_VIH
ED_OOP_VIH_CTAS_III_2 <- (distance_VIH*car_cost_per_km) + meal_cost + park_ed_VIH
ED_OOP_VIH_CTAS_III_3 <- (distance_VIH*car_cost_per_km) + meal_cost + park_ed_VIH
ED_OOP_VIH_CTAS_V_1 <- (distance_VIH*car_cost_per_km) + meal_cost + park_ed_VIH
ED_OOP_VIH_CTAS_V_2 <- (distance_VIH*car_cost_per_km) + meal_cost + park_ed_VIH
ED_OOP_VIH_CTAS_V_3 <- (distance_VIH*car_cost_per_km) + meal_cost + park_ed_VIH
ED_OOP_FH_CTAS_III_1 <- (distance_FH*car_cost_per_km) + meal_cost + park_ed_FH
ED_OOP_FH_CTAS_III_2 <- (distance_FH*car_cost_per_km) + meal_cost + park_ed_FH
ED_OOP_FH_CTAS_III_3 <- (distance_FH*car_cost_per_km) + meal_cost + park_ed_FH
ED_OOP_FH_CTAS_V_1 <- (distance_FH*car_cost_per_km) + meal_cost + park_ed_FH
ED_OOP_FH_CTAS_V_2 <- (distance_FH*car_cost_per_km) + meal_cost + park_ed_FH
ED_OOP_FH_CTAS_V_3 <- (distance_FH*car_cost_per_km) + meal_cost + park_ed_FH

# Total Unit
ED_PFC_NH_CTAS_III_1 <- ED_LP_NH_CTAS_III_1 + ED_IC_NH_CTAS_III_1 + ED_OOP_NH_CTAS_III_1
ED_PFC_NH_CTAS_III_2 <- ED_LP_NH_CTAS_III_2 + ED_IC_NH_CTAS_III_2 + ED_OOP_NH_CTAS_III_2
ED_PFC_NH_CTAS_III_3 <- ED_LP_NH_CTAS_III_3 + ED_IC_NH_CTAS_III_3 + ED_OOP_NH_CTAS_III_3
ED_PFC_NH_CTAS_V_1 <- ED_LP_NH_CTAS_V_1 + ED_IC_NH_CTAS_V_1 + ED_OOP_NH_CTAS_V_1
ED_PFC_NH_CTAS_V_2 <- ED_LP_NH_CTAS_V_2 + ED_IC_NH_CTAS_V_2 + ED_OOP_NH_CTAS_V_2
ED_PFC_NH_CTAS_V_3 <- ED_LP_NH_CTAS_V_3 + ED_IC_NH_CTAS_V_3 + ED_OOP_NH_CTAS_V_3
ED_PFC_IH_CTAS_III_1 <- ED_LP_IH_CTAS_III_1 + ED_IC_IH_CTAS_III_1 + ED_OOP_IH_CTAS_III_1
ED_PFC_IH_CTAS_III_2 <- ED_LP_IH_CTAS_III_2 + ED_IC_IH_CTAS_III_2 + ED_OOP_IH_CTAS_III_2
ED_PFC_IH_CTAS_III_3 <- ED_LP_IH_CTAS_III_3 + ED_IC_IH_CTAS_III_3 + ED_OOP_IH_CTAS_III_3
ED_PFC_IH_CTAS_V_1 <- ED_LP_IH_CTAS_V_1 + ED_IC_IH_CTAS_V_1 + ED_OOP_IH_CTAS_V_1
ED_PFC_IH_CTAS_V_2 <- ED_LP_IH_CTAS_V_2 + ED_IC_IH_CTAS_V_2 + ED_OOP_IH_CTAS_V_2
ED_PFC_IH_CTAS_V_3 <- ED_LP_IH_CTAS_V_3 + ED_IC_IH_CTAS_V_3 + ED_OOP_IH_CTAS_V_3
ED_PFC_VCH_CTAS_III_1 <- ED_LP_VCH_CTAS_III_1 + ED_IC_VCH_CTAS_III_1 + ED_OOP_VCH_CTAS_III_1
ED_PFC_VCH_CTAS_III_2 <- ED_LP_VCH_CTAS_III_2 + ED_IC_VCH_CTAS_III_2 + ED_OOP_VCH_CTAS_III_2
ED_PFC_VCH_CTAS_III_3 <- ED_LP_VCH_CTAS_III_3 + ED_IC_VCH_CTAS_III_3 + ED_OOP_VCH_CTAS_III_3
ED_PFC_VCH_CTAS_V_1 <- ED_LP_VCH_CTAS_V_1 + ED_IC_VCH_CTAS_V_1 + ED_OOP_VCH_CTAS_V_1
ED_PFC_VCH_CTAS_V_2 <- ED_LP_VCH_CTAS_V_2 + ED_IC_VCH_CTAS_V_2 + ED_OOP_VCH_CTAS_V_2
ED_PFC_VCH_CTAS_V_3 <- ED_LP_VCH_CTAS_V_3 + ED_IC_VCH_CTAS_V_3 + ED_OOP_VCH_CTAS_V_3
ED_PFC_VIH_CTAS_III_1 <- ED_LP_VIH_CTAS_III_1 + ED_IC_VIH_CTAS_III_1 + ED_OOP_VIH_CTAS_III_1
ED_PFC_VIH_CTAS_III_2 <- ED_LP_VIH_CTAS_III_2 + ED_IC_VIH_CTAS_III_2 + ED_OOP_VIH_CTAS_III_2
ED_PFC_VIH_CTAS_III_3 <- ED_LP_VIH_CTAS_III_3 + ED_IC_VIH_CTAS_III_3 + ED_OOP_VIH_CTAS_III_3
ED_PFC_VIH_CTAS_V_1 <- ED_LP_VIH_CTAS_V_1 + ED_IC_VIH_CTAS_V_1 + ED_OOP_VIH_CTAS_V_1
ED_PFC_VIH_CTAS_V_2 <- ED_LP_VIH_CTAS_V_2 + ED_IC_VIH_CTAS_V_2 + ED_OOP_VIH_CTAS_V_2
ED_PFC_VIH_CTAS_V_3 <- ED_LP_VIH_CTAS_V_3 + ED_IC_VIH_CTAS_V_3 + ED_OOP_VIH_CTAS_V_3
ED_PFC_FH_CTAS_III_1 <- ED_LP_FH_CTAS_III_1 + ED_IC_FH_CTAS_III_1 + ED_OOP_FH_CTAS_III_1
ED_PFC_FH_CTAS_III_2 <- ED_LP_FH_CTAS_III_2 + ED_IC_FH_CTAS_III_2 + ED_OOP_FH_CTAS_III_2
ED_PFC_FH_CTAS_III_3 <- ED_LP_FH_CTAS_III_3 + ED_IC_FH_CTAS_III_3 + ED_OOP_FH_CTAS_III_3
ED_PFC_FH_CTAS_V_1 <- ED_LP_FH_CTAS_V_1 + ED_IC_FH_CTAS_V_1 + ED_OOP_FH_CTAS_V_1
ED_PFC_FH_CTAS_V_2 <- ED_LP_FH_CTAS_V_2 + ED_IC_FH_CTAS_V_2 + ED_OOP_FH_CTAS_V_2
ED_PFC_FH_CTAS_V_3 <- ED_LP_FH_CTAS_V_3 + ED_IC_FH_CTAS_V_3 + ED_OOP_FH_CTAS_V_3

# Add costs to database
pfc[nrow(pfc) + 1,] <- c("ED_PFC_NH_CTAS_III_1", "societal", "emergency", "Northern", "1-3", "0-14", ED_PFC_NH_CTAS_III_1, ED_LP_NH_CTAS_III_1, ED_IC_NH_CTAS_III_1, ED_OOP_NH_CTAS_III_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_NH_CTAS_III_2", "societal", "emergency", "Northern", "1-3", "15-64", ED_PFC_NH_CTAS_III_2, ED_LP_NH_CTAS_III_2, ED_IC_NH_CTAS_III_2, ED_OOP_NH_CTAS_III_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_NH_CTAS_III_3", "societal", "emergency", "Northern", "1-3", "65+", ED_PFC_NH_CTAS_III_3, ED_LP_NH_CTAS_III_3, ED_IC_NH_CTAS_III_3, ED_OOP_NH_CTAS_III_3)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_NH_CTAS_V_1", "societal", "emergency", "Northern", "4-5", "0-14", ED_PFC_NH_CTAS_V_1, ED_LP_NH_CTAS_V_1, ED_IC_NH_CTAS_V_1, ED_OOP_NH_CTAS_V_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_NH_CTAS_V_2", "societal", "emergency", "Northern", "4-5", "15-64", ED_PFC_NH_CTAS_V_2, ED_LP_NH_CTAS_V_2, ED_IC_NH_CTAS_V_2, ED_OOP_NH_CTAS_V_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_NH_CTAS_V_3", "societal", "emergency", "Northern", "4-5", "65+", ED_PFC_NH_CTAS_V_3, ED_LP_NH_CTAS_V_3, ED_IC_NH_CTAS_V_3, ED_OOP_NH_CTAS_V_3)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_IH_CTAS_III_1", "societal", "emergency", "Interior", "1-3", "0-14", ED_PFC_IH_CTAS_III_1, ED_LP_IH_CTAS_III_1, ED_IC_IH_CTAS_III_1, ED_OOP_IH_CTAS_III_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_IH_CTAS_III_2", "societal", "emergency", "Interior", "1-3", "15-64", ED_PFC_IH_CTAS_III_2, ED_LP_IH_CTAS_III_2, ED_IC_IH_CTAS_III_2, ED_OOP_IH_CTAS_III_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_IH_CTAS_III_3", "societal", "emergency", "Interior", "1-3", "65+", ED_PFC_IH_CTAS_III_3, ED_LP_IH_CTAS_III_3, ED_IC_IH_CTAS_III_3, ED_OOP_IH_CTAS_III_3)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_IH_CTAS_V_1", "societal", "emergency", "Interior", "4-5", "0-14", ED_PFC_IH_CTAS_V_1, ED_LP_IH_CTAS_V_1, ED_IC_IH_CTAS_V_1, ED_OOP_IH_CTAS_V_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_IH_CTAS_V_2", "societal", "emergency", "Interior", "4-5", "15-64", ED_PFC_IH_CTAS_V_2, ED_LP_IH_CTAS_V_2, ED_IC_IH_CTAS_V_2, ED_OOP_IH_CTAS_V_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_IH_CTAS_V_3", "societal", "emergency", "Interior", "4-5", "65+", ED_PFC_IH_CTAS_V_3, ED_LP_IH_CTAS_V_3, ED_IC_IH_CTAS_V_3, ED_OOP_IH_CTAS_V_3)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VCH_CTAS_III_1", "societal", "emergency", "Vancouver Coastal", "1-3", "0-14", ED_PFC_VCH_CTAS_III_1, ED_LP_VCH_CTAS_III_1, ED_IC_VCH_CTAS_III_1, ED_OOP_VCH_CTAS_III_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VCH_CTAS_III_2", "societal", "emergency", "Vancouver Coastal", "1-3", "15-64", ED_PFC_VCH_CTAS_III_2, ED_LP_VCH_CTAS_III_2, ED_IC_VCH_CTAS_III_2, ED_OOP_VCH_CTAS_III_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VCH_CTAS_III_3", "societal", "emergency", "Vancouver Coastal", "1-3", "65+", ED_PFC_VCH_CTAS_III_3, ED_LP_VCH_CTAS_III_3, ED_IC_VCH_CTAS_III_3, ED_OOP_VCH_CTAS_III_3)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VCH_CTAS_V_1", "societal", "emergency", "Vancouver Coastal", "4-5", "0-14", ED_PFC_VCH_CTAS_V_1, ED_LP_VCH_CTAS_V_1, ED_IC_VCH_CTAS_V_1, ED_OOP_VCH_CTAS_V_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VCH_CTAS_V_2", "societal", "emergency", "Vancouver Coastal", "4-5", "15-64", ED_PFC_VCH_CTAS_V_2, ED_LP_VCH_CTAS_V_2, ED_IC_VCH_CTAS_V_2, ED_OOP_VCH_CTAS_V_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VCH_CTAS_V_3", "societal", "emergency", "Vancouver Coastal", "4-5", "65+", ED_PFC_VCH_CTAS_V_3, ED_LP_VCH_CTAS_V_3, ED_IC_VCH_CTAS_V_3, ED_OOP_VCH_CTAS_V_3)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VIH_CTAS_III_1", "societal", "emergency", "Vancouver Island", "1-3", "0-14", ED_PFC_VIH_CTAS_III_1, ED_LP_VIH_CTAS_III_1, ED_IC_VIH_CTAS_III_1, ED_OOP_VIH_CTAS_III_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VIH_CTAS_III_2", "societal", "emergency", "Vancouver Island", "1-3", "15-64", ED_PFC_VIH_CTAS_III_2, ED_LP_VIH_CTAS_III_2, ED_IC_VIH_CTAS_III_2, ED_OOP_VIH_CTAS_III_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VIH_CTAS_III_3", "societal", "emergency", "Vancouver Island", "1-3", "65+", ED_PFC_VIH_CTAS_III_3, ED_LP_VIH_CTAS_III_3, ED_IC_VIH_CTAS_III_3, ED_OOP_VIH_CTAS_III_3)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VIH_CTAS_V_1", "societal", "emergency", "Vancouver Island", "4-5", "0-14", ED_PFC_VIH_CTAS_V_1, ED_LP_VIH_CTAS_V_1, ED_IC_VIH_CTAS_V_1, ED_OOP_VIH_CTAS_V_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VIH_CTAS_V_2", "societal", "emergency", "Vancouver Island", "4-5", "15-64", ED_PFC_VIH_CTAS_V_2, ED_LP_VIH_CTAS_V_2, ED_IC_VIH_CTAS_V_2, ED_OOP_VIH_CTAS_V_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_VIH_CTAS_V_3", "societal", "emergency", "Vancouver Island", "4-5", "65+", ED_PFC_VIH_CTAS_V_3, ED_LP_VIH_CTAS_V_3, ED_IC_VIH_CTAS_V_3, ED_OOP_VIH_CTAS_V_3)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_FH_CTAS_III_1", "societal", "emergency", "Fraser", "1-3", "0-14", ED_PFC_FH_CTAS_III_1, ED_LP_FH_CTAS_III_1, ED_IC_FH_CTAS_III_1, ED_OOP_FH_CTAS_III_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_FH_CTAS_III_2", "societal", "emergency", "Fraser", "1-3", "15-64", ED_PFC_FH_CTAS_III_2, ED_LP_FH_CTAS_III_2, ED_IC_FH_CTAS_III_2, ED_OOP_FH_CTAS_III_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_FH_CTAS_III_3", "societal", "emergency", "Fraser", "1-3", "65+", ED_PFC_FH_CTAS_III_3, ED_LP_FH_CTAS_III_3, ED_IC_FH_CTAS_III_3, ED_OOP_FH_CTAS_III_3)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_FH_CTAS_V_1", "societal", "emergency", "Fraser", "4-5", "0-14", ED_PFC_FH_CTAS_V_1, ED_LP_FH_CTAS_V_1, ED_IC_FH_CTAS_V_1, ED_OOP_FH_CTAS_V_1)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_FH_CTAS_V_2", "societal", "emergency", "Fraser", "4-5", "15-64", ED_PFC_FH_CTAS_V_2, ED_LP_FH_CTAS_V_2, ED_IC_FH_CTAS_V_2, ED_OOP_FH_CTAS_V_2)
pfc[nrow(pfc) + 1,] <- c("ED_PFC_FH_CTAS_V_3", "societal", "emergency", "Fraser", "4-5", "65+", ED_PFC_FH_CTAS_V_3, ED_LP_FH_CTAS_V_3, ED_IC_FH_CTAS_V_3, ED_OOP_FH_CTAS_V_3)

## Hospitalization

# Lost Productivity

HP_LP_NH_1 <- 0
HP_LP_NH_2 <- (hosp_los + duration_IH)*wage
HP_LP_NH_3 <- 0
HP_LP_IH_1 <- 0
HP_LP_IH_2 <- (hosp_los + duration_IH)*wage
HP_LP_IH_3 <- 0
HP_LP_VCH_1 <- 0
HP_LP_VCH_2 <- (hosp_los + duration_VCH)*wage
HP_LP_VCH_3 <- 0
HP_LP_VIH_1 <- 0
HP_LP_VIH_2 <- (hosp_los + duration_VIH)*wage
HP_LP_VIH_3 <- 0
HP_LP_FH_1 <- 0
HP_LP_FH_2 <- (hosp_los + duration_FH)*wage
HP_LP_FH_3 <- 0


# Informal Caregiving
HP_IC_NH_1 <- (hosp_los+duration_NH)*wage*caregiver_hosp_0_14
HP_IC_NH_2 <- (hosp_los+duration_NH)*wage*caregiver_hosp_15
HP_IC_NH_3 <- (hosp_los+duration_NH)*wage*caregiver_hosp_15
HP_IC_IH_1 <- (hosp_los+duration_IH)*wage*caregiver_hosp_0_14
HP_IC_IH_2 <- (hosp_los+duration_IH)*wage*caregiver_hosp_15
HP_IC_IH_3 <- (hosp_los+duration_IH)*wage*caregiver_hosp_15
HP_IC_VCH_1 <- (hosp_los+duration_VCH)*wage*caregiver_hosp_0_14
HP_IC_VCH_2 <- (hosp_los+duration_VCH)*wage*caregiver_hosp_15
HP_IC_VCH_3 <- (hosp_los+duration_VCH)*wage*caregiver_hosp_15
HP_IC_VIH_1 <- (hosp_los+duration_VIH)*wage*caregiver_hosp_0_14
HP_IC_VIH_2 <- (hosp_los+duration_VIH)*wage*caregiver_hosp_15
HP_IC_VIH_3 <- (hosp_los+duration_VIH)*wage*caregiver_hosp_15
HP_IC_FH_1 <- (hosp_los+duration_FH)*wage*caregiver_hosp_0_14
HP_IC_FH_2 <- (hosp_los+duration_FH)*wage*caregiver_hosp_15
HP_IC_FH_3 <- (hosp_los+duration_FH)*wage*caregiver_hosp_15

# Out of Pocket
HP_OOP_NH_1 <- (distance_NH*car_cost_per_km) + (accomm*2*caregiver_hosp_0_14) + (meal_cost*3*2*caregiver_hosp_0_14) + park_ed_NH
HP_OOP_NH_2 <- (distance_NH*car_cost_per_km) + (accomm*2*caregiver_hosp_15) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_NH
HP_OOP_NH_3 <- (distance_NH*car_cost_per_km) + (accomm*2*caregiver_hosp_15) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_NH
HP_OOP_IH_1 <- (distance_IH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_0_14) + park_ed_IH
HP_OOP_IH_2 <- (distance_IH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_IH
HP_OOP_IH_3 <- (distance_IH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_IH
HP_OOP_VCH_1 <- (distance_VCH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_0_14) + park_ed_VCH
HP_OOP_VCH_2 <- (distance_VCH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_VCH
HP_OOP_VCH_3 <- (distance_VCH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_VCH
HP_OOP_VIH_1 <- (distance_VIH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_0_14) + park_ed_VIH
HP_OOP_VIH_2 <- (distance_VIH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_VIH
HP_OOP_VIH_3 <- (distance_VIH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_VIH
HP_OOP_FH_1 <- (distance_FH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_0_14) + park_ed_FH
HP_OOP_FH_2 <- (distance_FH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_FH
HP_OOP_FH_3 <- (distance_FH*car_cost_per_km) + (meal_cost*3*2*caregiver_hosp_15) + park_ed_FH

# Total Unit
HP_PFC_NH_1 <- HP_LP_NH_1 + HP_IC_NH_1 + HP_OOP_NH_1
HP_PFC_NH_2 <- HP_LP_NH_2 + HP_IC_NH_2 + HP_OOP_NH_2
HP_PFC_NH_3 <- HP_LP_NH_3 + HP_IC_NH_3 + HP_OOP_NH_3
HP_PFC_IH_1 <- HP_LP_IH_1 + HP_IC_IH_1 + HP_OOP_IH_1
HP_PFC_IH_2 <- HP_LP_IH_2 + HP_IC_IH_2 + HP_OOP_IH_2
HP_PFC_IH_3 <- HP_LP_IH_3 + HP_IC_IH_3 + HP_OOP_IH_3
HP_PFC_VCH_1 <- HP_LP_VCH_1 + HP_IC_VCH_1 + HP_OOP_VCH_1
HP_PFC_VCH_2 <- HP_LP_VCH_2 + HP_IC_VCH_2 + HP_OOP_VCH_2
HP_PFC_VCH_3 <- HP_LP_VCH_3 + HP_IC_VCH_3 + HP_OOP_VCH_3
HP_PFC_VIH_1 <- HP_LP_VIH_1 + HP_IC_VIH_1 + HP_OOP_VIH_1
HP_PFC_VIH_2 <- HP_LP_VIH_2 + HP_IC_VIH_2 + HP_OOP_VIH_2
HP_PFC_VIH_3 <- HP_LP_VIH_3 + HP_IC_VIH_3 + HP_OOP_VIH_3
HP_PFC_FH_1 <- HP_LP_FH_1 + HP_IC_FH_1 + HP_OOP_FH_1
HP_PFC_FH_2 <- HP_LP_FH_2 + HP_IC_FH_2 + HP_OOP_FH_2
HP_PFC_FH_3 <- HP_LP_FH_3 + HP_IC_FH_3 + HP_OOP_FH_3

# Add costs to database
pfc[nrow(pfc) + 1,] <- c("HP_PFC_NH_1", "societal", "hospitalization", "Northern", NA, "0-14", HP_PFC_NH_1, HP_LP_NH_1, HP_IC_NH_1, HP_OOP_NH_1)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_NH_2", "societal", "hospitalization", "Northern", NA, "15-64", HP_PFC_NH_2, HP_LP_NH_2, HP_IC_NH_2, HP_OOP_NH_2)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_NH_3", "societal", "hospitalization", "Northern", NA, "65+", HP_PFC_NH_3, HP_LP_NH_3, HP_IC_NH_3, HP_OOP_NH_3)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_IH_1", "societal", "hospitalization", "Interior", NA, "0-14", HP_PFC_IH_1, HP_LP_IH_1, HP_IC_IH_1, HP_OOP_IH_1)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_IH_2", "societal", "hospitalization", "Interior", NA, "15-64", HP_PFC_IH_2, HP_LP_IH_2, HP_IC_IH_2, HP_OOP_IH_2)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_IH_3", "societal", "hospitalization", "Interior", NA, "65+", HP_PFC_IH_3, HP_LP_IH_3, HP_IC_IH_3, HP_OOP_IH_3)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_VCH_1", "societal", "hospitalization", "Vancouver Coastal", NA, "0-14", HP_PFC_VCH_1, HP_LP_VCH_1, HP_IC_VCH_1, HP_OOP_VCH_1)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_VCH_2", "societal", "hospitalization", "Vancouver Coastal", NA, "15-64", HP_PFC_VCH_2, HP_LP_VCH_2, HP_IC_VCH_2, HP_OOP_VCH_2)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_VCH_3", "societal", "hospitalization", "Vancouver Coastal", NA, "65+", HP_PFC_VCH_3, HP_LP_VCH_3, HP_IC_VCH_3, HP_OOP_VCH_3)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_VIH_1", "societal", "hospitalization", "Vancouver Island", NA, "0-14", HP_PFC_VIH_1, HP_LP_VIH_1, HP_IC_VIH_1, HP_OOP_VIH_1)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_VIH_2", "societal", "hospitalization", "Vancouver Island", NA, "15-64", HP_PFC_VIH_2, HP_LP_VIH_2, HP_IC_VIH_2, HP_OOP_VIH_2)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_VIH_3", "societal", "hospitalization", "Vancouver Island", NA, "65+", HP_PFC_VIH_3, HP_LP_VIH_3, HP_IC_VIH_3, HP_OOP_VIH_3)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_FH_1", "societal", "hospitalization", "Fraser", NA, "0-14", HP_PFC_FH_1, HP_LP_FH_1, HP_IC_FH_1, HP_OOP_FH_1)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_FH_2", "societal", "hospitalization", "Fraser", NA, "15-64", HP_PFC_FH_2, HP_LP_FH_2, HP_IC_FH_2, HP_OOP_FH_2)
pfc[nrow(pfc) + 1,] <- c("HP_PFC_FH_3", "societal", "hospitalization", "Fraser", NA, "65+", HP_PFC_FH_3, HP_LP_FH_3, HP_IC_FH_3, HP_OOP_FH_3)

## Virtual 

# Lost Productivity 

VC_LP_1 <- 0
VC_LP_2 <- (virtual_appt + virtual_wait)*wage
VC_LP_3 <- 0

# Informal Caregiving
VC_IC_1 <- (virtual_appt + virtual_wait)*wage*caregiver_0_14
VC_IC_2 <- (virtual_appt + virtual_wait)*wage*caregiver_15
VC_IC_3 <- (virtual_appt + virtual_wait)*wage*caregiver_15

# Out of Pocket
VC_OOP_1 <- data_usage
VC_OOP_2 <- data_usage
VC_OOP_3 <- data_usage

# Total Unit
VC_PFC_1 <- VC_LP_1 + VC_IC_1 + VC_OOP_1
VC_PFC_2 <- VC_LP_2 + VC_IC_2 + VC_OOP_2
VC_PFC_3 <- VC_LP_3 + VC_IC_3 + VC_OOP_3

# Add to costs database
pfc[nrow(pfc) + 1,] <- c("VC_PFC_1", "societal", "virtual", NA, NA, "0-14", VC_PFC_1, VC_LP_1, VC_IC_1, VC_OOP_1)
pfc[nrow(pfc) + 1,] <- c("VC_PFC_2", "societal", "virtual", NA, NA, "15-64", VC_PFC_2, VC_LP_2, VC_IC_2, VC_OOP_2)
pfc[nrow(pfc) + 1,] <- c("VC_PFC_3", "societal", "virtual", NA, NA, "65+", VC_PFC_3, VC_LP_3, VC_IC_3, VC_OOP_3)





