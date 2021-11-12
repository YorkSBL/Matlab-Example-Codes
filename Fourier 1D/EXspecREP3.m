% ### EXspecREP3.m ###       2014.10.29 CB (updated 2017.01.24)

% Example code to just fiddle with basics of discrete FFTs and connections
% back to common real-valued time waveforms. Demonstrates several useful 
% concepts such as 'quantizing' the frequency

% Notes
% o Requires: rfft.m, irfft.m, cycs.m, db.m, cyc.m
% o time window will be the same length as fft window (i.e., Npoints)
% o Aliasing can be shown if f>SR/2

% ------
% Stimulus Type Legend
% stimT= 0 - non-quantized sinusoid
% stimT= 1 - quantized sinusoid
% stimT= 2 - one quantized sinusoid, one un-quantized sinusoid
% stimT= 3 - two quantized sinusoids
% stimT= 4 - click (i.e., an impulse)
% stimT= 5 - noise (uniform distribution)
% stimT= 6 - chirp (flat mag.)
% stimT= 7 - noise (Gaussian distribution; flat spectrum, random phase)
% stimT= 8 - exponentially decaying sinusoid (i.e., HO impulse response)
% stimT= 9 - decaying exponential (low-pass filter)

clear;
% =========================================================================
% ---
stimT= 9;   % Stimulus Type (see legend above)
% ---
% Params for stimT=1-3
f= 4000.0;         % Frequency (for waveforms w/ tones) [Hz]
ratio= 1.22;    % specify f2/f2 ratio (for waveforms w/ two tones)
% ** Note ** Other stimulus parameters (for stimT>=4) can be changed below
% ---
SR= 44100;         % sample rate [Hz]
Npoints= 8192;     % length of fft window (# of points) [should ideally be 2^N]
soundP= 1;         % boolean re to play the sound out via the speaker {0}
inverseP= 1;         % boolean re to compute/plot the inverse FFT {0}
% =========================================================================
% ---
dt= 1/SR;  % spacing of time steps
freq= [0:Npoints/2];    % create a freq. array (for FFT bin labeling)
freq= SR*freq./Npoints;
% ---
% quantize the freq. (so to have an integral # of cycles in time window)
df = SR/Npoints;
fQ= ceil(f/df)*df;   % quantized natural freq.
t=[0:1/SR:(Npoints-1)/SR];  % create an array of time points, Npoints long
% ---
% compute stimulus
if stimT==0 % non-quantized sinusoid
    signal= cos(2*pi*f*t);
    disp(sprintf(' \n *Stimulus* - (non-quantized) sinusoid, f = %g Hz \n', f));
    disp(sprintf('specified freq. = %g Hz', f));
elseif stimT==1     % quantized sinusoid
    signal= cos(2*pi*fQ*t);
    disp(sprintf(' \n *Stimulus* - quantized sinusoid, f = %g Hz \n', fQ));
    disp(sprintf('specified freq. = %g Hz', f));
    disp(sprintf('quantized freq. = %g Hz', fQ));
elseif stimT==2     % one quantized sinusoid, one un-quantized sinusoid
    signal= cos(2*pi*fQ*t) + cos(2*pi*ratio*fQ*t);
    disp(sprintf(' \n *Stimulus* - two sinusoids (one quantized, one not) \n'));
elseif stimT==3     % two quantized sinusoids
    fQ2= ceil(ratio*f/df)*df;
    signal= cos(2*pi*fQ*t) + cos(2*pi*fQ2*t);
    disp(sprintf(' \n *Stimulus* -  two sinusoids (both quantized) \n'));
elseif stimT==4     % click
    CLKon= 1000;     % index at which click turns 'on' (starts at 1)
    CLKoff= 1001;   % index at which click turns 'off'
    clktemp1= zeros(1,Npoints);
    clktemp2= ones(1,CLKoff-CLKon);
    signal= [clktemp1(1:CLKon-1) clktemp2 clktemp1(CLKoff:end)];
    disp(sprintf(' \n *Stimulus* - Click \n'));
elseif stimT==5     % noise (flat)
    signal= rand(1,Npoints);
    disp(sprintf(' \n *Stimulus* - Noise1 \n'));
elseif stimT==6     % chirp (flat)
    f1S= 4000.0;     % if a chirp (stimT=2) starting freq. [Hz] [freq. swept linearly w/ time]
    f1E= 5000.0;   % ending freq.  (energy usually extends twice this far out)
    f1SQ= ceil(f1S/df)*df;      %quantize the start/end freqs. (necessary?)
    f1EQ= ceil(f1E/df)*df;
    % LINEAR sweep rate
    fSWP= f1SQ + (f1EQ-f1SQ)*(SR/Npoints)*t;
    signal = sin(2*pi*fSWP.*t)';
    disp(sprintf(' \n *Stimulus* - Chirp \n'));
elseif stimT==7     % noise (Gaussian)
    Asize=Npoints/2 +1;
    % create array of complex numbers w/ random phase and unit magnitude
    for n=1:Asize
        theta= rand*2*pi;
        N2(n)= exp(i*theta);
    end
    N2=N2';
    % now take the inverse FFT of that using Chris' irfft.m code
    tNoise=irfft(N2);
    % scale it down so #s are between -1 and 1 (i.e. normalize)
    if (abs(min(tNoise)) > max(tNoise))
        tNoise= tNoise/abs(min(tNoise));
    else
        tNoise= tNoise/max(tNoise);
    end
    signal= tNoise;
    disp(sprintf(' \n *Noise* - Gaussian, flat-spectrum \n'));
elseif stimT==8 % exponentially decaying cos
    alpha= 50;
    signal= exp(-alpha*t).*sin(2*pi*fQ*t);
    disp(sprintf(' \n *Exponentially decaying (quantized) sinusoid*  \n'));
elseif stimT==9 % decaying exponential
    alpha= 10000;
    signal= exp(-alpha*t);
    disp(sprintf(' \n *Decaying exponential*  \n'));
end

% ---
figure(1); clf      % plot time waveform of signal
h1= plot(t*1000,signal,'k.-','MarkerSize',5,'LineWidth',1); grid on; hold on;
xlabel('Time [ms]'); ylabel('Signal'); title('Time Waveform')
% ---
% now plot rfft of the signal (NOTE: rfft just takes 1/2 of fft.m output and nomalizes)
sigSPEC= rfft(signal);
figure(2); clf; % MAGNITUDE
subplot(211); plot(freq/1000,db(sigSPEC),'ko-','MarkerSize',3); hold on; grid on;
ylabel('Magnitude [dB]'); title('Spectrum')
subplot(212); plot(freq/1000,cycs(sigSPEC),'ko-','MarkerSize',3); % PHASE
xlabel('Frequency [kHz]'); ylabel('Phase [cycles]'); grid on;
% -------
% play the stimuli as an output sound?
if (soundP==1),  sound(signal,SR);   end
% -------
% compute inverse Fourier transform and plot?
if inverseP==1
    figure(1);
    signalINV= irfft(sigSPEC);
    h2= plot(t*1000,signalINV,'rx','MarkerSize',4)
    legend([h1 h2],'Original waveform','Inverse transform')
end





