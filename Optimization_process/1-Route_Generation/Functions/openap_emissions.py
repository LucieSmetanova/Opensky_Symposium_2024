from openap import Emission

emission = Emission(ac_type_icao,eng)

CO2 = emission.co2(F)                   # g/s
#H2O = emission.h2o(FF)                 # g/s
NOx = emission.nox(F, TAS, alt_start)   # g/s
CO = emission.co(F, TAS, alt_start)     # g/s
HC = emission.hc(F, TAS, alt_start)     # g/s
#SOx = emission.sox(F)                   # g/s