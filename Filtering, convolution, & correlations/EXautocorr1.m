% ### EXautocorr1.m ###     11.24.14
% Simple code to demonstrate the Wiener-Khintchine theorem: that the
% Fourier transform (FT) of a function's autocorrelation is equal to the power
% spectrum of said function (that being 1-D and real-valued here)
% *** NOTE ***: Something seems awry, as the two do not match. It appears the periodic 
% boundary condition is violated for the autocorrlation [incorrectly
% extracting autocorrelation for FFT?]

clear
% --------------------------------
SR= 44100;         % sample rate {44100}
Npoints= 8192;     % length of fft window (# of points) [should ideally be 2^N] {8192}
f= 1.02;            % 'stimulus' freq. [kHz]
noiseAMP= 1.1;       % amplitude (re 1) of noise {1}
% --------------------------------
dt= 1/SR;  % spacing of time steps
nPts= Npoints;      % total # of points
freq= SR*(0:Npoints/2)./Npoints;    % create a freq. array (for FFT bin labeling)
df = SR/Npoints;    % quantize the 'stim.' freq. (so to have an integral # of cycles)
fQ= ceil(1000*f/df)*df;   % quantized natural freq. [Hz]
[temp indxF]= max(freq==fQ);    % find freq. array index for sinusoid
t= (0:1/SR:(nPts-1)/SR);    % create an array of time points, Npoints long
% +++
% quantized sinusoid + gaussian noise
wQ= sin(2*pi*fQ*t) + noiseAMP*randn(size(t,2),1)';
% autocorrelation (via Matlab's cross-correlation routine or a home-built function)
if (1==0),  hh= xcorr(wQ,wQ);    
else hh= correlate1(wQ,wQ); end
tf= numel(hh);  % kludge to handle indexing 'end'?
aCorr= hh(ceil(tf/2):tf);    % toss half (redundant due to symmetry)
specAC= rfft(aCorr);
specW= rfft(wQ);
% +++
% plot time waveform
figure(1); clf;
subplot(211); plot(t,wQ);
xlabel('Time [s]'); ylabel('Signal'); title('Original waveform');
subplot(212); plot(linspace(-Npoints/SR,Npoints/SR,tf),hh);
xlabel('Lag [s]'); ylabel('Auto corr.'); title('Autocorrelation');

% +++
% plot spectra for comp.
figure(2); clf;
subplot(211)
plot(freq,db(abs(specW).^2)); hold on; grid on; title('Power spectrum')
xlabel('Frequency [Hz]'); ylabel('Magnitude [dB]');
subplot(212)
plot(freq,db(specAC)); hold on; grid on; title('FT of autocorrelation')
xlabel('Frequency [Hz]'); ylabel('Magnitude [dB]');

