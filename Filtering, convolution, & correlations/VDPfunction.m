function [out1] = VDPfunction(t,y,flag,P)
% ----------------------------------------------------------------------
%   y(1) ... position x
%   y(2) ... velocity dx/dt
out1(1)= y(2); 
out1(2)= (P.mu/P.m)*(1-y(1)^2)*y(2) - (P.k/P.m)*y(1) + (P.A/P.m)*sin(P.wr*t); 
out1= out1';    % wants output as a column vector
