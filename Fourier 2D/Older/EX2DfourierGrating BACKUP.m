% ### EX2DfourierGrating.m ###     2013.09.15 CB (updated 2017.01.20)

% Creates a "grating" image (user can specify various parameters
% prescribing such) and compute/plot the 2D FFT; also makes a secondary
% plot where redundant info of the 2D-FFT is ignored (that part of the code
% might need some further tweaking)

% Notes
% o Caution: axes for FFT are not (presently) properly labeled
% o originally called gratingFourier.m
% o fairly kludge hack re grating generation

% modified from original source code:
% http://matlabgeeks.com/tips-tutorials/how-to-do-a-2-d-fourier-tr...
% http://www.icn.ucl.ac.uk/courses/MATLAB-Tutorials/Elliot_Freeman/html/gabor_tutorial.html

clear
% ==========================================================
type= 0;            % boolean to switch between sine (0) and boxcar (1) gratings
imSize = 400;       % image size: n X n {200}
lamda = 25.9;         % wavelength (number of pixels per cycle) {20}
theta = -15;         % grating orientation [deg] {-140}
phase = 0;          % offset phase [cycles] {0}
mScale= 1;          % boolean re linear (0) or log (1) axes for the magnitude {1}
axisS= 0;           % boolean re plotting subset of spectral space in Fig.2 {0}
% ==========================================================
% ---
% make the grating
X = 1:imSize;                           % X is a vector from 1 to imageSize
X0 = (X / imSize) - .5;                 % rescale X -> -.5 to .5
sinX = sin(X0 * 2*pi);                  % convert to radians and do sine
freq = imSize/lamda;                    % compute frequency from wavelength
Xf = X0 * freq * 2*pi;                  % convert X to radians: 0 -> ( 2*pi * frequency)
sinX = sin(Xf) ;                        % make new sinewave
phaseRad = (phase * 2* pi);             % convert to radians: 0 -> 2*pi
sinX = sin( Xf + phaseRad) ;            % make phase-shifted sinewave
% now put the basic grating together
[Xm Ym] = meshgrid(X0, X0);             % 2D matrices
Xf = Xm * freq * 2*pi;
grating = sin( Xf + phaseRad);          % make 2D sinewave
% ---
% deal w/ rotation
thetaRad = (theta / 360) * 2*pi;        % convert theta (orientation) to radians
Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
XYt = [ Xt + Yt ];                      % sum X and Y components
XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
grating = sin( XYf + phaseRad);                   % make 2D sinewave
% ---
% convert to boxcar (i.e., everything is rounded to 0 or 1) if specified
if (type==1),   grating= round((grating+1)/2);    end
imageA= grating;
% ---
fftA = fft2((imageA));  % compute FFT
% places zero-frequency position in center?
if (1==1),  FA= fftshift(fftA); else   FA= fftA;  end
% ---
figure(1); clf;
subplot(221); imagesc(imageA); title('Image A');  colorbar;
if mScale==0
    subplot(223); imagesc(abs(FA),[0 100000]); colormap gray; title('Mag.'); colorbar;   % linear axes
else
    subplot(223); imagesc(db(FA)); colormap gray; title('Mag.'); colorbar;  % log axes
end
subplot(224); imagesc(angle(FA),[-pi pi]); colormap gray; title('Phase');  colorbar;
xlabel('Freq. scale incorrect')

% ---
% make another plot ignoring redundant info; separating that info is
% handled here in a bit of a kludge way
if axisS==1
    specU= fftshift(fftA,1);        %use fftshift to better line up relevant bit
    specU= specU(:,1:ceil(end/2));  % ignore redundant info
    specU= rot90(specU); specU= fliplr(specU);   % rotate/flip to correctly(?) line things up
    figure(2); clf;
    specU= padarray(specU,[5 5],'both');    % pad some zeros around so to better see on-axis values
    subplot(211); imagesc(dB(specU)); colormap jet; colorbar; title('Magnitude');
    xlabel('y');  ylabel('x (axis label is wrongly flipped)'); title('Coords rotated 90 deg');
    subplot(212); imagesc(angle(specU)); colormap jet; colorbar; title('Phase');
    xlabel('y (freq. scale incorrect)'); ylabel('x');
end
