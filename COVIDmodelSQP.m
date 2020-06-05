%% initializations
% Jordyn Watkins
% MATH 319 - Optimization
% Final Project

clear all
close all
clc
%% Optimization Problem Defintion

% Optmization Problem
% min   f(x) = x2 - x1                  
% wrt   x = {x1, x2}
% st    0.0175*R <= 1500                * # of deaths < 1500
%       x2 - x1 >= 0                    * # of SIPO days cannot be negative

%       max(I)*0.2*0.33333 <= 5070      * this ensures hospitals remain under
%                                       * their capacity

%       x1, x2 >= 0                     * all variables must be >=0
% ========================================================================
%       S + I + R = 7.6 million       * SIR adds to total population
%                                       * used for error checking - NOT a
%                                         constraint
% ========================================================================
% where x1 = start date of SIPO
%       x2 = the end date of SIPO,
%       S = number of susceptibles 
%       I = number of infectives
%       R = number of recovered

% formula used to plot SIR pattern:
%       S(t+1) = S(t) - r*S(t)*I(t)
%       I(t+1) = I(t) + r*S(t)*I(t) - a*I(t)
%       R(t+1) = R(t) + a*I(t)

%% Troubleshooting
%Three dimensional plots of the objective function and major constraints.
%Followed by 2-D plots of the I-curve with respect to hospital capacity to
%see if the maximum of I actually changes or not.

% 3-D plot of objective function
Z = zeros(365,365);
for X = 1:1:365
    for Y = 1:1:365
        Z(X,Y) = Y-X;
    end
end

figure;
mesh(Z)

% 3-D plot of constraints. Hospital capacity constraint is second plot,
% death constraint is first plot.
for X = 62:1:180
    for Y = 62:1:180
        x = [X,Y];
        g(X,Y,:) = NonLCon(x);
    end
end
figure;
mesh(g(:,:,1))
figure;
mesh(g(:,:,2))


% 2-D plot of I-curve with respect to hospital capacity to see if a
% feasible solution is possible. Appears that a feasible solution is
% possible with x1 = 62 and x2 = 141. 
a = 0.04166667;
S(1,1) = 7599999/7600000;
I(1,1) = 1/7600000;
R(1,1) = 0/7600000;
time(1,1) = 0;
hospitalCapacity(1,1) = 76050/7600000;

for x2 = 140:1:142
    for i=1:365

        if(i >= 62)&&(i <= x2)
            r = 0.0291666;
        elseif(i > x2)&&((x2-62) > 0)
            r = 0.07;
        else
            r = 0.14583345;
        end
        S(1,i+1) = S(1,i)- r*S(1,i)*I(1,i);
        I(1,i+1) = I(1,i) + r*S(1,i)*I(1,i) - a*I(1,i);
        R(1,i+1) = R(1,i) + a*I(1,i);
        time(1,i+1) = i+1;
        hospitalCapacity(1,i+1) = 76050/7600000;

    end
    figure;
    plot(time(1,:),I(1,:))
    hold
    plot(time(1,:),hospitalCapacity(1,:))
    legend("Infectives","hospital capacity")
    title('Test change in max constraints')
    xlabel('Time(days)')
    ylabel('Fraction of Population')
end

%% SIR Model WITHOUT SIPO Implementation
% This model shows the progression of the coronavirus without any social
% distancing measures implemented. This serves as a comparison for the
% optimized problem scenarios.

r = 0.14583345;
a = 0.04166667;
S(1,1) = 7599999/7600000;
I(1,1) = 1/7600000;
R(1,1) = 0/7600000;
time(1,1) = 0;
hospitalCapacity(1,1) = 25350/7600000;

for i=1:365
    
    S(1,i+1) = S(1,i)- r*S(1,i)*I(1,i);
    I(1,i+1) = I(1,i) + r*S(1,i)*I(1,i) - a*I(1,i);
    R(1,i+1) = R(1,i) + a*I(1,i);
    time(1,i+1) = i+1;
    hospitalCapacity(1,i+1) = 25350/7600000;
    
end

figure
plot(time(1,:),S(1,:))
hold
plot(time(1,:),I(1,:))
plot(time(1,:),R(1,:))
plot(time(1,:),hospitalCapacity)
legend("Susceptibles","Infectives","Removed","Hospital Capacity")
title('Virus Progression Without SIPO Implementation')
xlabel('Time(days)')
ylabel('Fraction of Population')

%% Disease Progression Based on WA State Actions (Actual Model)
% This model illustrates the progression of the coronavirus on the
% population based on Washington State's actual actions - with the
% implementation date of SIPO, and the phase out stages.

