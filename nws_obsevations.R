#latest observations at each of those stations
tampa.current.conditions <- current.conditions(tampa.forecast.stations$stations)
tampa.current.conditions %>% write_csv("tampa.current.conditions.csv")

tampa.all.observations <- all.conditions.for.stations(tampa.forecast.stations$stations$station.id)
tampa.all.observations %>% write_csv("tampa.all.observations.csv")

#latest observations at each of those stations
clearwater.current.conditions <- current.conditions(clearwater.forecast.stations$stations)

clearwater.current.conditions %>% write_csv("clearwater.current.conditions.csv")

clearwater.all.observations <- all.conditions.for.stations(tampa.forecast.stations$stations$station.id)
clearwater.all.observations %>% write_csv("tampa.all.observations.csv")

#latest observations at each of those stations
lutz.current.conditions <- current.conditions(lutz.forecast.stations$stations)

lutz.current.conditions %>% write_csv("lutz.current.conditions.csv")

lutz.all.observations <- all.conditions.for.stations(tampa.forecast.stations$stations$station.id)
lutz.all.observations %>% write_csv("tampa.all.observations.csv")
