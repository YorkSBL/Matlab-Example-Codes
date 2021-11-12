% ### EXanimateMotion.m ###       2017.01.19 CB

% demonstrates syntax to "animate" data (borrowed some elements from
% EXrandom2Wwalk.m) as well as function calls

clear
% ================================

% most of these bits are overly complicated for the main purpose of this
% code (i.e., it is "flashier" than it needs to be)
xlim= [-1.5 0.4];    % plotting limits {[-1.5 0.4]}
P.p= [0.1 0.2 0.1 0.005 0.1];     % params for a quartic function
P.dur= 100;     % "duration" for animation {100}
% ================================

% ---
x= linspace(xlim(1),xlim(2),P.dur);   % array of "reaction coord." values (for plotting)
E= @(x) P.p(1)*x.^4+ P.p(2)*x.^3+ P.p(3)*x.^2+ P.p(4)*x+ P.p(5); % energy function
y= 0.8*sin(2*pi*0.5*x)- 0.5;
xP= E(y);

% ---
figure(1); clf;
plot(x,E(x),'r-'); hold on; grid on;
p= plot(x(1),y(1),'bo','LineWidth',2);
for nn=2:length(y)
    p.XData = y(nn);    p.YData = xP(nn);
    drawnow
end
