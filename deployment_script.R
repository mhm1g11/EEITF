
### This script triggers the deployment of the EEITF shiny dashboard. 


library(rsconnect)

rsconnect::deployApp('EEITF_Viz', account = "mhm1g11")




