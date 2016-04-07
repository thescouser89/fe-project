% ==============================================================================
% Name  : Dustin Kut Moy Cheung
% ID    : 996881147
% Course: Financial Engineering (APS-502)
% Title : Project Part 1
% ==============================================================================
clear all;

% p is the purchase price
p = [20 25 30 35 40 45 50 55 60 65];

% c is the current price
c = [30 34 43 47 49 53 60 62 64 66];

% f is the future price in one year
f = [36 39 42 45 51 55 63 64 66 70];

% there are no lower bound equations
A = zeros(1, 10);
b = 0;

% there are equality equations
% here we make sure that we can get $30000 after taxes currently
Aeq = -0.69 * c - 0.3 * p;
beq = 30000 - sum(69 * c + 30 * p);

% We make sure that the shares sold are between 0 and 100
lb = zeros(1, 10);
ub = 100 * ones(1, 10);

% do the linear programming
% a: represents the shares remaining after selling currently
% fval: expected return of remaining stocks in 1 year
[a, fval] = linprog(- f, A, b, Aeq, beq, lb, ub);

% u is the shares to be sold currently
u = 100 - a;

p
c
f
A
b
Aeq
beq
lb
ub
a
fval
u
