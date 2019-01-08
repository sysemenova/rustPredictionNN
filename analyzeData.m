function analyzeData

filename = "THEPREDICTIONSOMG2ADDEDLOCtestset.txt";
results = csvread(filename);

roundedResults = round(results);  % Makes the predicted actually what it predicted

percentRight = mean(double(roundedResults(:,1) == roundedResults(:,2))) * 100

fancyResults = [];
nl = 93;
nw = 20;
%{
for i=1:nw
  fancyResults = [fancyResults results( (nl * (i-1) + 1):(nl * i), :)];
endfor

fancyResults;

fancyrounded = round(fancyResults);
csvwrite("FancyPredictionstestset.txt", fancyrounded);
%}

fancyResults = [results(1:100, :) results(101:200, :)]
fancyrounded = round(fancyResults);
csvwrite("FancyPredictionstestset.txt", fancyrounded);


function ro = truefalseposneg(rr)
  ro = [0 0 0 0];
  rr;
  if rr(1) == rr(2)
    if rr(1) == 1
      % True positive
      ro(1) = 1;
    else
      % True negative
      ro(3) = 1;
    endif
  else
    if rr(1) == 1
      % False positive
      ro(2) = 1;
    else
      ro(4) = 1;
    endif
  endif
  ro;
endfunction

table = [0 0 0 0];
for i = 1:rows(roundedResults)
  t = truefalseposneg(roundedResults(i, :));
  table = table + t;
endfor

table

endfunction