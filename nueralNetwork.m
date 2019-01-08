function [J grad] = nueralNetwork(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
  
  % RUST
  
  %NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));


X = [ones(m, 1) X];
z2 = X * Theta1';
a2 = sgmd(z2);
a2 = [ones(m, 1) a2];
z3 = a2 * Theta2';
a3 = sgmd(z3);
%a3 = a3 * 10;



specialTheta1 = Theta1; specialTheta1(:,1) = 0;
specialTheta2 = Theta2; specialTheta2(:,1) = 0;

% Have to use just y
J = (-(1/m) * sum( y .* log(a3) .+ (1 - y).* log(1 - a3) )) + ...
      ((lambda / (2*m)) * (sum(sum(specialTheta1 .^ 2)) + sum(sum(specialTheta2 .^ 2))) );


     
#GRADIENT FUCKING SHIT

d3 = a3 - y;
d2 = (Theta2(:,2:end)' * d3')' .* sgmdGradient(z2);
Delta1 = d2' * X;
Delta2 = d3' * a2;
Theta1_grad = Delta1 / m;
Theta2_grad = Delta2 / m;

Theta1Reg = (lambda / m) .* specialTheta1; Theta1Reg(:,1) = 0;
Theta2Reg = (lambda / m) .* specialTheta2; Theta2Reg(:,1) = 0;
Theta1_grad = Theta1_grad + Theta1Reg;
Theta2_grad = Theta2_grad + Theta2Reg;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];

  
endfunction