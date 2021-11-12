% ### EXbitDepth.m ###      2018.02.01 C. Bergevin

% Goal: Simulate changing (e.g., lowering) the "bit depth" for a signal

% o base signal here is a sinusoid w/ amplitude In.A
% o very kludge way to "digitize" --> develop more efficient means

clear
% ===========================================================
In.A= 1;  % amplitude for sinusoid {5.5}
In.f= 1000;    % sinusoid frequency [Hz] {1000}
In.N= 2;     % # of bits for digitization (must be int. >= 1) {2?}
In.tL= [0 0.0012];   % time limits
In.SR= 44100;
% ===========================================================

% --- create base values
t= linspace(In.tL(1),In.tL(2),round((In.tL(2)-In.tL(1))*In.SR));  % time vals.
sig= In.A*sin(2*pi*In.f*t); % non-"digitized" signal
% --- create a "bit-limited" digitized vertical scale
spacing= (2*In.A)/(2^In.N-1);  % determines spacing between quantized vals.
digiS= linspace(-In.A,In.A,2^(In.N));  % easy way to get quantized vals.
% NOTE: should have that spacing= any val. of diff(digiS)
% --- (very) kludge way to force sig vals. to take on "bit-limited" vals.
for nn=1:numel(sig)
    indx= max(find(sig(nn)>=digiS));
    if ((sig(nn)-digiS(indx))<=(digiS(indx+1)-sig(nn))), sigQ(nn)= digiS(indx);
    elseif ((sig(nn)-digiS(indx))>(digiS(indx+1)-sig(nn))), sigQ(nn)= digiS(indx+1);  end
end
% ---
figure(1); clf;
h1= plot(t,sig); hold on; grid on;
h2= plot(t,sigQ,'r--','LineWidth',2);
xlabel('Time [s]'); ylabel('Signal [arb]');
legend([h1 h2],'base signal','bit-limited version')
