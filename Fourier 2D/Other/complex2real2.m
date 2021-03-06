function [Y,t] = complex2real2(F,x,y)
%Y = complex2real2(F,[t])
%
%Returns the real-valued amplitudes and phases in a structure calcullated
%from the complex-valued vector F having the convention of fft's output.
%This is the inverse of the function 'real2complex'.
%
%Inputs:
%   F        complex-valued vector in the convention of fft's output.
%   t        time vector of size y (default is 1:length(y));

%Outputs:    Structure Y with fields:
%   dc       mean value of y
%   amp      vector of amplitudes (length ceil(length(t)/2))
%   ph       vector of phases (in degrees, cosine phase)
%   nPix     size of original image
%
%SEE ALSO    real2complex2 fft2 ifft2
%
%Example:
%
%t = 0:.01:.99;
%y=t<.5; 
%Y = complex2real(fft(y),t);
%clf;subplot(1,2,1);stem(t,y);
%xlabel('Time (s)');
%subplot(1,2,2);stem(Y.freq,Y.amp);
%xlabel('Frequency (Hz)')

%4/15/09     Written by G.M. Boynton at the University of Washington


%Deal with defaults
if ~exist('x','var') || ~exist('y','var')
    [x,y] = meshgrid(1:size(F,1));
end

%scale factor for zero padding
k = size(F,1)/size(x,1);

%Calculate values based on x
nPix = size(x,2);
wDeg =(max(x(1,:))-min(x(1,:)))*(nPix+1)/nPix;

%DC is first value scaled by nx^2
dc = F(1)/nPix^2;


%fft shift
F = fftshift(F);

dx = x(1,2)-x(1,1);

%'real' amplitudes scale the fft by 2/nx^2
amp = 2*abs(F)/nPix^2;
%'real' phases are reversed (and converted to degrees)
ph = -180*angle(F)/pi;

%Stuff the values in to the fields of Y
Y.dc = dc;
Y.ph = ph; %cosine phase
Y.amp = amp;

tmp = (0:floor(nPix*k/2))/(wDeg*k);
nf = length(tmp);

[wx,wy] = meshgrid(tmp);

sf = sqrt(wx.^2+wy.^2);

Y.sf = zeros(nPix*k,nPix*k);

Y.sf(1:nf,1:nf) = fliplr(flipud(sf));
Y.sf(1:nf,end-nf+1:end) = flipud(sf);
Y.sf(end-nf+1:end,1:nf) = fliplr(sf);
Y.sf(end-nf+1:end,end-nf+1:end) = sf;

ang = 180*atan2(wy,wx)/pi;

Y.angle = zeros(nPix*k,nPix*k);
Y.angle(1:nf,1:nf) = fliplr(flipud(ang));
Y.angle(1:nf,end-nf+1:end) = -flipud(ang);
Y.angle(end-nf+1:end,1:nf) = -fliplr(ang);
Y.angle(end-nf+1:end,end-nf+1:end) = ang;

Y.freq = zeros(1,nPix*k);
Y.freq(1:nf) = -fliplr(tmp);
Y.freq(end-nf+1:end) = tmp;

Y.nPix = nPix;


