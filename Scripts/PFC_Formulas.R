
# Define constants

fm_wait <- 0.5
fm_appt <- 0.26
caregiver_0_14 <- 1
caregiver_15 <- 0.5
car_cost_per_km <- 0.48

ed_los_CTAS_III <- 3.9
ed_los_CTAS_V <- 2.7


# Family Medicine

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
  
oop.fmed <- function(distance, meal, parking) {
    (distance*car_cost_per_km) + meal + parking
  }
  
PFC.fmed <- function (wage, distance, duration, age, meal, parking) {
  lp.fmed(wage, duration, age) + ic.fmed (wage, duration, age) + oop.fmed (distance, meal, parking)
  
}

# ED

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

oop.ed <- function (distance, meal, parking) {
  (distance*car_cost_per_km) + meal + parking
}

PFC.ed <- function (wage, distance, duration, age, meal, parking, acuity) {
  lp.ed(wage, duration, age, acuity) + ic.ed (wage, duration, age, acuity) + oop.ed (distance, meal, parking)
  
}

