% ### EXdistortion.m ###      2018.03.02  C. Bergevin

% Simple computational means to look at how distortion is generated
% stemming from a harmonic (i.e., single sinusoidal, or two) input for a variety of
% different user-specified flavors of nonlinearity

% Notes
% o user specifies form of nonlinearity via (e.g.,) > map= @(x) x.^4;
% o some possibilities: x.^3, tanh(x), x (i.e., linear)
% o sinusoidal freqs. can be  "quantized" (i.e., integral # of periods in the
% FFT window) to lower the numeric noise floor)
% o can also use two tones rather than one (via boolean In.twoTone)

clear
% =========================================================================
% --- nonlinear mapping function (e.g., x.^4, tanh(x), (x+1).^3, abs(x))
%map= @(x) x.^4; 
map= @(x) tanh(x); 
% --- stim. waveform and FFT params.
In.f1= 2000.0;         % Frequency (for waveforms w/ tones) [Hz]
In.quantize= 1;         % quantize the freqs.? {1}
In.twoTone= 1;          % boolean for two tones {0}
In.ratio= 1.22;        % f2/f1 ratio (reqs. In.twoTone=1)
In.A= 1;                % amplitude of sinusoid(s)
In.SR= 44100;         % sample rate [Hz]
In.Npts= 8192;     % length of fft window (# of points) [should ideally be 2^N]
% =========================================================================
% ---
t=[0:1/In.SR:(In.Npts-1)/In.SR];  % create an array of time points, Npts long
dt= 1/In.SR;  % spacing of time steps
freq= [0:In.Npts/2];    % create a freq. array (for FFT bin labeling)
freq= In.SR*freq./In.Npts;
% --- quantize the freq. (so to have an integral # of cycles in time window)
df = In.SR/In.Npts;
if (In.quantize==1),    f1S= ceil(In.f1/df)*df;  f2S= ceil(In.ratio*In.f1/df)*df;
else f1S= In.f1;    f2S= In.f1*In.ratio;    end
p1= f1S*In.Npts/In.SR; % # of f1 periods in time window
%tLim= 6/f1S
% --- create base signal plus nonliear "mapped" version
if (In.twoTone==0), signal= In.A*(cos(2*pi*f1S*t));
elseif (In.twoTone==1),  signal= In.A*(cos(2*pi*f1S*t)+ cos(2*pi*f2S*t)); end
signal2= map(signal);
% --- create spectral representations (NOTE: rfft just takes 1/2 of fft.m output and nomalizes)
sigSPEC= rfft(signal);
sigSPEC2= rfft(signal2);
% --- plot various aspects
figure(1); clf;
h1= plot(t,signal,'b-','LineWidth',2); hold on; grid on;
h2= plot(t,signal2,'r--'); xlabel('Time [s]'); ylabel('Signal [arb]'); 
title('Comparison of both waveforms'); xlim([0 12/f1S]);
legend([h1 h2],'Input','Output');
% ---
figure(2); clf;
plot(signal,signal2,'k.'); hold on; grid on;
ylabel('Output'); xlabel('Input range'); title('I/O mapping function');
% ---
figure(3); clf; % MAGNITUDE
plot(freq/1000,db(sigSPEC),'b.-','MarkerSize',8,'LineWidth',2); hold on; grid on;
ylabel('Magnitude [dB]'); xlabel('Frequency [kHz]'); 
plot(freq/1000,db(sigSPEC2),'ro-','MarkerSize',8);
legend('Primaries','Nonlinear mapped vers'); title(['Nonlinear mapping: ',func2str(map)]);
