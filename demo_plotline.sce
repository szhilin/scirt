/// Demo for ir_plotline()

b = [1; 2];                // line coefficients
bb = [2*%pi*b(1); -b(2)];  // compute another line coeficients

X = (1:5)';                // data points lying at
Y = [ones(5,1) X]*b;       //    the line y = b(0) + b(1)*x

figure;
plot(X,Y,'k*')             // plot black points (X,Y)
ir_plotline(b,'r-')        // plot red line y = x*b over points
ir_plotline(bb,'b--')      // plot blue dashed line y = x*bb over points and red line
 
