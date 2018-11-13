function trainOneYearMultLoc
  
  
  [numVars numWeeks numLocations numWeatherVar amountAddedLocations halfAmount locTable infectionTable weatherData] = loadAllVariables;
  
  for i = 2:numWeeks
    % i is the current week
    
    % CURRENT WEEKS WEATHER DATA - get from main weather storage somewhere
    curWeekWeatherData =  weatherData(:, :, 1);
    
    totalData = ones(numLocations, numVars);  % Empty final data
                                              % DIMENSIONS OF DATA!!!
                                              % ITS FOR THIS WEEK
    yData = ones(numLocations, 1);            % Empty final y
                                              % THE CORRECT ANSWERS
    
    for j = 1:numLocations
      % j is the current location
     
      % Develop the range of locations for this specific location
      % Will be changed in order to create a better structure
          % Specifically, gotta have the actual closest ones, not just the 
          % closest ones in the array
      if j - halfAmount < 1 
        % If it's near the beginning of the array 
        adjHalf = halfAmount + (halfAmount - (j - 1));
        rangeOfLoc = [j, 1:j-1, j+1:j+adjHalf];
      elseif j + halfAmount >= numLocations
        % If it's near the end of the array
        adjHalf = halfAmount + (halfAmount - (numLocations - j));
        rangeOfLoc = [j, j-adjHalf:j-1, j+1:numLocations];
      else 
        rangeOfLoc = [j, j - halfAmount:j-1, j+1:j+halfAmount];
      endif
      
      
      
      weatherAtCurLoc = curWeekWeatherData(rangeOfLoc, :);   % Actual weather data at all of the locations
      
      locationList = locTable(rangeOfLoc, :);       % Just the location
      locationDifferenceList = locationList - locTable(j, :); %Difference between the location and j
      
      infectionLast = infectionTable(rangeOfLoc, i - 1);  % Last week's infection status
      
      % GOAL : Using THIS WEEK'S weather data and LAST WEEKS infection status
               % Predict whether or not location j will be infected BY THE END OF THE CURRENT WEEK
                    % Therefore, in testing, the correct answer is the current week's infection status
      totalDataThisLoc = [locationDifferenceList, infectionLast, weatherAtCurLoc];
      correctAnswer = infectionTable(j, i);
      
      thisLocUnrolled = reshape(totalDataThisLoc, 1, numVars);
      
      totalData(j, :) = thisLocUnrolled;
      yData(j, 1) = correctAnswer;
      
    endfor
    
    nodesInLayer2 = 25;
    nodesInLayer3 = 1;    % AKA Final layer
    lambda = .1;
    
    initialTheta1 = randWeights(nodesInLayer2, numVars + 1);
    initialTheta2 = randWeights(nodesInLayer3, nodesInLayer2 + 1);
    
    unrolledParams = [initialTheta1(:) ; initialTheta2(:)];
    
    costFunction = @(p) nueralNetwork(p, 0, totalData, yData, lambda, nodesInLayer2, numVars, nodesInLayer3);
    gradFunction = @(q) nueralNetwork(q, 1, totalData, yData, lambda, nodesInLayer2, numVars, nodesInLayer3);
    
    options = optimset("MaxIter", [4], "GradObj", gradFunction);
    
    foundParameters = fminunc(costFunction, unrolledParams, options)
    
    
  endfor
endfunction