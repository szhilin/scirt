function ir_plotmodelset(X, y, epsilon, padx)
// Plots 2D set of feasible linear models consistent with dataset (X,y,epsilon)
// TODO: Add possibility to manage colors
   if argn(2) < 4 then
      padx = %t;
   end

   if size(X,1) < 2 then
      error('Not enough data');
   end
   
   if size(X,2) == 2 & and(X(:,1)==1)  then
       xcol = 2;
   elseif size(X,2) == 2 & and(X(:,2)==1) 
       xcol = 1;
   elseif size(X,2)==1
       xcol = 1;
   else
       error('Wrong X size');
   end

   if padx then
      Xbefore = 2*X(1,:) - X(2,:);
      Xafter  = 2*X($,:) - X($-1,:);
      Xp = [Xbefore; X; Xafter];
   else
      Xp = X;
   end

   x = Xp(:,xcol);
   [yp, betap, exitcode] = ir_predict(Xp, X, y, epsilon);
   
   px = [x; x($:-1:1)];
   py = [yp(:,1); yp($:-1:1,2)];

   xfpoly(px,py,color(250, 197, 250));
   plot(x,yp(:,1),'m-','LineWidth',1);
   plot(x,yp(:,2),'m-','LineWidth',1);
endfunction
   
