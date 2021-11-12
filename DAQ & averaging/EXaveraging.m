% ### EXaveraging.m ###           01.14.11
% Simple code to demonstrate ideas about spectral vs temporal averaging
% Overview
% 1. Create a sinusiod+noise time waveform
% 2. Re-(under)sample it
% 3. Create time-averaged and spectrally-averaged (i.e., averaging the mag.
% of the Fourier transform)

% stimulus= 0: quantized sinusoid + gaussian noise
% stimulus= 1: % quantized sinusoid (w/ modulating freq.) + gaussian noise

% [NOTE - requires: db.m, rfft.m, irfft.m, and resample.m (if you don't have the signal 
%  processing toolbox, you may need to stick to stimulus= 0)]

clear
% --------------------------------
SR= 44100;         % sample rate {44100}
Npoints= 8192;     % length of fft window (# of points) [should ideally be 2^N] {8192}
f= 3.2;            % 'stimulus' freq. [kHz]
noiseAMP= 1;       % amplitude (re 1) of noise {1}
stimulus= 0;        % different stim. types possible (see above)
repeats= 20;        % # of averages to do
% [slightly more advanced parameters for stimulus= 1]
modDEPTH= 0.0;  % modulation depth in Hz of frequency modulation ** {2}
modFREQ= 5;   % appox. freq. of modulation envelope [Hz] ** {40} % (modulation about center frequency)
% --------------------------------
dt= 1/SR;  % spacing of time steps
nPts= repeats*Npoints;      % total # of points
freq= SR*(0:Npoints/2)./Npoints;    % create a freq. array (for FFT bin labeling)
df = SR/Npoints;    % quantize the 'stim.' freq. (so to have an integral # of cycles)
fQ= ceil(1000*f/df)*df;   % quantized natural freq. [Hz] 
[temp indxF]= max(freq==fQ);    % find freq. array index for sinusoid
t= (0:1/SR:(nPts-1)/SR);    % create an array of time points, Npoints long
% +++
if stimulus==0
    % quantized sinusoid + gaussian noise
    wQ= cos(2*pi*fQ*t) + noiseAMP*randn(size(t,2),1)'; 
elseif stimulus ==1
    % quantized sinusoid (w/ modulating freq.) + gaussian noise
    RND2int=(2*modDEPTH*rand(ceil(modFREQ*max(t)),1))-modDEPTH;
    xx=resample(RND2int,ceil(nPts/ceil(modFREQ*max(t))),1);
    xx=xx(1:size(t,2));
    wQ= cos(t.*(fQ+xx)'*2*pi)+ noiseAMP*randn(size(t,2),1)';    
end
% +++
% plot (entire) time waveform and associated FFT
if 1==1
    figure(1); clf;
    subplot(211); plot(t,wQ);
    hold on; grid on; xlabel('Time [s]'); ylabel('Signal'); title('Entire waveform');
    subplot(212); plot((SR*(0:numel(wQ)/2)./numel(wQ))/1000,db(abs(rfft(wQ))))
    axis([min(freq)/1000 max(freq)/1000 -120 10])
    %xlim([0 t(Npoints)/40])
    grid on; xlabel('Frequency [kHz]'); ylabel('FFT, magnitude [dB]'); title('FFT of entire waveform');
end
% +++
% parse up for time averaging
wAVGtime= zeros(Npoints,1);
for nn=1:repeats
    indx= (nn-1)*Npoints + 1;
    wAVGtime= wAVGtime+ wQ(indx:indx+Npoints-1)';
end
wAVGtime= wAVGtime/repeats;
specT= abs(rfft(wAVGtime)); % mag. spec. for time-averaged waveform
% +++
% parse up for spectral averaging
wAVGspec= zeros(Npoints/2+1,1);
for nn=1:repeats
    clear specTEMP;
    indx= (nn-1)*Npoints + 1;
    specTEMP= abs(rfft(wQ(indx:indx+Npoints-1)'));
    wAVGspec= wAVGspec+ specTEMP;   % Note: this isn't a waveform, but is a complex spectrum!
end
wAVGspec= wAVGspec/repeats;
specS= wAVGspec; % mag. spec. for spectral-averaged waveform
% +++
% plot time-averaged waveform (zoomed in) and FFT
minSPECamp= -70;     % dB min for y-axis of spectra
if 1==1
    figure(2); clf;
    subplot(211); plot(t(1:Npoints),wAVGtime);
    hold on; grid on; axis([0 t(Npoints)/40 -1.5 1.5])
    xlabel('time [s]'); ylabel('signal'); title('Temporally averaged waveform (zoomed-in)')
    subplot(212); plot(freq/1000,db(specT)); hold on; grid on;
    plot(freq(indxF)/1000,db(specT(indxF)),'rx','LineWidth',2)
    axis([min(freq)/1000 max(freq)/1000 minSPECamp 5])
    xlabel('Frequency [Hz]'); ylabel('Magnitude [dB]');
    disp(sprintf('Temporal avg. mag. (at stim. freq.)= %g dB', db(specT(indxF))));
end
% +++
% plot time-averaged waveform and FFT
if 1==1
    figure(3); clf;
    subplot(211); plot(t(1:Npoints),irfft(wAVGspec));   % convert back to time domain
    hold on; grid on; axis([0 t(Npoints)/40 -1.5 1.5])
    xlabel('time [s]'); ylabel('signal'); title('Specrally averaged waveform (zoomed-in)')
    subplot(212); plot(freq/1000,db(specS)); hold on; grid on;
    plot(freq(indxF)/1000,db(specS(indxF)),'rx','LineWidth',2)
    axis([min(freq)/1000 max(freq)/1000 minSPECamp 5])
    xlabel('Frequency [Hz]'); ylabel('Magnitude [dB]');
    disp(sprintf('Spectral avg. mag. (at stim. freq.)= %g dB', db(specS(indxF))));
end
