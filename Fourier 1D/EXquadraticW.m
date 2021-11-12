% ### EXquadraticW.m ###    2017.02.19 C.Bergevin

% Visually demonstrate the build-up of a "quadratic wave" (centered about t=0)
% i.e., x(t)= t^2
% by adding successive (user-specified) terms of the Fourier series
% expansion; also quantify the Gibbs phenomonon

% Notes
% o Fourier series expansion (red dashed line) only valid over interval
% t=[-pi,pi] (as apparent re periodic B.C.)
% o Ref: https://www3.nd.edu/~craicu/54Fall10/quizzes/q12.pdf and
% http://quantum.phys.unm.edu/E02087.pdf

clear
% ===========================================================
P.order= [1 2 4 8 15 25 100 500];   % array of # of terms to compute {[1 2 4 8 15 25 100 500]}
P.M= 1000;   % total # of points per interval
P.pause= 0.5;   % time to pause between displaying new iterates [s] {0.5}
P.xR= 5;        % max. value for t {8}
% ===========================================================
t= linspace(-P.xR,P.xR,P.M);  % time array
quadraticW= t.^2;    
% --- use a loop to add in the terms
for mm=1:numel(P.order)
    tempN= P.order(mm);
    QW= (pi^2/3);    % dummy initial indexer (DC term)
    for nn= 1:tempN
        nextTerm= (4/nn^2)*((-1)^(nn))*cos(nn*t);  % create next term in series
        QW= QW+ nextTerm;
    end
    % --- estimate "overshoot"
    [M,indx]= max(QW);
    disp(['Overshoot ratio ~',num2str(M/max(quadraticW))]);
    % --- visualize
    figure(1); clf;
    h1= plot(t,quadraticW,'b-','LineWidth',2); hold on; grid on; xlabel('x'); ylabel('y'); 
    h2= plot(t,QW,'r--','LineWidth',3); legend([h1 h2],'sawtooth','Fourier series','Location','North');
    title(['(truncated) Fourier reconstruction of Sawtooth w/ ',num2str(tempN),' terms']);
    axis([1.1*min(t) 1.1*max(t) -2 1.1*max(quadraticW)])
    pause(P.pause);
end

