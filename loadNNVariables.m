function [numberOfVariables] = loadNNVariables
  % numVars = (amountAddedLocations + 1) * (3 + numWeatherVar); % How many variables each location gets
  numberOfVariables = (4 + 1) * (3 + 6);
endfunction