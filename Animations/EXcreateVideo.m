% ### EXcreateVideo.m ###       11.23.16

% simple code to demo how to create a "movie" (saved as .avi) via Matlab
% (borrows elements fromEXcreate3D2.m and code on mathworks.com)


% ===================
% function handle to express a function to plot
f= @(X,Y,k) (1./sqrt(Y.^k)).*exp(-(X.^2)./Y);

% plotting params.
N= 40;              % grid resolution
xB= [-1 1];         % min/max values along x
yB= [0 1];         % min/max values along y
vP= [-62 36];       % view angle (vals. between 0 and 90)

% movies params.
nFrames = 20;       % # of frames
fRate= 10;          % frame rate [Hz]

% ===================

% ---------
% create x and y axes
x= linspace(xB(1),xB(2),N);
y= linspace(yB(1),yB(2),N);
[X,Y]= meshgrid(x,y);  % multi-dimensionlize as required

% -----
% create base figure (and 0th frame of 3-D object)
figure(1); clf; 
set(gcf, 'Color','white')
F= f(X,Y,1); 
surf(F);  axis tight
set(gca, 'nextplot','replacechildren', 'Visible','off');

% -----
% create AVI object
vidObj = VideoWriter('myPeaks3.avi');
vidObj.Quality = 100;
vidObj.FrameRate = fRate;
open(vidObj);

% -----
% create movie (via updating 3-D object)
for k=1:nFrames
   F= f(X,Y,3/k);
   surf(F)
   writeVideo(vidObj, getframe(gca));
end

% -----
%close(gcf)
close(vidObj);

