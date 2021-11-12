% ### EXaudioIllusion1.m ###    2021.08.17

% Purpose: Create an auditory "illusion" where two tones are presented (freqs. 
% f1 and f2, where f2>f1) and f1 is held constant while f2 is swept upwards
% from f1*ratio(1) to f1*ratio(2). Depending upon the listener (and
% speaker/earphone), a listener will hear both an upward pitch shift as
% well as a downward one. The latter is due to a 2f1-f2 intermodulation
% distortion. Also plots the associated stim. spectrogram.

clear
% ====================================
f1= 2000.0;         % f1 (fixed) [kHz] {2000}
ratio= [1.07 1.4];    % range of f2/f1 ratio to span {[1.07 1.4]}
dur= 5;   % duration of f2 sweep [s] {5}
sweepT= 1;  % sweept type: 0=linear, 1=log
L1= 0;  % level of f1 in dB re 1 {0}
Lratio= 0;  % dB difference of f2 re f1 {0}
phi2= 0;    % phase offset of f2 re f1 {0}
SR= 44100;         % sample rate [Hz]
% --- spectrogram bits
P.windowL= 2048;   % length of window segment for FFT {2048}
P.overlap= 0.95;    % fractional overlap between window, from 0 to 1 {0.8}
P.maxF= f1*ratio(2)*2;   % max. freq. for spectrogram [Hz] {8000}
% ====================================
% --- bookkeeping
dt= 1/SR;  % spacing of time steps
Npoints= SR* dur;
t=[0:1/SR:(Npoints-1)/SR];  % create an array of time points, Npoints long
w1= 2*pi*f1;
A1= 10^(L1/20);  % (linear) amplitude for f1
A2= A1*10^(Lratio/20);  % (linear) amplitude for f1
% --- create f2(t)
if sweepT== 0
    f2= f1*(ratio(1)+ t*(ratio(2)-ratio(1))/dur);
else
    alpha= log(ratio(2)/ratio(1))/dur;
    f2= (f1*ratio(1))*exp(alpha*t);
end
w2= 2*pi*f2;
% --- create relevant waveforms sinusoid
wf1= A1*cos(w1*t);
wf2= A2*cos(w2.*t+ phi2);
wf= wf1 + wf2;   % create combined wf
% --- create/plot spectrogram
pts= round(P.windowL*P.overlap);
spectrogram(wf,blackman(P.windowL),pts,P.windowL,SR,'yaxis');
hcb= colorbar;
h= gca;
xlabel('Time [s]'); ylabel('Frequency [Hz]'); ylabel(hcb,'Amplitude [dB]');
h.YLim= [0 P.maxF/1000];
h.XLim= [0 dur];
% --- play audio
if 1==1
    sound(wf,SR)
end