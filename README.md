# COVID19-Optimization
Attempting to determine the minimum number of stay-at-home order days such that we can keep the number of positive cases requiring hospitalization below the hospital capacity and limit the number of deaths to the desired constraint.

**Introdution |**
This project was done in the scope of Walla Walla University's MATH 319 Optimization class. We were tasked with picking a topic and designing an optimization problem to solve. I chose COVID19 because of it's relevance to today. See the documentation file for a more indepth analysis of the relevance of the project, system formulation, and more. 

**Tools Used |**
I used Matlab's built in Sequential Quadratic Programming Optimizer _fmincon_ utilizing both the linear and nonlinear constraint functions.

**Results |**
I was unsuccessful in getting the algorithm to optimize the problem. However, through many hours of analysis, I was able to visually find a theoretical solution by manually iterating through possibilities and examining the graph of each. The theoretical solution for the state of Washington is a Stay-at-home order lasting **79 days**, starting _March 23 and ending June 10_. See the documentation file for a more indepth explanation of the results. The matlab files I used are also included for reference.

**Status |**
Much work  needs to be done on revising the design problem, and potentially choosing a different optimizer that may handle this type of problem better.

![](IMG_20200503_095123_474.jpg)
