function [yp, betap, exitcode, active] = ir_predict(Xp, X, y, epsilon)
// Computes interval prediction for response y at the point x 
// using the interval regression constructed for dataset (X,y,epsilon)
//
// TODO: Fix bugs in algorithm of active constraints detection.
//
// Inputs:
//   Xtest     (k x m)-matrix, contains points (row vectors) to predict at
//   X         (n x m)-matrix of observations for X variables
//   y         column n-vector of measured values of response variable y 
//   epsilon   real number or n-vector, half-width(s) of uncertainty 
//             intervals for response variable y
//
// Outputs:
//    yp       (k x 2)-matrix, interval regression predictions at points Xp(i,:),
//             yp(i,1) and yp(i,2) are, accordingly, lower and upper bounds 
//             of predicted interval   
//    betap    (k x m x 2)-matrix, regression parameters values providing 
//             interval prediction yp(i), beta(i,:,1) and beta(i,:,2)
//             correspond to lower and upper bounds of yp accordingly
//    exitcode integer exit code
//                1  Ok, solution is found
//               -1  Unbounded solution set (colinearity in the data)
//               -2  No feasible solution (feasible parameters set is empty)
//    active    k-element array of structs with fields 'lower' and 'upper', 
//              active(i).lower and active(i).upper contains vectors of
//              active  constraints (observations) which limit the lower and
//              upper bounds of a predicted interval yp(i,:)
//
// Example:
//    /// Simulate observations for simple dependency y = b(0) + b(1)*x 
//    b = [1; 1];                            // simulated dependency parameters
//    n = 5;                                 // number of observations
//    epsilon = 0.5;                         // error bound
//    X = [ ones(n,1) (1:5)' ];              // X values
//    y = X*b + epsilon*rand(n,1)-0.5;       // y values with bounded errors 
//    figure;
//    ir_scatter(X,y,epsilon);               // Show interval dataset in black
//    Xp = [1 2.5; 1 5.5];                   // Set points where to predict
//    [yp, betap, exitcode] = ir_predict(Xp, X, y, epsilon); // Predict dependency values
//    ir_scatter(Xp,yp,'b.');                // Show predicted intervals in blue

if size(Xp,2) ~= size(X,2)
    error('Xp must have the same number of columns as X');
end

k = size(Xp,1);
n = size(X,1);
m = size(X,2);

A = [X; -X];
b = [y+epsilon; -y+epsilon];

// Allocate matricies and structures
yp = zeros(k,2);
betaplow = zeros(size(Xp));
betaphigh = betaplow;
active = struct('lower',[],'upper',[]);

for i = 1:k
    [betalow, flow, exitcode, actlow] = ir_linprog(Xp(i,:), A, b);   
    if exitcode < 0 
       mprintf("%d - lower: %d", i, exitcode);
       return
    end   
    
    [betahigh, fhigh, exitcode, acthigh] = ir_linprog(-Xp(i,:), A, b);
    if exitcode < 0 
       mprintf("%d - upper: %d", i, exitcode);
       return
    end   

    yp(i,:) = [flow, -fhigh];
    betaplow(i,:)  = min(betalow',betahigh');
    betaphigh(i,:) = max(betalow',betahigh');
    active(i).lower = [actlow.lower; acthigh.lower];
    active(i).upper = [actlow.upper; acthigh.upper];
end

betap = cat(3,betaplow,betaphigh);

endfunction // ir_predict
