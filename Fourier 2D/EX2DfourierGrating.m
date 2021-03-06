% ### EX2DfourierGrating.m ###     2013.09.15 CB (updated 2017.01.26)

% Creates a "grating" image (user can specify various parameters
% prescribing such) and compute/plot the 2D FFT; also makes a secondary
% plot where redundant info of the 2D-FFT is ignored (that part of the code
% might need some further tweaking)

% Notes
% o reqs. external (custom CB) code EXmakeGrating.m
% o theta= 0 means "wavefront" goes left to right (i.e., along x);
% o Caution: axes for FFT are not (presently) properly labeled
% o originally called gratingFourier.m
% o fairly kludge hack re grating generation
% o for quantizing, the length used is


% modified from original source code:
% http://matlabgeeks.com/tips-tutorials/how-to-do-a-2-d-fourier-tr...
% http://www.icn.ucl.ac.uk/courses/MATLAB-Tutorials/Elliot_Freeman/html/gabor_tutorial.html

clear
% ==========================================================
P.lamda = 20;         % wavelength (number of pixels per cycle) {20}
P.theta = 25;         % grating orientation [deg] {-140}
P.phase = 0.0;          % offset phase [cycles] {0}
% ---
P.imSize = 400;       % image size: n X n {200}
P.quantize= 0;        % boolean re quantizing the wavelength so an integral # of periods fit {1}
P.axisS= 0;           % boolean re plotting subset of spectral space in Fig.2 {0}
P.mScale= 1;          % boolean re linear (0) or log (1) axes for the magnitude {1}
P.type= 0;            % boolean to switch between sine (0) and boxcar (1) gratings
% ==========================================================
% ---
imageA= EXmakeGrating(P);   % use external (CB) code to create grating
% ---
fftA = fft2((imageA));  % compute FFT
% places zero-frequency position in center?
if (1==1),  FA= fftshift(fftA); else   FA= fftA;  end
% ---
figure(1); clf;
subplot(221); imagesc(imageA); title('Image A');  colorbar;
if P.mScale==0
    subplot(223); imagesc(abs(FA),[0 100000]); colormap gray; title('Mag.'); h1= colorbar;   % linear axes
    h1.Label.String = 'Linear scale';
else
    subplot(223); imagesc(db(FA)); colormap gray; title('Mag.'); h1= colorbar;  % log axes
    h1.Label.String = 'dB scale';
end
subplot(224); imagesc(angle(FA),[-pi pi]); colormap gray; title('Phase');  colorbar;
xlabel('Freq. scale incorrect')

% ---
% make another plot ignoring redundant info; separating that info is
% handled here in a bit of a kludge way
if P.axisS==1
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