a = 0.04166667;
S(1,1) = 7599999/7600000;
I(1,1) = 1/7600000;
R(1,1) = 0/7600000;
time(1,1) = 0;
hospitalCapacity(1,1) = 25350/7600000;
deathcap(1,1) = 85714/7600000;

for i=1:365
    
    if (i <= 62)                    % R0 of 3.5
        r = 0.14583345;
    elseif (i > 62) && (i <= 131)   % R0 of 0.7
        r = 0.02916667;
    elseif (i > 131) && (i <= 320)  % R0 of 1.1
        r = 0.0458333;
    elseif (i > 320) && (i <= 365)  % R0 of 1.75
        r = 0.072916725;
    end 
    
    S(1,i+1) = S(1,i)- r*S(1,i)*I(1,i);
    I(1,i+1) = I(1,i) + r*S(1,i)*I(1,i) - a*I(1,i);
    R(1,i+1) = R(1,i) + a*I(1,i);
    time(1,i+1) = i+1;
    hospitalCapacity(1,i+1) = 25350/7600000;
    deathcap(1,i+1) = 85714/7600000;
    
end

figure
plot(time(1,:),I(1,:))
hold
plot(time(1,:),hospitalCapacity)
plot(time(1,:),deathcap)
legend("Infectives", "Hospital Capacity", "Death Constraint")
title('Virus Progression Based on WA State Actions')
xlabel('Time(days)')
ylabel('Fraction of Population')

%% Minimum # of SIPO Days (Realistic Model)
% First analysis to find the minimum number of SIPO days modeled after
% Washington States actual timeline - issuing SIPO March 23 (62 days after 
% first case). Evaluated from t = 0 to t = 365 days since that's when an 
% expected vaccine should be in circulation. 

% initial conditions
X0 = [62 201];
LB = [62 62];         % Lower bounds on variables
UB = 365*ones(1,2); % Upper bounds on variables

% linear constraints
A = [1 -1];          % Coefficients of linear constraints equations
B = [0];             % Right side vector for linear constraints equations

options = optimset('Display', 'iter', 'LargeScale','off','Algorithm','active-set','GradObj','on','GradConstr','off');
[x, fval, flag, output] = fmincon('ObjFcn',X0,A,B,[],[],LB,UB,'NonLCon',options)

a = 0.04166667;
S(1,1) = 7599999/7600000;
I(1,1) = 1/7600000;
R(1,1) = 0/7600000;
time(1,1) = 0;
hospitalCapacity(1,1) = 25350/7600000;
deathcap(1,1) = 85714/7600000;

for i=1:365
    
    if(i >= x(1))&&(i <= x(2))            % R0 of 0.7
        r = 0.0291666;
    elseif(i > x(2))&&((x(2)-x(1)) > 0)   % R0 of 1.68
        r = 0.07;
    else
        r = 0.14583345;                   % R0 of 3.5
    end
    S(1,i+1) = S(1,i)- r*S(1,i)*I(1,i);
    I(1,i+1) = I(1,i) + r*S(1,i)*I(1,i) - a*I(1,i);
    R(1,i+1) = R(1,i) + a*I(1,i);
    time(1,i+1) = i+1;
    hospitalCapacity(1,i+1) = 25350/7600000;
    deathcap(1,i+1) = 85714/7600000;
    
end
figure
plot(time(1,:),I(1,:))
hold
plot(time(1,:),hospitalCapacity)
plot(time(1,:),deathcap)
legend("Infectives", "Hospital Capacity", "Death Constraint")
title('Plot of Virus Progression With Minimum # of SIPO daya(given earliest start date of March 23)')
xlabel('Time(days)')
ylabel('Fraction of Population')
%% Minimum # of SIPO Days (Best Case Scenario Model)
% This model assumes that the minimum start date can be as early as day 0
% (t = 0). The purpose of conducting this optimization problem is to
% compare this result to that of the realistic model to see how the number
% of SIPO days can be reduced by mandating the order earlier.

% initial conditions
%X0 = [0 140];
%LB = [0 0];         % Lower bounds on variables
%UB = 365*ones(1,2); % Upper bounds on variables

% linear constraints
%A = [1 -1];         % Coefficients of linear constraints equations
%B = 0;              % Right side vector for linear constraints equations

%options = optimset('LargeScale','off','Algorithm','active-set','GradObj','on','GradConstr','off');
%[x, fval, flag, output] = fmincon('ObjFcn',X0,A,B,[],[],LB,UB,'NonLCon',options)

