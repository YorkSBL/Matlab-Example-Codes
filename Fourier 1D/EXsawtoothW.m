% ### EXsawtoothW.m ###    2017.02.19 C.Bergevin

% Visually demonstrate the build-up of a sawtooth wave (centered about t=0)
% by adding successive (user-specified) terms of the Fourier series
% expansion; also quantify the Gibbs phenomonon

% Notes
% o Ref: ch.3.8 (pg.129) in Thornton & Marion (2004)
% o There are a few ways to quantify the overshoot (and thereby obtain the
% conventional "9%"). Here we simply compute the max. value of the Fourier
% approximantion (sawF) and then compare that to the max. value of the
% actual sawtooth (sawT), which occurs at a differne time

clear
% ===========================================================
P.order= [1 2 4 8 15 25 100 500];   % array of # of terms to compute {[1 2 4 8 15 25 100 500]}
P.tau= 1;   % period {1}
P.A= 1;     % peak-to-peak amplitude {1}
P.M= 1000;   % total # of points per interval
P.pause= 0.5;   % time to pause between displaying new iterates [s] {0.5}
% ===========================================================
t= linspace(-1.5*P.tau,1.5*P.tau,3*P.M);  % time array
sawT= repmat(P.A*linspace(-0.5,0.5,P.M),1,3);   % create sawtooth baseline
% --- use a loop to add in the terms
for mm=1:numel(P.order)
    tempN= P.order(mm);
    sawF= 0;    % dummy initial indexer
    for nn= 1:tempN
        nextTerm= (P.A/pi)*(1/nn)*((-1)^(nn+1))*sin(nn*(2*pi/P.tau)*t);  % create next term in series
        sawF= sawF+ nextTerm;
    end
    % --- estimate "overshoot"
    [M,indx]= max(sawF);
    disp(['Overshoot ratio ~',num2str(M/max(sawT))]);
    % --- visualize
    figure(1); clf;
    h1= plot(t,sawT,'b-','LineWidth',2); hold on; grid on; xlabel('x'); ylabel('y'); ylim(0.65*P.A*[-1 1]);
    h2= plot(t,sawF,'r--','LineWidth',2); legend([h1 h2],'sawtooth','Fourier series','Location','NorthWest');
    title(['(truncated) Fourier reconstruction of Sawtooth w/ ',num2str(tempN),' terms']);
    pause(P.pause);
end

