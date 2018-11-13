function trainOneYearOneLoc
  numWeeks = 10;
  numLocations = 20;
  numWeatherVar = 6;
  infectionTable = ones(numLocations, numWeeks);
  for i = 1:numWeeks
    % i is the current week
    weatherIData =  ones(numLocations, numWeatherVar);
    for j = 1:numLocations
      % j is the current location
      weatherNow = weatherIData(j, :);
      infectionLast = infectionTable(j, i);
      totalData = [infectionLast, weatherNow];
      
      correctAnswer = infectionTable(j, i);
      % Right here will train totaldata and correctAnswer

endfunction