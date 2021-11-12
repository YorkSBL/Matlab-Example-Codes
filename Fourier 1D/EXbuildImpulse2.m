% ### EXbuildImpulse2.m ###       11.03.14 CB (updated 2020.09.15)
% Code to visually build up a signal by successively adding higher and
% higher frequency terms from corresponding FFT
% 1. first create a (simple 'digital') signal
% 2. determines the associated FFT
% 3. finally visually builds the signal back up (this can take a few min.)
% NOTE: for a pure impulse, make sure INDXoff-INDXon=1

clear; 
% ======================================
SR= 44100;         % sample rate [Hz]
Npoints= 8192;     % length of fft window (# of points) [should ideally be 2^N]
% [time window will be the same length]
INDXon= 3000;     % index at which click turns 'on' (i.e., go from 0 to 1)
INDXoff= 5010;   % index at which click turns 'off' (i.e., go from 1 to 0)
% ======================================
% ----
dt= 1/SR;  % spacing of time steps
freq= [0:Npoints/2];    % create a freq. array (for FFT bin labeling)
freq= SR*freq./Npoints;
t=[0:1/SR:(Npoints-1)/SR]; % create an appropriate array of time points
% --- -build signal
clktemp1= zeros(1,Npoints); clktemp2= ones(1,INDXoff-INDXon);
signal= [clktemp1(1:INDXon-1) clktemp2 clktemp1(INDXoff:end)];
% ------------------------------
% ----
% plot "final" time waveform of signal
if 1==0
    figure(3); clf; plot(t*1000,signal,'ko-','MarkerSize',5)
    grid on; hold on; xlabel('Time [ms]'); ylabel('Signal'); title('Time Waveform')
end
% ----
sigSPEC= rfft(signal);   % now compute/plot FFT of the signal
% ---- plot associated mag. and phase
figure(1); clf;
subplot(211); plot(freq/1000,db(sigSPEC),'ko-','MarkerSize',2)
hold on; grid on; ylabel('Magnitude [dB]'); title('Spectrum (or "Look Up Table")')
subplot(212); plot(freq/1000,cycs(sigSPEC),'ko-','MarkerSize',2)
xlabel('Frequency [kHz]'); ylabel('Phase [cycles]'); grid on; hold on;
% ----
% now make animation of click getting built up, using the info from the FFT
sum= zeros(1,numel(t)); % (initial) array for reconstructed waveform
inclV=[1:30,floor(linspace(31,floor(0.9*numel(freq)),100)),...
    floor(linspace(0.9*numel(freq),numel(freq),20))];
figure(2); clf; grid on;
for nn=1:numel(freq)
    sum= sum+ abs(sigSPEC(nn))*cos(2*pi*freq(nn)*t + angle(sigSPEC(nn)));
    % ----
    if ismember(nn,inclV)
        figure(1)
        subplot(211); plot(freq(1:nn)/1000,db(sigSPEC(1:nn)),'rx','MarkerSize',3);
        subplot(212); plot(freq(1:nn)/1000,cycs(sigSPEC(1:nn)),'rx','MarkerSize',3)
        figure(2);
        plot(t,sum,'LineWidth',2); grid on; xlabel('Time [s]');
        legend(['Highest freq= ',num2str(freq(nn)/1000),' kHz'])
        pause(3/(nn));
    end
end


