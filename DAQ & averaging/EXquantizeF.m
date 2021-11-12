% ### EXquantizeF.m ###       04.02.09
% Code to show effects/necessity of quantizing freq.
% [NOTE - requires: db.m, rfft.m, and hanning.m]

clear;
% --------------------------------
f= 531.4;         % freq. {1000}
SR= 44100;         % sample rate {44100}
Npoints= 32768;     % length of fft window (# of points) [should ideally be 2^N] {8192}
% --------------------------------
dt= 1/SR;  % spacing of time steps
freq= SR*(0:Npoints/2)./Npoints;    % create a freq. array (for FFT bin labeling)
df = SR/Npoints;    % quantize the freq. (so to have an integral # of cycles)
fQ= ceil(f/df)*df;   % quantized natural freq.
disp(sprintf('specified freq. = %g Hz', f));
disp(sprintf('quantized freq. = %g Hz', fQ));
t=[0:1/SR:(Npoints-1)/SR];  % create an array of time points, Npoints long
w= sin(2*pi*f*t);   % non-quantized version
wQ= sin(2*pi*fQ*t); % quantized version
wH= hanning(Npoints).*w';  % could also apply a window too to the non-quantized version
% +++
% plot time waveforms for comparison
figure(1); clf;
subplot(211); plot(t*1000,w,'o-'); hold on; grid on;
plot(t*1000,wQ,'rs-'); plot(t*1000,wH,'k--d')
axis([0 5 -1.1 1.1]); legend('regular vers.','quantized vers.','regular w/ Hanning window')
xlabel('Time [ms]'); ylabel('Amplitude')
title('Note: non-quantized has arbitrary # of cycles in total FFT window, quantizedhas an integer #')
subplot(212); plot(t*1000,w,'o-'); hold on; grid on;
plot(t*1000,wQ,'rs-'); plot(t*1000,wH,'k--d')
axis([t(end-200)*1000 t(end)*1000 -1.1 1.1])
xlabel('Time [ms]'); ylabel('Amplitude')
% +++
% now plot fft of both for comparison
figure(2); clf;
plot(freq,db(rfft(w)),'o-','MarkerSize',3); hold on; grid on;
plot(freq,db(rfft(wQ)),'rs-','MarkerSize',4);
plot(freq,db(rfft(wH)),'k--d','MarkerSize',5);
xlabel('Frequency [Hz]'); ylabel('Magnitude [dB]'); axis([0 1.5*f -350 10])
legend('regular version','quantized version','regular version w/ Hanning window','Location','NorthWest')