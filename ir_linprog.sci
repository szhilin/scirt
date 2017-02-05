// LPP solver assuming infinite lower and upper bounds for variables
function  [bt, f, exitcode, active] = ir_linprog(c, A, b)
    // Constants    
    Infty = number_properties('huge');  //Infty = %inf;
    SIGNIFICANT = 1.0D-8;

    // Problem dimension and auxilary matricies    
    [n m] = size(A);
    E = eye(m,m);
    I = ones (m,1);
    
    // Infinite bounds for variables
    lb = -Infty * I;
    ub =  Infty * I;    
    
    // Reformulate LPP to eliminate negative variables
    c2 = [c -c];
    A2 = [A -A; -E E];
    b2 = [b; -lb];    
    //lb2 = zeros(2*m,1);
    ub2 = [ ub; -lb ];

    // Solve LPP for non-negative variables
    [bt2, f, exitcode, lagr] = ir_linproglu(c2,A2,b2,[],ub2);

    // Compute original variables
    bt = bt2(1:$/2) - bt2($/2+1:$);
    
    // Detect active constraints
    lagr = lagr(1:n);
    idx = find(lagr > SIGNIFICANT);
    active.lower = idx(idx > n/2) 
    active.upper = idx(idx <= n/2);
    if ~isempty(active.lower)  then
        active.lower = active.lower - n/2;
    end

//    disp('======')
//    disp(lagr)
//    disp(idx)
//    disp(active.lower)
//    disp(active.upper)
endfunction

// Wrap linpro from QuaPro toolbox
function  [bt, f, exitcode, lagr] = ir_linproglu(c, A, b, lb, ub)
    exitcode = 1;
    bt = [];
    f = [];
    
    try
      [bt,lagr,f] = linpro(c',A,b,lb,ub);
    catch
      [error_message,error_number] = lasterror(%t);
      select error_number
          case 123 then
                exitcode = -1  
          case 127 then
                exitcode = -2
          else      
                exitcode = -3
                disp(error_number);
                disp(error_message);
      end 
      return 
    end    
endfunction
