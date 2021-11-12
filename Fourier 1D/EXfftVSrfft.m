% ### EXfftVSrfft.m ###       09.21.15 CB (updated 2020.09.21)

% Purpose: Demonstrate the difference (and associated syntax) between
% Matlab's built-in fft.m algorithm and that of rfft.m for real-valed 1-D
% waveforms (the point being how to ignore redundant info and to properly
% normalize). To illustrate, uses a noisy sinusoid as the example

clear;
% -------------------------------- 
SR= 44100;         % sample rate [Hz]
Npoints= 8192;     % length of fft window (# of points) [should ideally be 2^N]
                   % [time window will be the same length]
f= 2580.0;         % Frequency (for waveforms w/ tones) [Hz]
noiseA= 0.001;        % amplitude factor for relative (flat-spectrum) noise
% -------------------------------- 
% ==== 
df = SR/Npoints;  
fQ= ceil(f/df)*df;   % quantized natural freq.
t=[0:1/SR:(Npoints-1)/SR];  % create an array of time points, Npoints long
dt= 1/SR;  % spacing of time steps
freq= [0:Npoints/2];    % create a freq. array (for FFT bin labeling)
freq= SR*freq./Npoints;
% =====
if (1==1),   base= cos(2*pi*f*t);   % non-quantized sinusoid
else      base= cos(2*pi*fQ*t);  end  % quantized sinusoid
noise= randn(1,Npoints);      % Gaussian
signal= base+ noiseA*noise;
% ===== *** rfft ***  (NOTE: rfft.m just takes 1/2 of fft.m output and nomalizes)
sigSPEC1= rfft(signal);
% ===== *** fft ***  (NOTE: need to parse up fft.m)
% (borrowed syntax from http://www.mathworks.com/help/signal/ug/psd-estimate-using-fft.html)
N = length(signal);  % this should be the same as Npoints
temp= fft(signal);
xdft = temp(1:N/2+1);   % toss redundant half
sigSPEC2 = (2/N)* abs(xdft);   % normalize (mag. only); note that power spectrum normalizes re SR too
freq2 = 0:SR/N:SR/2;
% =====
figure(1); clf; plot(freq/1000,db(sigSPEC1),'ko-','MarkerSize',3); grid on; hold on;
plot(freq2/1000,db(sigSPEC2),'r-'); 
ylabel('Magnitude [dB]'); xlabel('Frequency [kHz]'); title('Comparison of rfft.m vs fft.m')
legend('rfft','fft');
% =================== illustrate syntax for "double" spectrum (vis fftshift.m)
figure(2); clf; 
sigSPEC3=  (2/N)* fftshift(temp); 
freq3 = -SR/2:SR/N:SR/2; 
plot(freq3(1:Npoints),db(sigSPEC3));  hold on; grid on;   % kludge(re 1:Npoints?)
ylabel('Magnitude [dB]'); xlabel('Frequency [kHz]'); title('Spec. w/ negative freqs.')

