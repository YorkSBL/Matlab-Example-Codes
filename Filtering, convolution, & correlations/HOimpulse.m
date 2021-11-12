function y= HOimpulse(P)
% ### HOXimpulse.m ###       10.02.14
% Numerically integrate the damped/driven harmonic oscillator
%   m*x''+ b*x' + k*x = A*sin(wt)
% for an impulse at t=0 to determine the associated impulse response
% ----------------------------------------------------------------------
% +++
% spit back out some basic derived quantities
P.wr= 2*pi*P.fD;  % convert to angular freq.
disp(sprintf('Resonant frequency ~%g [Hz]', sqrt(P.k/P.m)/(2*pi)));
Q = (sqrt(P.k/P.m))/(P.b/P.m);  % quality factor
disp(sprintf('Q-value = %g', Q));
% +++
P.t0 = 0.0;   % Start value
P.tf = P.length/P.SR;   % Finish value
P.dt = 1/P.SR;  % time step
% +++
options = odeset ('MaxStep',P.dt);
% use built-in ode45 to solve
%[t y] = ode45('HOfunction', [P.t0:P.dt:P.tf],P.y0,[],P); % linear
[t y] = ode45(@(t,y) HOfunction(t,y,[],P), [P.t0:P.dt:P.tf],P.y0,options); % linear, fixed step-size (not adaptive)
% +++
% determine 'impulse resonse
impulseR= rfft(y(:,1));
% +++
% create a freq. array (for FFT bin labeling)
freq= [0:P.length/2];
freq= P.SR*freq./P.length;
% ------------------------------------------------------
figure(1); clf;
subplot(211)
plot(freq/1000,db(impulseR),'k-','MarkerSize',1)
ylabel('Magnitude [dB]');   grid on;    hold on;
subplot(212)
plot(freq/1000,cycs(impulseR),'k-','MarkerSize',1)
xlabel('Frequency [kHz]');  ylabel('Phase [cycles]');   grid on;
% visualize in time domain and/or phase space?\
if 1==1
    figure(2); clf;
    plot(t,y(:,1)); hold on; grid on;
    xlabel('t [s]');    ylabel('x(t) [m]')
end
if 1==0
    % Phase plane
    figure(2); clf;
    plot(y(:,1), y(:,2)); hold on; grid on;
    xlabel('x [m]');    ylabel('dx/dt [m/s]')
end
y.f= freq/1000; % [kHz]
y.impulse= impulseR;
return