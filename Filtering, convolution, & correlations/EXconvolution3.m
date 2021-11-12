% ### EXconvolution3.m ###      11.07.14
% Based off of EXconvolution2.m, the purpose of this code is to provide a
% computationally demonstration of the convolution theorem
% --> likely needs more work (circularity issues due to clumsy handling?)
clear
% --------------------------------
SR= 44100;         % sample rate [Hz]
Npoints= 8192;     % length of fft window (# of points)
f= 580.0;         % wf1: Frequency (for waveforms w/ tones) [Hz]
CLKbnd= [2000 2008];     % wf2: indicies at which pulse turns 'on' and then 'off'
% --------------------------------
% +++
t=[0:1/SR:(Npoints-1)/SR];  % create an array of time points
% +++
% create two waveforms (same dimensions)
wf1= cos(2*pi*f*t);
clktemp1= zeros(1,Npoints);
clktemp2= ones(1,CLKbnd(2)-CLKbnd(1));
wf2= [clktemp1(1:CLKbnd(1)-1) clktemp2 clktemp1(CLKbnd(2):end)];
% +++
% Use custom code (convolve1.m) or Matlab's built-in function? [should return identical answers]
if 1==1
    C= convolve1(wf1,wf2);  % custom code
else
    C= conv(wf1,wf2);   % Matlab's built-in function
end
% +++
spec1= fft(wf1);   % compute FFT of each waveform
spec2= fft(wf2);
convF= spec1.*spec2;
wfC= ifft(convF);
% +++
figure(1); clf;
subplot(211)
plot(t,wf1,'b'); hold on; grid on;
plot(t,wf2,'r'); xlabel('Time [s]'); ylabel('Amplitude');
subplot(212)
plot(C,'k'); hold on;
figure(2); clf;
plot(t,wfC);

