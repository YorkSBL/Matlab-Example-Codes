% ### EXsquareW.m ###    2017.02.19 C.Bergevin

% Visually demonstrate the build-up of a square wave 
% by adding successive (user-specified) terms of the Fourier series
% expansion; also quantifies the Gibbs phenomonon

% Notes
% o Ref: https://en.wikipedia.org/wiki/Square_wave
% o slightly kludgy way that the baseline square wave (squareT) is constructed


clear
% ===========================================================
P.order= [1 2 4 8 15 25 100 500];   % array of # of terms to compute {[1 2 4 8 15 25 100 500]}
P.tau= 1;   % period {1}
P.A= 1;     % peak-to-peak amplitude {1}
P.M= 10000;   % total # of points per interval (must be even?) {1000}
P.pause= 0.5;   % time to pause between displaying new iterates [s] {0.5}
% ===========================================================
t= linspace(-1.5*P.tau,1.5*P.tau,3*P.M);  % time array
squareT= repmat(P.A*([zeros(P.M/2,1);ones(P.M/2,1)]-0.5),3,1)';   % create sawtooth baseline
% --- use a loop to add in the terms
for mm=1:numel(P.order)
    tempN= P.order(mm);
    squareF= 0;    % dummy initial indexer
    for nn= 1:tempN
        pause(1)
        %nextTerm= (P.A/pi)*(1/nn)*((-1)^(nn+1))*sin(nn*(2*pi/P.tau)*t);  % create next term in series
        nextTerm= (2*P.A/pi)*(1/(2*nn-1))*sin((2*nn-1)*(2*pi/P.tau)*t);  % create next term in series
        squareF= squareF+ nextTerm;
    end
    % --- estimate "overshoot"
    [M,indx]= max(squareF);
    disp(['Overshoot ratio ~',num2str(M/max(squareT))]);
    % --- visualize
    figure(1); clf;
    h1= plot(t,squareT,'b-','LineWidth',2); hold on; grid on; xlabel('x'); ylabel('y'); ylim(0.65*P.A*[-1 1]);
    h2= plot(t,squareF,'r--','LineWidth',2); legend([h1 h2],'square','Fourier series','Location','NorthWest');
    title(['(truncated) Fourier reconstruction of square wave w/ ',num2str(tempN),' terms']);
    pause(P.pause);
end

