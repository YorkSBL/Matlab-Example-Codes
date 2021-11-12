
clear

file= 'circle.white.jpg';

% read in image
im= imread(file);

% convert to greyscale
f = rgb2grayB(im);

% compute FFT
F = fft2(f);

% plot image
figure(1);
imagesc(im)
% plot magnitude of spectrum
figure(2);
Fs= fftshift(F);    % places zero-frequency position in center
FsM= abs(Fs);
%imshow(log(FsM), []);
imagesc(log(FsM));
colorbar
if 1==0
    caxis([10 17])
    xlim([190 260])
    ylim([190 260])
end

% plot center-line slices (only useful for circular symmtry)
figure(3); clf;
offset= 226;
plot(db(FsM(offset,:)))
hold on; grid on;
plot(db(FsM(:,offset)),'r')
legend('Horizontal slice','Vertical slice')


% inverse FFT back to original (though loss of color will affect things)
if 1==0
    figure(4)
    Z= ifft2(F);
    image(abs(Z))
end