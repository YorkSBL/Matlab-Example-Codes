% ### EXquantizeF.m ###       11.04.14
% code to demonstrate effects/necessity of quantizing freq. for discrete FFT
% [that is, making sure the signal is periodic re the interval]
clear;
% --------------------------------
f= 531.4;         % freq. {1000}
SR= 44100;         % sample rate {44100}
Npoints= 32768;     % length of fft window (# of points) [should ideally be 2^N] {8192}
% --------------------------------
% +++
dt= 1/SR;  % spacing of time steps
freq= [0:Npoints/2];    % create a freq. array (for FFT bin labeling)
freq= SR*freq./Npoints;
% +++
% quantize the freq. (so to have an integral # of cycles)
df = SR/Npoints;
fQ= ceil(f/df)*df;   % quantized natural freq.
disp(sprintf('specified freq. = %g Hz', f));
disp(sprintf('quantized freq. = %g Hz', fQ));
% +++
% create an array of time points, Npoints long
t=[0:1/SR:(Npoints-1)/SR];
% +++
w= sin(2*pi*f*t);   % non-quantized version
wQ= sin(2*pi*fQ*t); % quantized version
wH= hanning(Npoints).*w';   % also window the non-quantized version...
% +++
% plot time waveforms for comparison
figure(1); clf;
subplot(211)
plot(t*1000,w,'o-'); hold on; grid on;
plot(t*1000,wQ,'rs-');
plot(t*1000,wH,'k--d');
axis([0 5 -1.1 1.1]); legend('regular vers.','quantized vers.','regular w/ Hanning window')
xlabel('Time [ms]'); ylabel('Amplitude')
title('Comparison of start of interval of quantized vs non-quantized sinusoids')
subplot(212)
plot(t*1000,w,'o-'); hold on; grid on;
plot(t*1000,wQ,'rs-')
plot(t*1000,wH,'k--d')
axis([t(end-200)*1000 t(end)*1000 -1.1 1.1])
xlabel('Time [ms]'); ylabel('Amplitude')
title('Comparison of end of interval of quantized vs non-quantized sinusoids')
% +++
% now plot spectra for comparison
figure(2); clf;
plot(freq,db(rfft(w)),'o-','MarkerSize',3); hold on;
plot(freq,db(rfft(wQ)),'rs-','MarkerSize',4)
plot(freq,db(rfft(wH)),'k--d','MarkerSize',5)
xlabel('freq. [Hz]'); ylabel('magnitude [dB]');
grid on; axis([0 1.5*f -350 10])
legend('non-quantized version','quantized version','Windowed non-quantized','Location','SouthWest')
% +++
% plot time waveforms on longer scale to see effect of windowing
if 1==1
    figure(3)
    plot(t*1000,w,'o-'); hold on; grid on;
    plot(t*1000,wQ,'rs-');
    plot(t*1000,wH,'k--d');
    legend('regular vers.','quantized vers.','regular w/ Hanning window')
    xlabel('Time [ms]'); ylabel('Amplitude')
end
