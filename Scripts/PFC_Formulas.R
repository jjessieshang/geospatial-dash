
# Define constants

fm_wait <- 0.5
fm_appt <- 0.26
caregiver_0_14 <- 1
caregiver_15 <- 0.5
car_cost_per_km <- 0.48

ed_los_CTAS_III <- 3.9
ed_los_CTAS_V <- 2.7

hosp_los <- 53.6
caregiver_0_14_hosp <- 0.75
caregiver_15_hosp <- 0.25

data_usage <- 1.25
virtual_wait <- 0.27
virtual_appt <- 0.35

### FAMILY MEDICINE ###

# Define Lost Productivity subunit function
lp.fmed <- function (wage, duration, age) {
    if (age >= 0 & age <= 14) {
      lp <- 0  
    } 
    else if (age >= 15 & age <= 64){
      lp <- (fm_wait + fm_appt + duration)*wage
    }
    else {
      lp <- 0
    }
  }
  
# Define Informal Caregiving subunit function
ic.fmed <- function (wage, duration, age) {
    if (age >= 0 & age <= 14) {
      ic <- (fm_wait + fm_appt + duration)*wage*caregiver_0_14  
    } 
    else if (age >= 15 & age <= 64){
      ic <- (fm_wait + fm_appt + duration)*wage*caregiver_15
    }
    else {
      ic <- (fm_wait + fm_appt + duration)*wage*caregiver_15
    }
  }
  
# Define Out of Pocket subunit function
oop.fmed <- function(distance, meal, parking) {
    (distance*car_cost_per_km) + meal + parking
  }
  
# Define function to calculate FMed unit cost, set default parameter values 
PFC.fmed <- function (wage = 30.54, distance = 35, duration = 0.75, age = 40, meal = 0, parking = 3) {
  lp.fmed(wage, duration, age) + ic.fmed (wage, duration, age) + oop.fmed (distance, meal, parking)
  
}

### EMERGENCY DEPARTMENT ###

# Define Lost Productivity subunit function
lp.ed <- function(wage, duration, age, acuity) {
  if (acuity <= 3) {
    if (age >= 0 & age <= 14) {
      lp <- 0
    }
    else if (age >= 15 & age <=64) {
      lp <- (ed_los_CTAS_III + duration)*wage
    }
    else {
      lp <- 0
    }
  }
  else {
    if (age >= 0 & age <= 14) {
      lp <- 0
    }
    else if (age >= 15 & age <=64) {
      lp <- (ed_los_CTAS_V + duration)*wage
    }
    else {
      lp <- 0
    }
  }
}

# Define Informal Caregiving subunit function
ic.ed <- function(wage, duration, age, acuity) {
  if (acuity <= 3) {
    if (age >= 0 & age <= 14) {
      ic <- (ed_los_CTAS_III + duration)*wage*caregiver_0_14
    }
    else if (age >= 15 & age <=64) {
      ic <- (ed_los_CTAS_III + duration)*wage*caregiver_15
    }
    else {
      ic <- (ed_los_CTAS_III + duration)*wage*caregiver_15
    }
  }
  else {
    if (age >= 0 & age <= 14) {
      ic <- (ed_los_CTAS_V + duration)*wage*caregiver_0_14
    }
    else if (age >= 15 & age <=64) {
      ic <- (ed_los_CTAS_V + duration)*wage*caregiver_15
    }
    else {
      ic <- (ed_los_CTAS_V + duration)*wage*caregiver_15
    }
  }
}

# Define out of pocket subunit function
oop.ed <- function (distance, meal, parking) {
  (distance*car_cost_per_km) + meal + parking
}

# Define function to calculate ED unit cost, set default parameter values
PFC.ed <- function (wage = 30.54, distance = 35, duration = 0.75, age = 40, meal = 15, parking = 5, acuity = 4) {
  lp.ed(wage, duration, age, acuity) + ic.ed (wage, duration, age, acuity) + oop.ed (distance, meal, parking)
  
}

### HOSPITALIZATIONS ### 

# Define Lost Productivity subunit function
lp.hosp <- function (wage, duration, age) {
  if (age >= 0 & age <= 14) {
    lp <- 0  
  } 
  else if (age >= 15 & age <= 64){
    lp <- (hosp_los + duration)*wage
  }
  else {
    lp <- 0
  }
  
}

# Define Informal Caregiving subunit function
ic.hosp <- function (wage, duration, age) {
  if (age >= 0 & age <= 14) {
    ic <- (hosp_los + duration)*wage*caregiver_0_14_hosp  
  } 
  else if (age >= 15 & age <= 64){
    ic <- (hosp_los + duration)*wage*caregiver_15_hosp
  }
  else {
    ic <- (hosp_los + duration)*wage*caregiver_15_hosp
  }
}

# Define Out of Pocket subunit function
oop.hosp <- function(distance, meal, accommodation, parking) {
  (distance*car_cost_per_km) + meal + accommodation + parking
}

# Define function to calculate Hospitalization unit cost, set default parameter values
PFC.hosp <- function (wage = 30.54, distance = 35, duration = 0.75, age = 40, meal = 40 , accommodation = 0, parking = 20) {
  lp.hosp(wage, duration, age) + ic.hosp(wage, duration, age) + oop.hosp(distance, meal, accommodation, parking)
  
}

### VIRTUAL VISITS ###

# Define Lost Productivity subunit function
lp.virtual <- function (wage, age) {
  if (age >= 0 & age <= 14) {
    lp <- 0  
  } 
  else if (age >= 15 & age <= 64){
    lp <- (virtual_wait + virtual_appt)*wage
  }
  else {
    lp <- 0
  }
}

# Define Informal Caregiving subunit function
ic.virtual <- function (wage, age) {
  if (age >= 0 & age <= 14) {
    ic <- (virtual_wait + virtual_appt)*wage*caregiver_0_14  
  } 
  else if (age >= 15 & age <= 64){
    ic <- (virtual_wait + virtual_appt)*wage*caregiver_15
  }
  else {
    ic <- (virtual_wait + virtual_appt)*wage*caregiver_15
  }
}

# Define Out of Pocket subunit
oop.virtual <- data_usage

# Define function to calculate Hospitalization unit cost, set default parameter values
PFC.virtual <- function (wage = 30.54, age = 40) {
  lp.virtual(wage, age) + ic.virtual (wage, age) + oop.virtual
  
}
