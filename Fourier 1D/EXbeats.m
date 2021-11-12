% ### EXbeats.m ###           09.27.12 CB (updated 2016.01.17)

% Plots sum of two sinusoids with different amplitudes/frequencies/phase
% offsets to demonstrate variety of "beating" patterns

% Notes
% - uses cosines of form A*cosin(w*t-phi) [could use sines instead, but that
% just introduces phase offset of pi/2]
% - option to also plot in Fig.2 several possible different
% analytically-derived expressions for the sum (incl. an incorrect one from
% Serdyuk's book); note that those expressions assume cosines being added


clear
% =================================
% Parameters for each of the two sinusoids
A1= 1.0;           % amplitude 1
A2= 1.0;         % amplitude 2
w1= 1.0;     % angular frequency 1
w2= 1.2;     % angular frequency 2
phi1= pi/2;    % phase offset 1 (>=0 and <= 2*pi)
phi2= pi/2;    % phase offset 2

tmax= 120;    % max. time value {6}
N= 1000;    % # of points to compute {200}
% =================================

% ---
t=linspace(0,tmax,N);       % time variable
s1= A1*cos(w1*t- phi1);
s2= A2*cos(w2*t- phi2);   % calculate both sinusoids and sum
A= s1+ s2;
% ---
% other (analytically-derived) expressions for the sum

B= cos((w1+w2)/2*t).*(A1*cos((w1-w2)/2*t) + A2*cos((w1-w2)/2*t)); % from Serdyuk (which is incorrect)
% 2. CB calculated version
C= cos((w1+w2)/2*t).*(A1*cos((w1-w2)/2*t) + A2*cos((w1-w2)/2*t) ) + ...
    sin((w1+w2)/2*t).*(-A1*sin((w1-w2)/2*t) + A2*sin((w1-w2)/2*t) );
% 3. CB calculated version (factored)
D= (A1+A2)*cos((w1+w2)/2*t).*cos((w1-w2)/2*t) + ...
    (A2-A1)*sin((w1+w2)/2*t).*sin((w1-w2)/2*t);
% ---
figure(1); clf;
h1= plot(t,s1,'r'); hold on; grid on;
h2= plot(t,s2,'b--');
h3= plot(t,A,'k','LineWidth',3);
xlabel('Amplitude [arb]'); ylabel('Time [arb]');
legend([h1 h2 h3],'sinusoid 1','sinusoid 2','sum');
% ---
if 1==1
    figure(2); clf;
    plot(t,A,'k','LineWidth',2); hold on; grid on;
    %plot(t,B,'r--'); plot(t,C,'go'); 
    plot(t,D,'r.');
end
