f=[-1 1 -2 2];
A=[-1 1 -1 1;
    -1 1 2 -2;
    1 -1 0 0;
    0 0 -1 1];
b=[-1 -1 0 0];
% Aeq=[-2 3];
% beq=3;
[x fval]=linprog(f,A,b);
fmin=fval
