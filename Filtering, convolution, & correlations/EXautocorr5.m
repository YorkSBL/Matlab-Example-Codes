% ### EXautocorr5.m ###     12.05.14
% Creates a random-length (and possibly noisy) boxcar train and computes
% the autocorrelation
% *** NOTE ***: Something seems awry, as the two do not match. It appears the periodic 
% boundary condition is violated for the autocorrlation [incorrectly
% extracting autocorrelation for FFT?]
clear
% ---
maxN= 8192;     % largest possible buffer length
SR= 44100;      % sample rate [Hz]
scaleN= 0.00;    % scale factor for noise
Rp= 20;          % scale factor for number of repeats
frac= 0.5;      % max. fraction of boxcar being 'on' re window length 
% -------------------------------------------------
N= ceil(rand(1)*maxN);  % randomize individual boxcar length
R= floor(2*Rp*rand(1)); % randomized # of 'repeats'
x= linspace(0,N,N); % determine range
t= x/SR;        % convert to a time
dt= 1/SR;  % spacing of time steps
nPts= N*R;      % total # of points
freq= SR*(0:nPts/2)./nPts;    % create a freq. array (for FFT bin labeling)
% ---
On= round(rand(1)*0.1*N);   % starting index of 'on' portion of boxcar (arb. constrained near start)
L= round(rand(1)*frac*N);   % length of 'on' portion (never more than frac)
boxcar= zeros(N,1)'; boxcar(On:On+L)= ones(L+1,1);   % build boxcar 'kernel'
% ---
% kludge way to build up signal; tamps down at edges (then adds noise)
y= []; time= [];
for nn=1:R
    temp= boxcar+ scaleN*randn(1,N);
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
figure(1); clf; plot(linspace(0,numel(y)/SR,numel(y)),y,'b.-');  hold on; grid on;
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
subplot(211); plot(freq,db(specW)); hold on; grid on; title('Power spectrum')
xlabel('Frequency [Hz]'); ylabel('Magnitude [dB]'); xlim([0 0.8*R*SR/N]);
subplot(212); plot(freq,db(specAC)); hold on; grid on; title('FT of autocorrelation')
xlabel('Frequency [Hz]'); ylabel('Magnitude [dB]'); xlim([0 0.8*R*SR/N]);


