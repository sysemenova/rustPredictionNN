function [numberVariables numberWeeks numberLocations numberWeatherVar numberAddedLoc halfAddedLoc locationTable infectionTable weatherData] = loadAllVariables
  numberWeeks = 21;
  numberLocations = 93;
  numberWeatherVar = 6*7;
  numberAddedLoc = 2; % Must be even number
  halfAddedLoc = numberAddedLoc / 2;
  locationTable = csvread("longlat.txt");
  locationTable = locationTable(:, 2:3);
  infectionTable = csvread("infeTableAll.txt");
  infectionTable = infectionTable(:, 1:numberWeeks);
  
  weatherData = ones(numberLocations, numberWeatherVar, 5) * 2;
  
  numberVariables = (numberAddedLoc + 1) * (3 + numberWeatherVar) - 2;
  
  
endfunction