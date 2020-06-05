%Purpose: Constructs a nonlinear constraint
%Called by: fmincon in the file, SQP
function [C, Ceq] = NonLCon(x)

a = 0.04166667;
S(1) = 7599999/7600000;
I(1) = 1/7600000;
R(1) = 0/7600000;

for i=1:365
    
    if(i >= x(1))&&(i <= x(2))              % R0 of 3.5
        r = 0.0291666;
    elseif(i > x(2))&&((x(2)-x(1)) > 0)     % R0 of 1.68
        r = 0.07;
    else                                    % R0 of 0.7
        r = 0.14583345;
    end
    S(1,i+1) = S(1,i)- r*S(1,i)*I(1,i);
    I(1,i+1) = I(1,i) + r*S(1,i)*I(1,i) - a*I(1,i);
    R(1,i+1) = R(1,i) + a*I(1,i);
    
end
%fprintf('maximum infective\n');
max(I);

%Nonlinear inequality constraints
C(1) = 0.0175*max(I)-1500/7600000;
C(2) = max(I)*0.3333333*0.2-5070/7600000;

%Nonlinear equality constraints
Ceq = 0;