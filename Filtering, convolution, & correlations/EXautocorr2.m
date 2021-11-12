% ### EXautocorr2.m ###     11.24.14
% Simple code to demonstrate that the cross-correlation between two
% independent noise signals is ~zero and that the autocorrelation for one is impulse-like
% NOTE: Also try changing randn to rand
clear
% --------------------------------
SR= 44100;         % sample rate [Hz]
Npoints= 8192;     % length of fft window (# of points) [should ideally be 2^N]
% --------------------------------
freq= [0:Npoints/2];    % create a freq. array (for FFT bin labeling)
freq= SR*freq./Npoints;
if 1==0
    % create two different Gaussian noise patterns
    noise1= randn(Npoints,1);   noise2= randn(Npoints,1);
else
    % create two different uniformly-distributed noise patterns
    noise1= 2*rand(Npoints,1)-1;   noise2= 2*rand(Npoints,1)-1;
end
% +++
% use home-built function (correlate1) or Matlab's (xcorr) --> both yield same #s
if (1==0),  AC= correlate1(noise1,noise1); CC= correlate1(noise1,noise2);
else AC= xcorr(noise1,noise1); CC= xcorr(noise1,noise2);    end
% +++
figure(1); clf; subplot(211); plot(AC);
xlabel('Shift [sample #]'); title('Noise autocorrelation')
subplot(212);   plot(CC)
xlabel('Shift [sample #]'); title('Cross-correlation between two Gaussian noise waveforms')