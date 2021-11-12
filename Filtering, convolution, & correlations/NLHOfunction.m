function [out1] = NLHOfunction(t,y,flag,P)
% ----------------------------------------------------------------------
% adding in a cubic stiffness term
%   y(1) ... position x
%   y(2) ... velocity dx/dt
b= 1;
out1(1)= y(2); 
out1(2)= -1*(P.b/P.m)*y(2) - (P.k/P.m)*(1+b*y(1)^2)*y(1) + (P.A/P.m)*sin(P.wr*t); 
out1= out1';    % wants output as a column vector
