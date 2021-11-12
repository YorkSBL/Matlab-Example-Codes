% ### EX2Dfourier3.m ###     2017.02.15 CB 

% Creates several "standard" images and compute the 2D FFT, plotting both mag and phase

% Notes
% o Caution: axes for FFT are not (presently) properly labeled


% Source:basic syntax borrowed from "How to Do a 2-D Fourier Transform in Matlab"
% http://matlabgeeks.com/tips-tutorials/how-to-do-a-2-d-fourier-tr...

clear
% =================================
N= 400;     % # of "pixels" per edge (total image size is NxN) {400}
mScale= 1;  % boolean re linear (0) or log (1) axes for the magnitude
rotateI= 0;     % boolean to rotate image CCW 90 deg {0}
flipI= 0;     % boolean to flip image about vertical {0}
invertI= 0;   % boolean to invert image {0} Note: kludge reqs. conversion to double and back {0}
sigN= 10;     % controls width of "narrow" Gaussian {10}
sigW= 200;     % controls width of "wide" Gaussian {200}
% =================================
% -- bookeeping to create Gaussians
x=linspace(1,N); y=x;
[X,Y]=meshgrid(x,y);
xc= round(N/4); yc= round(N/4); % allows shift to center (can be changed to create offset)
% --- 
imageA= randn(N,N);     % noise image
imageB= (1/sqrt(2*pi)).*exp(-((X-xc).^2/sigN^2)-((Y-xc).^2/sigN^2));    % narrow Gaussian
imageC= (1/sqrt(2*pi)).*exp(-((X-xc).^2/sigW^2)-((Y-xc).^2/sigW^2));    % wide Gaussian
% --- invert?
if (invertI==1), 
    imageA= double(imageA); imageA= abs(imageA-max(imageA(:))+1); imageA= uint8(imageA);   
    imageB= double(imageB); imageA= abs(imageB-max(imageB(:))+1); imageB= uint8(imageB); 
    imageC= double(imageC); imageC= abs(imageC-max(imageC(:))+1); imageC= uint8(imageC); 
end     
% --- compute FFT
fftA = fft2((imageA));  fftB = fft2((imageB));  fftC = fft2((imageC));
% --- places zero-frequency position in center?
if (1==1) 
    FA= fftshift(fftA); FB= fftshift(fftB); FC= fftshift(fftC); 
else   FA= fftA;    FB= fftB;   FC= fftC;  end
% --- plot
figure(1); clf; colormap jet;
subplot(221); imagesc(imageA); title('Image');  colorbar; xlabel('Pixel # (x)'); ylabel('Pixel # (y)');
if mScale==0
    subplot(223); imagesc(abs(FA),[0 100000]); title('Mag.'); colorbar;   % linear axes
else
    subplot(223); imagesc(dB(FA)); colormap gray; title('Mag.'); colorbar;  % log axes
end
subplot(224); imagesc(angle(FA),[-pi pi]); title('Phase');  colorbar;
xlabel('Freq. scale incorrect')
% ---
figure(2); clf; colormap jet;
subplot(221); imagesc(imageB); title('Image');  colorbar; xlabel('Pixel # (x)'); ylabel('Pixel # (y)');
if mScale==0
    subplot(223); imagesc(abs(FB),[0 100000]); title('Mag.'); colorbar;   % linear axes
else
    subplot(223); imagesc(dB(FB)); colormap gray; title('Mag.'); colorbar;  % log axes
end
subplot(224); imagesc(angle(FB),[-pi pi]); title('Phase');  colorbar;
xlabel('Freq. scale incorrect')
% ---
figure(3); clf; colormap jet;
subplot(221); imagesc(imageC); title('Image');  colorbar; xlabel('Pixel # (x)'); ylabel('Pixel # (y)');
if mScale==0
    subplot(223); imagesc(abs(FC),[0 100000]); title('Mag.'); colorbar;   % linear axes
else
    subplot(223); imagesc(dB(FC)); colormap gray; title('Mag.'); colorbar;  % log axes
end
subplot(224); imagesc(angle(FC),[-pi pi]); title('Phase');  colorbar;
xlabel('Freq. scale incorrect')

