% ### EX2DfourierPhaseSwap.m ###     2015.09.11 CB (updated 2017.01.20)

% Swaps the phasefrom the 2D-FFT between two images and then computes the
% inverse (i.e., the re-image)

% Notes
% o Caution: axes for FFT are not (presently) properly labeled
% o originally called swapFourier.m

clear
% ==========================================================
fileA= './Images/GreekChurch';   % [no need for extension]
fileB= './Images/moustacheB';
mScale= 0;  % boolean re linear (0) or log (1) axes for the magnitude
% ==========================================================
% ---
% load in images
imageA = imread(fileA,'jpg');   % load in an image
imageB = imread(fileB,'jpg'); 
% ---
% if color, convert to B&W
if size(imageA,3)>1
    imageA= rgb2gray(imageA);
    imageB= rgb2gray(imageB);
end
% ---
% compute FFT
fftA = fft2((imageA));
fftB = fft2((imageB));
% places zero-frequency position in center?
if (1==1),  FA= fftshift(fftA); FB= fftshift(fftB); else   FA= fftA;  FB= fftB; end
% ---
% plot originals + 2D FFT
figure(1); clf;
subplot(221); imagesc(imageA); title('Image A'); colorbar;
if mScale==0
    subplot(223); imagesc(abs(FA),[0 100000]); colormap gray; title('Mag.'); colorbar;   % linear axes
else
    subplot(223); imagesc(db(FA)); colormap gray; title('Mag.'); colorbar;  % log axes
end
subplot(224); imagesc(angle(FA),[-pi pi]); colormap gray; title('Phase')
figure(2); clf;
subplot(221); imagesc(imageB); title('Image B'); colorbar;
if mScale==0
    subplot(223); imagesc(abs(FB),[0 100000]); colormap gray; title('Mag.'); colorbar;   % linear axes
else
    subplot(223); imagesc(db(FB)); colormap gray; title('Mag.'); colorbar;  % log axes
end
subplot(224); imagesc(angle(FB),[-pi pi]); colormap gray; title('Phase')
xlabel('Freq. scale incorrect')
% ---
% swap mag and phases from both images
fftC = abs(fftA).*exp(i*angle(fftB));
fftD = abs(fftB).*exp(i*angle(fftA));
imageC = ifft2(fftC);
imageD = ifft2(fftD);
cmin = min(min(abs(imageC)));   cmax = max(max(abs(imageC)));
dmin = min(min(abs(imageD)));   dmax = max(max(abs(imageD)));
% ---
figure(3); clf; hold on;
subplot(221); imagesc(abs(imageC), [cmin cmax]); colormap gray; title('Im.A  Mag. + Im.B Phase')
subplot(223); imagesc(abs(imageD), [dmin dmax]); colormap gray; title('Im.B  Mag. + Im.A Phase')

