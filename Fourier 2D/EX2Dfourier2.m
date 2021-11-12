% ### EX2Dfourier2.m ###     2017.01.20 CB

% Variation on EX2Dfourier1.m to draw attention to role that fftshift.m plays
% and the redundant information that is displayed (due to symmetry, given
% that the image is real-valued)

% Notes
% o Caution: axes for FFT are not (presently) properly labeled
% o This code only plots the mag. on a dB scale (unlike EX2Dfourier1 where
% there is an option)

% Image files to try (fileA):
% - './Images/circle.black'
% - './Images/moustacheB'
% - './Images/stripes.horizontal'


% Source:basic syntax borrowed from "How to Do a 2-D Fourier Transform in Matlab"
% http://matlabgeeks.com/tips-tutorials/how-to-do-a-2-d-fourier-tr...

clear
% =================================
fileA= './Images/moustacheB';   % [no need for extension]
mScale= 1;  % boolean re linear (0) or log (1) axes for the magnitude
rotateI= 0;     % boolean to rotate image CCW 90 deg {0}
flipI= 0;     % boolean to flip image about vertical {0}
% =================================
% ---
imageA = imread(fileA,'jpg');   % load in an image
% ---
% various possible manipulations
if (size(imageA,3)>1), imageA= rgb2gray(imageA);    end     % if color, convert to B&W
if (rotateI==1), imageA= rot90(imageA);    end     % rotate
if (flipI==1), imageA= fliplr(imageA);    end     % flip
% ---
fftA = fft2((imageA));  % compute FFT
% ---
fftB= fftshift(fftA); % places zero-frequency position in center?
% ---
% plot
fig1= figure(1); clf;
subplot(221); imagesc(imageA); title('Image');  colorbar; xlabel('Pixel # (x)'); ylabel('Pixel # (y)');
subplot(223); imagesc(dB(fftA)); colormap gray; title('Mag. (No shift)'); colorbar;  % log axes
subplot(224); imagesc(dB(fftB)); colormap gray; title('Mag. (Shifted)'); colorbar;  % log axes
xlabel('Freq. scale incorrect')
% ---
% make another plot ignoring redundant info; separating that info is
% handled here in a bit of a kludge way
specU= fftshift(fftA,1);        %use fftshift to better line up relevant bit
specU= specU(:,1:ceil(end/2));  % ignore redundant info
specU= rot90(specU); specU= fliplr(specU);   % rotate/flip to correctly(?) line things up
figure(2); clf;
subplot(211); imagesc(dB(specU)); colormap(jet); colorbar; title('Magnitude');
subplot(212); imagesc(angle(specU)); colormap(jet); colorbar; title('Phase'); xlabel('Freq. scale incorrect')
% ---
% print some info to screen
if 1==0
    disp(['For the "shifted" version (via fftshift.m),','the zero frequncy appears in the center.'])
    disp(['For the non-shifted version, positive','frequncies start at 0 in the bottom left'])
    disp(['corner and increase as you move','right (x) and up (y). Note that half the info']);
    disp(['here is redundant though.']);
end
