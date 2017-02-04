function ir_plotline(b,LineSpec)
// Plots the line y = b(0) + b(1)*x
// from left to right margins of the *current* plot axis
//
// Inputs:
//      b         column 2-vector, coefficients of line y = b(0) + b(1)*x
//      LineSpec  line style specification (e.g. 'r:')
//
// Examples:
//      b = [1; 2];                // line coefficients
//      bb = [2*%pi*b(1); -b(2)];  // compute another line coeficients
//
//      X = (1:5)';                // data points lying on 
//      Y = [ones(5,1) X]*b;       //    the line y = b(0) + b(1)*x
//
//      figure;
//      plot(X,Y,'k*')             // plot black points (X,Y)
//      ir_plotline(b,'r-')        // plot red line y = x*b over points
//      ir_plotline(bb,'b--')      // plot blue dashed line y = x*bb over points and red line

ax = gca();
xbnd = [min(ax.x_ticks.locations) max(ax.x_ticks.locations)]'; 
ybnd = [[1;1] xbnd]*b;   

if argn(2) > 1 then
    plot(xbnd,ybnd,LineSpec);             
else
    plot(xbnd,ybnd);     
end

endfunction
