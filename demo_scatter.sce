/// Demo for ir_scatter()

// Simulate simple interval data
b = [1; 1];                          // coefficients
n = 5;                               // number of observations
epsilon = rand(n,1);                 // error bounds
X = [ ones(n,1) (1:n)'];             // X values
y = X*b + epsilon.*(rand(n,1)-0.5);  // y values
yinfsup = [y - epsilon y + epsilon]; // represent y by interval bounds   

// Show some plots for intervals specified by middle points and radii
figure('BackgroundColor',[1 1 1]);
ir_scatter(X,y,epsilon);
title('Individual interval widths','fontsize',4)

figure('BackgroundColor',[1 1 1]);
ir_scatter(X,y,0.2);
title('Common width of y-intervals','fontsize',4)

figure('BackgroundColor',[1 1 1]);
ir_scatter(X,y,epsilon,'ro');
title('Red intervals, central points are circles','fontsize',4)

figure('BackgroundColor',[1 1 1]);
ir_scatter(X(:,2),y,0.3,'bx');
title('Blue intervals, central points are crosses','fontsize',4)

//  Show plots for intervals specified by lower and upper bounds
figure('BackgroundColor',[1 1 1]);
ir_scatter(X,yinfsup);
title('Interval scatter plot for infsup-intervals (default style)','fontsize',4)

figure('BackgroundColor',[1 1 1]);
ir_scatter(X,yinfsup,'m*');
title('Interval scatter plot for infsup-intervals (user-defined style)','fontsize',4)
