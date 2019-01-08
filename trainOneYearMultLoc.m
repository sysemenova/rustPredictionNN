function trainOneYearMultLoc
  
  
  [numVars numWeeks numLocations numWeatherVar amountAddedLocations halfAmount locTable infectionTable weatherData] = loadAllVariables;
  nodesInLayer2 = 25;
  nodesInLayer3 = 1;    % AKA Final layer
  lambda = .1;
    
  initialTheta1 = randWeights(nodesInLayer2, numVars + 1);
  initialTheta2 = randWeights(nodesInLayer3, nodesInLayer2 + 1);
    
  nn_params = [initialTheta1(:) ; initialTheta2(:)];
  
  closestLocations = csvread("nClosest.txt");
  totaltotalData = [];
  yyData = [];  
 
 
  for i = 2:numWeeks
    % i is the current week
    
    % CURRENT WEEKS WEATHER DATA - get from main weather storage somewhere
    filename = strcat(num2str(i), "WeekData.txt");
    curWeekWeatherData = csvread(filename);
    %curWeekWeatherData =  weatherData(:, :, i);
    infectionTable;
    
    totalData = ones(numLocations, numVars);  % Empty final data
                                              % DIMENSIONS OF DATA!!!
                                              % ITS FOR THIS WEEK
    yData = ones(numLocations, 1);            % Empty final y
                                              % THE CORRECT ANSWERS
    
    for j = 1:numLocations
      % j is the current location
      % STARTS FROM 1
     
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
      
      % range of loc is literally just the line for the location
      rangeOfLoc = closestLocations(j, :);
      weatherAtCurLoc = curWeekWeatherData(rangeOfLoc, :);   % Actual weather data at all of the locations
      
      locationList = locTable(rangeOfLoc(1, 2:(amountAddedLocations + 1)), :);       % Just the location
      locationDifferenceList = locationList - locTable(j, :); %Difference between the location and j
      
      infectionLast = infectionTable(rangeOfLoc, i - 1);  % Last week's infection status
      
      % GOAL : Using THIS WEEK'S weather data and LAST WEEKS infection status
               % Predict whether or not location j will be infected BY THE END OF THE CURRENT WEEK
                    % Therefore, in testing, the correct answer is the current week's infection status
      
      totalDataThisLoc = [locationDifferenceList(:); infectionLast(:); weatherAtCurLoc(:)];
      correctAnswer = infectionTable(j, i);
      
      
      totalData(j, :) = totalDataThisLoc';
      yData(j, 1) = correctAnswer;
      
    endfor
    
    totaltotalData = [totaltotalData ; totalData];
    yyData = [yyData; yData];
    
    %{
    function bstop = showJ_history(x, optv, state)
      plot(optv.iter, optv.fval, 'x')
      bstop = false;
    endfunction

    %options = optimset('MaxIter', 1000, "GradObj", "on", "OutputFcn", @showJ_history);


    figure()
    xlabel("Iteration")
    ylabel("Cost")
    hold on
    %}  
    
  endfor
  
  costFunction = @(p) nueralNetwork(p, numVars, nodesInLayer2, nodesInLayer3, totaltotalData([1:700, 900: end], :), yyData([1:700, 900: end], :), lambda);
    
  options = optimset("GradObj", "on");
    
    
  nn_params = fminunc(costFunction, nn_params, options);
    
  Theta1 = reshape(nn_params(1:nodesInLayer2 * (numVars + 1)), ...
                 nodesInLayer2, (numVars + 1));

  Theta2 = reshape(nn_params((1 + (nodesInLayer2 * (numVars + 1))):end), ...
                 nodesInLayer3, (nodesInLayer2 + 1));


  p = predictRust(Theta1, Theta2, totaltotalData(700:900, :));
  asdf = [p yyData(700:900, :)]
  csvwrite("THEPREDICTIONSOMG2ADDEDLOCtestset.txt", asdf);
  roundedResults = round(asdf)  % Makes the predicted actually what it predicted

  percentRight = mean(double(asdf(:,1) == asdf(:,2))) * 100

  fprintf("Yeet done")
  
endfunction