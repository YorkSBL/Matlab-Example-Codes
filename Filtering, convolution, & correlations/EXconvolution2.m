% ### EXconvolution2.m ###      2014.11.07 CB (updated 2017.02.03)

% Example code to perform convolution between a (discrete) sinusoid (wf1) and narrow
% digital pulse (wf2); should see that the convolved signal is just the
% original sinusoid

% Note:
% o reqs. (custom-code) convolve1.m
% o allows user (via "method") to specify whether a (CB) custom-coded
% convolution code (convolve1.m) or Matlab's built-in conv.m is used

clear
% --------------------------------
SR= 44100;         % sample rate [Hz]
Npoints= 100;     % length of window (# of points) {8192}
f= 2580.0;         % wf1 Frequency (for waveforms w/ tones) [Hz]
CLKbnd= [50 51];     % wf2: indicies at which pulse turns 'on' and then 'off' {[2900 2901]]
method= 0;          % boolean to specify whether to use custom convolution code (0) or Matlab's (1) {0}
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
if (method==0), C= convolve1(wf1,wf2);  % custom code
else    C= conv(wf1,wf2);   end         % Matlab's built-in function
% +++
figure(1); clf;
subplot(211)
h1= plot(t,wf1,'b'); hold on; grid on;
h2= plot(t,wf2,'r.-'); 
legend([h1 h2],'wf1 (sinusoid)','wf2 (impulse)');
xlabel('Time [s]'); ylabel('Amplitude'); title('Two waveforms (wf1 and wf2)');
subplot(212); plot(C,'k'); hold on;
xlabel('Sample index'); ylabel('Amplitude'); title('Convolution between wf1 and wf2');
