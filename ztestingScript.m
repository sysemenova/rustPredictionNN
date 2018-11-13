clear;

numWeeks = 10;
numLocations = 20;
numWeatherVar = 6;
allWeatherData = ones(numLocations, numWeeks);
locTable = ones(numLocations, 2);

amountAddedLocations = 4;     % Must be an even number
halfAmount = amountAddedLocations / 2;

for j = 1:numLocations
  % Build the weather now data here
  if j - halfAmount < 1 
    % If it's near the beginning of the array 
    adjHalf = halfAmount + (halfAmount - (j - 1));
    rangeForLoc = [j, 1:j-1, j+1:j+adjHalf];
    weatherNow = allWeatherData(rangeForLoc, :);
    locationList = locTable(rangeForLoc, :);

  elseif j + halfAmount >= numLocations
    % If it's near the end of the array
    adjHalf = halfAmount + (halfAmount - (numLocations - j));
    rangeForLoc = [j, j-adjHalf:j-1, j+1:numLocations];
    weatherNow = allWeatherData(rangeForLoc, :);
    locationList = locTable(rangeForLoc, :);
  else 
    rangeForLoc = [j, (j - halfAmount):(j-1), (j+1):(j+halfAmount)];
    weatherNow = allWeatherData(rangeForLoc, :);
    locationList = locTable(rangeForLoc, :);

  endif
endfor