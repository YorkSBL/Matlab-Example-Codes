% ### EXautocorr3.m ###     11.24.14
% Simple code to demonstrate that the cross-correlation between two (noisy)
% sinusoids
% NOTE: The symmetry here (i.e., autocorrelation is an even function) ties
% back to the positive/negative frequency symmetry of the Fourier transform

clear
% -------------------------------- 
SR= 44100;         % sample rate [Hz]
Npoints= 8192;     % length of fft window (# of points) [should ideally be 2^N]
f= 0.2;            % 'stimulus' freq. [kHz]
noiseAMP= 5;       % amplitude (re 1) of noise {1}
% -------------------------------- 
freq= [0:Npoints/2];    % create a freq. array (for FFT bin labeling)
freq= SR*freq./Npoints;
t= (0:1/SR:(Npoints-1)/SR);    % create an array of time points, Npoints long
df = SR/Npoints;    % quantize the 'stim.' freq. (so to have an integral # of cycles)
fQ= ceil(1000*f/df)*df;   % quantized natural freq. [Hz] 
wf1= cos(2*pi*fQ*t) + noiseAMP*randn(size(t,2),1)';  % create two sinusoids, same freq. but diff. noise
wf2= cos(2*pi*fQ*t) + noiseAMP*randn(size(t,2),1)'; 
% +++
figure(1); clf;
subplot(211); plot(xcorr(wf1,wf1));
xlabel('Shift [sample #]'); title('(Noisy) Sinusoid autocorrelation')
subplot(212);
plot(xcorr(wf1,wf2))
xlabel('Shift [sample #]'); title('Cross-correlation between two (noisy) sinusoids')