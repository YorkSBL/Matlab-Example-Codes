% ### makeGrating.m ###     09.14.15 CB

% allows for the creation of a simple 2-D "grating" image

% syntax originally from:
% http://www.icn.ucl.ac.uk/courses/MATLAB-Tutorials/Elliot_Freeman/html/gabor_tutorial.html


% ---------------------------------------------------------------

type= 0;        % boolean to switch between sine (0) and boxcar (1) gratings

imSize = 100;                           % image size: n X n
lamda = 20;                             % wavelength (number of pixels per cycle)
theta = 90;                              % grating orientation [deg]
phase = 0.5;                            % offset phase [cycles]

% ---------------------------------------------------------------


% ======
X = 1:imSize;                           % X is a vector from 1 to imageSize
X0 = (X / imSize) - .5;                 % rescale X -> -.5 to .5
sinX = sin(X0 * 2*pi);                  % convert to radians and do sine
freq = imSize/lamda;                    % compute frequency from wavelength
Xf = X0 * freq * 2*pi;                  % convert X to radians: 0 -> ( 2*pi * frequency)
sinX = sin(Xf) ;                        % make new sinewave
phaseRad = (phase * 2* pi);             % convert to radians: 0 -> 2*pi
sinX = sin( Xf + phaseRad) ;            % make phase-shifted sinewave

% ======
% put the basic grating together
[Xm Ym] = meshgrid(X0, X0);             % 2D matrices
Xf = Xm * freq * 2*pi;
grating = sin( Xf + phaseRad);          % make 2D sinewave

% ======
% deal w/ rotation
thetaRad = (theta / 360) * 2*pi;        % convert theta (orientation) to radians
Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
XYt = [ Xt + Yt ];                      % sum X and Y components
XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
grating = sin( XYf + phaseRad);                   % make 2D sinewave

% ======
% convert to boxcar (i.e., everything is rounded to 0 or 1) if specified
if (type==1),   grating= round((grating+1)/2);    end


% ======
% plot
figure(65); clf;
if type==0
    imagesc(grating, [-1 1] );    colormap gray  
else
    imagesc(grating, [0 1] );    colormap gray 
end
colorbar;

