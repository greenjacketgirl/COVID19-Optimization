%Purpose: Constructs an objective function
%Called by: fmincon in the file, SQP
function [f,df] = ObjFcn(x)
f = x(2)- x(1);    %function
df = [-1, 1];      %derivative