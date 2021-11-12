% ### makeLatticeFT.m ###     11.15.13

% [NOTE: previously called explore2DFT.m]

% Note: this code allows for a somewhat generalizable lattice to be
% created; a simple square lattice can be created via repmat (but different
% lattice types require a bit more)

% NOTE: Reference here dimensional specifications is upper right corner
% (since this is the default indexing scheme for arrays in Matlab)

clear

% ----------------------

% total edge length of lattice (assumed to be a square)
N= 52;

% offset values for unit cell placement within a single lattice array
% (relative to upper right, *NOT* lower right!)
Hoff= 0;    
Voff= 0;

% specifies dimensions of single lattice array
% (these numbers should likely be larger than the unit cell dimensions)
% [Note: To see just the unit cell alone, make these numbers bigger than N]
Hspace= 25;  
Vspace= 25;

% horizontal shift for adjacent horizontal rows
Hshift= 0;

% specify unit cell (to be embedded in single lattice element)
unit= [0 1 0;
    1 2 1;
    0 1 0];

% ----------------------

% reality check #1
if Hoff+1>Hspace || Voff+1>Hspace
    disp(sprintf('Error in dimensional specification; unit cell offset exceeds lattice spacing'));
    return
end
    
% create single lattice element based off of unit cell and specified parameters
LattUnit= zeros(Hspace,Vspace);     % create foundation
LattUnit(1+Hoff:Hoff+size(unit,1),1+Voff:Hoff+size(unit,2))= unit;


% ---------
% now repeat along horizontal dimension
% [note this will be larger than required (hence +1), but this is somewhat by design
% for creating the vertical tiling by avoiding requiring a periodic boundary condition, 
% and ultimately the array will be cropped to the correcet dimensions]
repH= ceil(N/Hspace);  % generate first row 

FirstRowA= repmat(LattUnit,1,repH+1);     % includes extra lattice points (
previous= FirstRowA(:,1:N);            % 'cropped' version


% ---------
% now generate additional rows (vertically heading upwards) via a nested
% loop
repV= ceil(N/Vspace); 
for nn=1:repV+1
    clear NextRow;
    element= FirstRowA(:,1+Hshift*nn:Hspace+Hshift*nn);
    NextRow= repmat(element,1,repH+1);
    Lattice= [previous; NextRow(:,1:N)];
    previous= Lattice;  % reset for loop
end

% crop lattice to appropriate dimensions
Lattice= Lattice(1:N,1:N);

% ---------
% visualize lattice
figure(1); clf;
imagesc(Lattice);
colormap(gray);
xlabel('Horizontal Position (pixel #)')
ylabel('Vertical Position (pixel #)')
title('Lattice (spatial domain)')
colorbar

% ---------
% visualize Fourier transform of lattice
figure(2); clf;
F = fft2(Lattice);
Fs= fftshift(F);    % places zero-frequency position in center
FsM= abs(Fs);
imagesc((FsM));
%colormap(gray);
colorbar
title('2D FFT of Lattice (frequency domain), i.e., Reciprocal Lattice')