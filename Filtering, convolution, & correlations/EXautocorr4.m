% ### EXautocorr4.m ###     12.02.14
% Demonstrates how to use autocorrelation to ascertain 'how long does it
% take for a noisy signal to repeat itself?'
% **NOTE** Code not yet complete (need some way to extract the spacing of
% the appropriate maxima from the autocorrelation sans a FFT)
clear
% ---
maxN= 8192;     % largest possible buffer length
SR= 44100;      % sample rate [Hz]
scaleN= 2.05;    % scale factor for noise
R= 5;          % number of repeats
% -------------------------------------------------
N= ceil(rand(1)*maxN);
x= linspace(0,N,N); % determine range
t= x/SR;        % convert to a time
polyS= ceil(10*rand(1));   % randomly determine polynomial order
Pv= 2*rand(polyS,1)-1;  % polynomial coefficients
freqR= 100*(1+scaleN*randn(1));     % randomize up a bit the sin freq. (but not from run to run)
dt= 1/SR;  % spacing of time steps
nPts= N*R;      % total # of points
freq= SR*(0:nPts/2)./nPts;    % create a freq. array (for FFT bin labeling)
% ---
% kludge way to build up signal; tamps down at edges (then adds noise)
y= []; time= [];
for nn=1:R
    temp= hanning(N)'.*(polyval(Pv,t)+sin(freqR*2*pi*t))+scaleN*randn(N,1)';
    y= [y temp]; % pseudo-random 'data'
    
end
% ---
% autocorrelation (via Matlab's cross-correlation routine or a home-built function; 
% the two yhield the same answer, but Matlab's function is faster)
if (1==1),  hh= xcorr(y,y);    
else hh= correlate1(y,y); end
thh= linspace(-N*R/SR,N*R/SR,numel(hh));
hh= hh/max(hh(:));  % normalize to unity
% +++
% plot time waveform
figure(1); clf; plot(linspace(0,numel(y)/SR,numel(y)),y);  hold on; grid on;
xlabel('Time [s]'); ylabel('Signal'); title('Original waveform');
% +++
% plot autocorrelation
figure(2); clf; plot(thh,hh); hold on; grid on; xlabel('Lag [s]'); ylabel('AC'); title('Autocorrelation');
% ---
% now we need some means to extracts the spacing between the relevant maxima...
tf= numel(hh);  % kludge to handle indexing 'end'?
aCorr= hh(ceil(tf/2):tf);    % toss half (redundant due to symmetry)
specAC= rfft(aCorr); specW= rfft(y);
% +++
% plot spectra for comp.
figure(3); clf;
subplot(211); plot(freq,db(abs(specW).^2)); hold on; grid on; title('Power spectrum')
xlabel('Frequency [Hz]'); ylabel('Magnitude [dB]');
subplot(212); plot(freq,db(specAC)); hold on; grid on; title('FT of autocorrelation')
xlabel('Frequency [Hz]'); ylabel('Magnitude [dB]');


