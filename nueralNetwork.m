function [J] = nueralNetwork(unrolledThetas, costOrGrad, X, y, lambda, nodesIn2, numVars, nodesIn3)
  % Hola let's get started
  m = size(X, 1);
  
  % nodesIn2 = 25;
  numVarP1 = numVars + 1;
  
  % nodesIn3 = 1;   % AKA final
  nodesIn2P1 = nodesIn2 + 1;
  
  
  Theta1 = reshape(unrolledThetas(1:nodesIn2 * (numVarP1)), ...
                 nodesIn2, numVarP1);

  Theta2 = reshape(unrolledThetas((1 + (nodesIn2 * numVarP1)):end), ...
                 nodesIn3, nodesIn2P1);
  
  % Run through the neural network!
  X = [ones(m, 1) X];
  z2 = X * Theta1';
  a2 = sgmd(z2);
  
  a2 = [ones(m, 1) a2];
  z3 = a2 * Theta2';
  a3 = sgmd(z3);
  
  
  specialTheta1 = Theta1; specialTheta1(:, 1) = 0;
  specialTheta2 = Theta2; specialTheta2(:, 1) = 0;
  
  if (costOrGrad == 0)
    % We asked for the cost!
    J = (-(1/m) * sum( y .* log(a3) .+ (1 - y).* log(1 - a3) )) + ...
      ((lambda / (2*m)) * (sum(sum(specialTheta1 .^ 2)) + sum(sum(specialTheta2 .^ 2))) );
  else
    d3 = a3 - y;
    d2 = (Theta2(:, 2:end)' * d3')' .* sigmoidGradient(z2);
    Delta1 = d2' * X;
    Delta2 = d3' * a2;
    Theta1_grad = Delta1 / m;
    Theta2_grad = Delta2 / m;
    
    Theta1Reg = (lambda / m) .* specialTheta1; Theta1Reg(:, 1) = 0;
    Theta2Reg = (lambda / m) .* specialTheta2; Theta2Reg(:, 1) = 0;
    Theta1_grad = Theta1_grad + Theta1Reg;
    Theta2_grad = Theta2_grad + Theta2Reg;
    
    J = [Theta1_grad(:) ; Theta2_grad(:)];
  endif

  
endfunction