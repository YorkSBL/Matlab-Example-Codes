% ### EX2DfourierBlur.m ###     2015.29.11 CB (updated 2017.01.20)

% By creating a "blurring" impulse response, the purpose is to perform a 
% convolution (in the spectral domain, i.e., via a multiplication) to blur
% an image

% Notes
% o Caution: axes for FFT are not (presently) properly labeled
% o originally called SpectralBlur.m

clear
% ==========================================================
fileA= './Images/HRfig12x6';   % [no need for extension]
mScale= 0;  % boolean re linear (0) or log (1) axes for the magnitude
sigma= 10;  % width for blurring kernel
% ==========================================================
% ---
imageA = imread(fileA,'jpg');   % load in an image
% ---
% if color, convert to B&W
if (size(imageA,3)>1),  imageA= rgb2gray(imageA);   end
% ---
fftA = fft2((imageA));  % compute FFT
% ---
% create (spectral) impulse response
[dimx dimy]= size(imageA);  % get the correct dimensions
[X,Y]=meshgrid(1:dimx,1:dimy);      % create baseline mesh
impulse= (1000/sqrt(2*pi).*exp(-((X-dimx/2).^2/(2*sigma^2))-((Y-dimy/2).^2/(2*sigma^2))));
impulse= impulse/(max(max(impulse)));    % normalize to unity
filter= fft2((impulse));    % convert to spectral domain
% ---
% convolve by multiplying in the freq. domain
blurredS= fftA.*filter;
% ---
% inverse transform back
imageF= ifft2(blurredS, 'symmetric');
imageF= fftshift(imageF);   % Kludge (need to reshift; unsure why...)
% ---
% places zero-frequency position in center?
if (1==1),  FA= fftshift(filter); else   FA= filter;  end
% ---
% plot
figure(1); clf;
subplot(221); imagesc(imageA); title('Image A');  colorbar; % original
subplot(222); imagesc(imageF); title('Convolved version');  colorbar;
subplot(223); imagesc(impulse); colormap gray; title('PSF (spatial)');  colorbar;
if mScale==0
    subplot(224); imagesc(abs(FA));  title('PSF (spectral; mag.)'); colorbar;   % linear axes
else
    subplot(224); imagesc(db(FA)); title('PSF (spectral; mag.)'); colorbar;  % log axes
end
xlabel('Freq. scale incorrect')