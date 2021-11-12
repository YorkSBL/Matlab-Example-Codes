% ### EXfilteredNoiseStats.m ###  10.03.14

% This code determines the impulse response for a linear harmonic
% oscillator and subsequently convolves (via multiplication in the spectral
% domain) it with a Gaussian noise, then determines the associated
% amplitude distribution

% - uses external function HOimpulse.m (which in turn requirse HOfunction.m)
% - uses a fixed step-size (so to avoid distortion generated via ode45's
% adaptive step-size routine)

clear
% ----------------------------------------------------------------------

P.y0(1) = 0.0;   % initial position [m] {0}
P.y0(2) = 10000.0;   % initial velocity [m/s] {10000}
P.b= 0.01;  % damping coefficient [kg/s] {0.01}
P.k= 25000.0;   % stiffness [N m] {25000}
P.m= 0.0001;    % mass [kg] {0.0001}
% Integration limits
P.SR= 44100;    % sample rate {44100}
P.length= 8192*2;    % # of samples to run {16384}

% ----------------------------------------------------------------------
% sinusoidal driving term (set to zero here)
P.A= 0.0;   % amplitude [N] (set to zero to turn off)
P.fD= 1.05*sqrt(P.k/P.m)/(2*pi);  % freq. (Hz) [expressed as fraction of resonant freq.]
% ---
% determine impulse response (returned as complex FFT)
impulseR= HOimpulse(P);
% ---
% generate noise (Gaussian): flat spectrum, random-phase
Asize= P.length/2 +1;
% create array of complex numbers w/ random phase and unit magnitude
for n=1:Asize
    theta= rand*2*pi;
    N2(n)= exp(i*theta);
end
noiseSpec=N2';
% now take the inverse FFT to get time-domain version
signalTime=irfft(noiseSpec);
t= linspace(0,P.length/P.SR,P.length);  % associated time values
% ---
% convolve noise and impulse response (by multiplying in freq. domain via
% the convolution theorem, and then inverse FFT back)
convS= noiseSpec.* impulseR.impulse;    % SPECTRAL
convT= irfft(convS);                    % TEMPORAL (via inverse fft)
% ---
% plot the associated amplitude distribution
figure(3); clf; subplot(211)
hist(convT,40);
hold on; grid on; xlabel('Amplitude [arb]');    ylabel('Counts')
title('Histogram of amplitude distribution of noise convolved with impulse response of linear harmonic oscillator')
subplot(212)
plot(t,convT); hold on; grid on;
xlabel('t [s]'); ylabel('x(t)')