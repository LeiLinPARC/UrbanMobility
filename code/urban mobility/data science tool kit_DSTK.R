
# Data Science Toolkit Demonstration
# http://www.datasciencetoolkit.org/
# 
# The RDSTK package is an R wrapper for the Data Science Toolkit API
# Need to avoid Xerox corporate firewall
library(RDSTK)

 

# coordinates2statistics:
#   A function to return characteristics like population density, elevation, climate, ethnic makeup, and
#   other statistics for points all around the world at a 1km-squared or finer resolution.
#   http://www.datasciencetoolkit.org/developerdocs#coordinates2statistics
?coordinates2statistics



# 1. Number of residents in this area
#    Source: US Census and the CGIAR Consortium for Spatial Information
NumResidents <- function(x)
{
  value <- coordinates2statistics(x['Latitude'], x['Longitude'], 'us_population')$statistics.us_population.value
  return(value)
}



# 2. Number of housing units in this area
#    Source: US Census and the CGIAR Consortium for Spatial Information
NumHousingUnits <- function(x)
{
  value <- coordinates2statistics(x['Latitude'], x['Longitude'], 'us_housing_units')$statistics.us_housing_units.value
  return(value)
}



# 3. Proportion of residents whose income is below the poverty level in this area
#    Source: US Census and the CGIAR Consortium for Spatial Information
ProportionInPoverty <- function(x)
{
  value <- coordinates2statistics(x['Latitude'], x['Longitude'], 'us_population_poverty')$statistics.us_population_poverty.value
  return( round(value,2) )
}



# 4. Proportion of residents whose maximum educational attainment was a bachelor's degree. 
#    Source: US Census and the CGIAR Consortium for Spatial Information
ProportionBachDegree <- function(x)
{
  value <- coordinates2statistics(x['Latitude'], x['Longitude'], 'us_population_bachelors_degree')$statistics.us_population_bachelors_degree.value
  return( round(value,2) )
}
 


# ------- #
# EXAMPLE #
# ------- #
# First, convert some example addresses to lat/lon using this site: http://www.latlong.net/convert-address-to-lat-long.html
#   1) Address from a lower income neighborhood: 1020 St Paul St, Rochester, NY 14621 (Rochester)
#   2) Address from a higher income neighborhood: 21 Sunrise Park, Pittsford, NY 14534 (Pittsford)
#   3) Address from a shopping area: 7979 Pittsford Victor Rd, Victor, NY 14564 (Eastview Mall)
#   4) Address from a business district: 100 S Clinton Ave, Rochester, NY 14604 (Xerox Square)
df <- data.frame( Location = c("Rochester", "Pittsford", "Eastview Mall", "Xerox Square"),
                  Address = c("1020 St Paul St, Rochester, NY 14621", "21 Sunrise Park, Pittsford, NY 14534",
                              "7979 Pittsford Victor Rd, Victor, NY 14564", "100 S Clinton Ave, Rochester, NY 14604"),
                  LocationType = c("Lower Income", "Higher Income", "Shopping Area", "Business District"),
                  Latitude = c(43.174240, 43.046178, 43.029318, 43.154504),
                  Longitude = c(-77.623869, -77.506865, -77.444879, -77.604693) )


df$NumResidents <- apply(df, 1, NumResidents)
df$NumHousingUnits <- apply(df, 1, NumHousingUnits)
df$ProportionInPoverty <- apply(df, 1, ProportionInPoverty)
df$ProportionBachDegree <- apply(df, 1, ProportionBachDegree)








