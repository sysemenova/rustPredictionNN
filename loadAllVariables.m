function [numberVariables numberWeeks numberLocations numberWeatherVar numberAddedLoc halfAddedLoc locationTable infectionTable weatherData] = loadAllVariables
  numberWeeks = 2;
  numberLocations = 20;
  numberWeatherVar = 6;
  numberAddedLoc = 4; % Must be even number
  halfAddedLoc = numberAddedLoc / 2;
  locationTable = ones(numberLocations, 2);
  infectionTable = ones(numberLocations, numberWeeks) * 1;
  weatherData = ones(numberLocations, numberWeatherVar, 5) * 2;
  numberVariables = (numberAddedLoc + 1) * (3 + numberWeatherVar);
  
  
endfunction