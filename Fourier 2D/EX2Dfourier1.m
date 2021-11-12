% ### EX2Dfourier1.m ###     2015.09.15 CB (updated 2017.01.20)

% Read in an image and compute the 2D FFT, plotting both mag and phase; can
% also rotate the image 90

% Notes
% o Caution: axes for FFT are not (presently) properly labeled

% Image files to try (fileA):
% - './Images/circle.black'
% - './Images/moustacheB'
% - './Images/stripes.horizontal'
% - './Images/Bricks'


% Source:basic syntax borrowed from "How to Do a 2-D Fourier Transform in Matlab"
% http://matlabgeeks.com/tips-tutorials/how-to-do-a-2-d-fourier-tr...

clear
% =================================
fileA= './Images/Bricks';   % [no need for extension]
mScale= 1;  % boolean re linear (0) or log (1) axes for the magnitude
rotateI= 0;     % boolean to rotate image CCW 90 deg {0}
flipI= 0;     % boolean to flip image about vertical {0}
invertI= 0;   % boolean to invert image {0} Note: kludge reqs. conversion to double and back {0}
% =================================
% ---
imageA = imread(fileA,'jpg');   % load in an image
% ---
% various possible manipulations
if (size(imageA,3)>1), imageA= rgb2gray(imageA);    end     % if color, convert to B&W
if (rotateI==1), imageA= rot90(imageA);    end     % rotate
if (flipI==1), imageA= fliplr(imageA);    end     % flip
if (invertI==1), imageA= double(imageA); imageA= abs(imageA-max(imageA(:))+1); imageA= uint8(imageA);   end     % invert
% ---
fftA = fft2((imageA));  % compute FFT
% ---
% places zero-frequency position in center?
if (1==1),  FA= fftshift(fftA); else   FA= fftA;  end
% ---
% plot
figure(1); clf;
subplot(221); imagesc(imageA); title('Image');  colorbar; xlabel('Pixel # (x)'); ylabel('Pixel # (y)');
if mScale==0
    subplot(223); imagesc(abs(FA),[0 100000]); colormap gray; title('Mag.'); colorbar;   % linear axes
else
    subplot(223); imagesc(dB(FA)); colormap gray; title('Mag.'); colorbar;  % log axes
end
subplot(224); imagesc(angle(FA),[-pi pi]); colormap gray; title('Phase');  colorbar;
xlabel('Freq. scale incorrect')
% % ---
% % determine correct 2D-FFT axis labels
% a= 1;   % "pixel width"
% n= size(imageA,2);  m= size(imageA,1);  % n number of pixel in x direction, m number of pixel in y direction
% % determine freqs.
%  fx=(1/a)*((-n/2:n/2-1)/n); fy=(1/a)*((-m/2:m/2-1)/m); 
%  set(gca,'XLim',[fx(1) fx(end)]); set(gca,'YLim',[fy(1) fy(end)]);
%  xlabel('w_x'); ylabel('w_y');

