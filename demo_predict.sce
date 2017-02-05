/// Demo for ir_plotmodelset(), ir_predict(), ir_scatter()

// Simulate observations for simple dependency y = 1 + x 
n = 5;                                 // number of observations
epsilon = 0.5;                         // error bound
X = [ ones(n,1) (1:5)' ];              // X values
y = X*[1 1]' + epsilon*rand(n,1)-0.5;  // y values with bounded errors 

// Show generated interval data and set of models consistent with them
figure;
ir_plotmodelset(X, y, epsilon);        // Show set of feasible models
ir_scatter(X, y, epsilon);             // Show interval dataset

// Select x values to predict and estimate interval prediction of y for them
Xp = [1 2.5; 1 5.5];                   // X points to predict at
[yp, betap, exitcode, active] = ir_predict(Xp, X, y, epsilon); // Prediction

// Show predicted intervals
ir_scatter(Xp,yp,'b.');                // Show predicted intervals

