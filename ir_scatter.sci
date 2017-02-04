function ir_scatter(X, y, varargin)
// Creates 2D interval scatter plot for interval-valued data
//
// Interval values may be represented by 
//   1) middle points (y) and radii (epsilon);
//   2) lower and upper bounds od intervals (1st and 2nd columns of y).
//
// Call variants: 
//     ir_scatter(X, y)
//     ir_scatter(X, y, LineSpec)
//     ir_scatter(X, y, epsilon)
//     ir_scatter(X, y, epsilon, LineSpec)
//
// Inputs:
//     X          (n x 1)-vector or (n x 2) matrix with unit column
//     y          (n x 1)-vector, middle points of interval values, radius (radii) 
//                                of intervals must be specified in epsilon 
//                OR
//                (n x 2)-matrix, interval bounds (y(:,1) is lower, y(:,2) is upper)
//     epsilon    scalar OR (n x 1)-vector, half-width of uncertainty intervals
//     LineSpec   string, interval line specification 
//                        (default: 'k.' - black lines with points)
//
// Examples:
//    // Simulate simple interval data
//    b = [1; 1];                          // coefficients
//    n = 5;                               // number of observations
//    epsilon = rand(n,1);                 // error bounds
//    X = [ ones(n,1) (1:n)'];             // X values
//    y = X*b + epsilon.*(rand(n,1)-0.5);  // y values
//    yinfsup = [y - epsilon y + epsilon]; // represent y by interval bounds   
//    
//    // Show some plots for intervals specified by middle points and radii
//    figure('BackgroundColor',[1 1 1]);
//    ir_scatter(X,y,epsilon);
//    title('Individual interval widths','fontsize',4)
//    
//    figure('BackgroundColor',[1 1 1]);
//    ir_scatter(X,y,0.2);
//    title('Common width of y-intervals','fontsize',4)
//    
//    figure('BackgroundColor',[1 1 1]);
//    ir_scatter(X,y,epsilon,'ro');
//    title('Red intervals, central points are circles','fontsize',4)
//    
//    figure('BackgroundColor',[1 1 1]);
//    ir_scatter(X(:,2),y,0.3,'bx');
//    title('Blue intervals, central points are crosses','fontsize',4)
//    
//    //  Show plots for intervals specified by lower and upper bounds
//    figure('BackgroundColor',[1 1 1]);
//    ir_scatter(X,yinfsup);
//    title('Interval scatter plot for infsup-intervals (default style)','fontsize',4)
//    
//    figure('BackgroundColor',[1 1 1]);
//    ir_scatter(X,yinfsup,'m*');
//    title('Interval scatter plot for infsup-intervals (user-defined style)','fontsize',4)


// Get X matrix column not equal to ones(n,1)
if size(X,2) == 2 & and(X(:,1)==1)  then
    x = X(:,2);
elseif size(X,2) == 2 & and(X(:,2)==1)  then
    x = X(:,1);
elseif size(X,2)==1 then
    x = X;
else
    error('Wrong X size');
end

// If y is a two-columns matrix (contains interval bounds) 
// then convert bounds to midrad form: (y, epsilon)
if size(y,2) == 2 & (argn(2) < 3 | typeof(varargin(1)) == 'string') then 
    epsilon = 0.5*(y(:,2) - y(:,1));
    y = mean(y,2);      
elseif argn(2) >= 3 & typeof(varargin(1)) ~= 'string'
    epsilon = varargin(1);
else
    error('Wrong arguments');    
end

// If epsilon is a scalar then set all radii of intervlas equal to it
if length(epsilon) == 1 then
    epsilon = epsilon * ones(length(y),1);
end

LineSpec='k.';
if argn(2) > 2 & typeof(varargin($)) == 'string' then
    LineSpec = varargin($);
end

errbar(x,y,epsilon,epsilon);
ax = gca();
b = ax.data_bounds;
ax.data_bounds = [0.99*b(1,:); 1.01*b(2,:)];

h=gce();
set(h,'segs_color',colornum(part(LineSpec,1)))
plot(x,y,LineSpec);

endfunction

function [colornumber] = colornum(colorletter)
    colornames = 'kbgcrmyw';
    colornumber = strindex(colornames,colorletter);
endfunction
