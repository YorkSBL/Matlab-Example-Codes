% ### EXlowpassWF.m ###
% Creates a low-pass filter and shows
% spectral representation and associated (inverse Fourier transformed) waveform
% NOTE: Reconstructed waveform implicitly assumes a periodic boundary condition
clear
% -----
In.SR= 44100;       % associated sample rate [Hz]
In.Npoints= 8192*1;   % length of associated time waveform (FFT size will be x0.5+1)
In.CF= 1000;        % filter cut-off frequency [Hz]
In.BW= 100;         % filter bandwidth [Hz]
In.filterCorner= 1; % 'filter order' (i.e., corner sharpness) for recexp2 [10]
% -----
freq= [0:In.SR/In.Npoints:In.SR/2];      % determine freq. bins for spectrum
w= 2*pi*freq;
F= 1./(1+i*w./(2*pi*In.CF));    % determine filter from specified parameters
waveform= irfft(F);
t=[0:1/In.SR:(In.Npoints-1)/In.SR];  % create an array of time points
% ---
figure(1); clf;
subplot(211)
semilogx(freq/1000,db(F)); grid on;
ylabel('Magnitude [dB]');
subplot(212)
semilogx(freq/1000,cycs(F)); grid on;
xlabel('Frequency [kHz]'); ylabel('Phase [cycles]');
figure(2); clf;
plot(t,waveform); grid on;
xlabel('Time [s]'); ylabel('Amplitude [arb]')