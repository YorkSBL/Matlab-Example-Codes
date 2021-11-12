% ### EX2DfourierHPfilter.m ###     2015.09.21 CB (updated 2017.01.20)

% purpose of this code is perform a high-pass filtering of an image, akin
% to what is shown in Fig.12.6 of Hobbie & Roth (4th Ed.)

% Notes
% o Caution: axes for FFT are not (presently) properly labeled
% o originally called HRfig12x6.m

clear
% ==========================================================
fileA= './Images/HRfig12x6';   % [no need for extension]
mScale= 0;  % boolean re linear (0) or log (1) axes for the magnitude
L= 15;      % filter length for hi-pass
% ==========================================================
% ---
imageA = imread(fileA,'jpg');   % load in an image
% ---
% if color, convert to B&W
if (size(imageA,3)>1),  imageA= rgb2gray(imageA);   end
% ---
fftA = fft2((imageA));  % compute FFT
% ---
% create a high-pass filter "mask" and apply (kludgy; likely better bookkeeping possible)
fftA(1:L,1:L)= 0;
fftA(1:L,end-L:end)= 0;
fftA(end-L:end,1:L)= 0;
fftA(end-L:end,end-L:end)= 0;
% ---
imageF= ifft2(fftA, 'symmetric');       % inverse FFT
% place zero-frequency position in center?
if (1==1),  FA= fftshift(fftA); else   FA= fftA;  end
% ---
% plot original
figure(1); clf;
subplot(221); imagesc(imageA); title('Image A');  colorbar;
if mScale==0
    subplot(223); imagesc(abs(FA),[0 100000]); colormap gray; title('Mag.'); colorbar;   % linear axes
else
    subplot(223); imagesc(db(FA)); colormap gray; title('Mag.'); colorbar;  % log axes
end
subplot(224); imagesc(angle(FA),[-pi pi]); colormap gray; title('Phase');  colorbar;
xlabel('Freq. scale incorrect')
subplot(222); imagesc(imageF); title('Hi-pass filtered version');  colorbar;
