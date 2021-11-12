% ### EXbandpassWF.m ###
% Creates a band-pass filter (via external function recexp2.m) and shows
% spectral representation and associated (inverse Fourier transformed) waveform
% NOTE: Filter phase is assumed to be constant/zero! (unless noted otherwise)
% NOTE: Reconstructed waveform implicitly assumes a periodic boundary condition
clear
% -----
In.SR= 44100;       % associated sample rate [Hz]
In.Npoints= 8192;   % length of associated time waveform (FFT size will be x0.5+1)
In.CF= 4200;        % filter center frequency (CF) [Hz]
In.BW= 100;         % filter bandwidth [Hz]
In.filterCorner= 1; % 'filter order' (i.e., corner sharpness) for recexp2 [10]
% -----
freq= [0:In.SR/In.Npoints:In.SR/2];      % determine freq. bins for spectrum
F= recexp2(freq,In.CF,In.BW,In.filterCorner);    % determine filter from specified parameters
waveform= irfft(F);
t=[0:1/In.SR:(In.Npoints-1)/In.SR];  % create an array of time points
% ---
figure(1); clf;
subplot(211)
plot(freq/1000,abs(F));
xlabel('Frequency [kHz]'); ylabel('Magnitude [arb]');
subplot(212)
plot(t,waveform)
xlabel('Time [s]'); ylabel('Amplitude [arb]')