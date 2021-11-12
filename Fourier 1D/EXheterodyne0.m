% ### EXheterodyne0.m ###

% Goal: Turn a 100 Hz signal into a 150 Hz signal

% code below taken from: 
% https://www.mathworks.com/matlabcentral/answers/267956-frequency-shift-of-sine-wave

clear
t = linspace(0, 1, 1000);
S = sin(2*pi*100*t);                            % Original Signal
Sc  = sin(2*pi*50*t);                           % ?Carrier? Signal

HS = S.*Sc;                                     % Heterodyne Signal

Fs = 1000;
Fn = Fs/2;

FT1 = fft(S)/length(S);
FT2 = fft(HS)/length(HS);
Fv = linspace(0, 1, fix(length(FT1)/2)+1)*Fn;   % Frequency Vector
Iv = 1:length(Fv);                              % Index Vector

figure(1)
subplot(2,1,1)
plot(Fv, 2*abs(FT1(Iv)))
grid
subplot(2,1,2)
plot(Fv, 2*abs(FT2(Iv)))
grid

% [CB] now re filtering out the 50 Hz sub-harmonic entails the following:
% (taken from:
% https://www.mathworks.com/matlabcentral/answers/184520-how-to-design-a-lowpass-filter-for-ocean-wave-data-in-matlab)

% You need to know the passband of the filter you want to design (the frequencies you want to either keep or filter out), and the sampling frequency (Fs) at the very least. Since you have Fs, the Signal Processing Toolbox makes the rest easy. From your description, a Butterworth design is likely the best. You are always free to experiment with other designs, but the scheme I?m outlining for the Butterworth design is a prototype for all of them. You have already decided on a lowpass design, the default for all of them, so you don?t have to specify a filter type. (I usually prefer a bandpass with a very low cutoff, in the event that I want to filter out baseline drift. That?s simply my personal bias, because my signals usually have baseline drift.)
% 
%     To determine the order, start with the buttord function;
%     Use the output of buttord to design a transfer function (b,a) realization of your filter with the butter function, (I usually use 1 dB for Rp and 10 dB for Rs, but these are not relevant for Butterworth designs);
%     Use the tf2sos function to create a second-order-section representation for stability;
%     Use the trapz function (be sure to give it your sampling frequency, ?Fs?, to make the output understandable) in order to check the filter performance to be sure it is stable and does what you intend it to do;
%     Use the filtfilt function for the actual filtering, since unlike filter, filtfilt does not introduce any phase distortion.
% 
% The documentation is reasonably clear on all these, so their usage should be straightforward, but that assumes some experience in discrete signal processing. If you have any problems, follow up here and I?ll do my best to help you solve them.

