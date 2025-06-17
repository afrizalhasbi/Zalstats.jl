using DataFrames
using CSV

battery = CSV.read("battery.csv") |> DataFrame
