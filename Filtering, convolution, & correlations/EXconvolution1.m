% ### EXconvolution1.m ###  11.07.14
% Example code to perform convolution between a two user-defined binary sequences
clear
% --------------------------------
wf1=[0 0  1 1 1 0 0];
wf2= [0 0 0 0 0 0 1.0000 0.6065 0.3679 0.2231 0.1353 0.0821 0.0498 0.0302 0.0183 0.0111 0.0067];
% --------------------------------
% Use custom code (convolve1.m) or Matlab's built-in function? [should return identical answers]
if 1==1
    C= convolve1(wf1,wf2);  % custom code
else
    C= conv(wf1,wf2);   % Matlab's built-in function
end
% +++
figure(1); clf;
subplot(211)
stem(wf1,'b'); hold on; grid on;
stem(wf2,'diamondr','filled'); xlabel('Sample #'); ylabel('Amplitude');
subplot(212)
stem(C,'k'); hold on;
% % y= exp(-5*x) for x=[0,1]
