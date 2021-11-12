% generates IM1.gif (SoundWave.gif for website)

% side of square contains N dots and spans distance L
L = 1;
N = 25;					% dots/side
Nt = 40;				% frames/cycle

Lam = 0.7;				% wavelength of motion
alpha = 0.017;				% amplitude of motion

% specify distance of square from sound source 
D = 100;				% far away (like a plane wave)
% D = -0.5;				% source in center of square
% D = 0;				% source in lower left

% wave frequency
f = 1;
w = 2*pi*f;

t = detail(linspace(0,1/f,Nt));		% do one cycle
x = linspace(0,L,N);
y = linspace(0,L,N);
[X,Y] = meshgrid(x,y);

XY = hypot(D+X,D+Y);

XY = flipud(XY);			% put 0 in bottom corner
Y = flipud(Y);

KR = 2*pi*XY/Lam;			% k.r

fig=figure;
set(gcf,'Color',[1,1,1]);

% step through time... 
for nt=1:numel(t)
  Xt = X + alpha*cos(-KR+w*t(nt));
  Yt = Y + alpha*cos(-KR+w*t(nt));
  MC = 0.9-0.1*cos(KR+w*t(nt));
  
  % plot each dot (there must be a way to do this without a loop)
  for m=1:N
    for n=1:N
      plot(Xt(m,n),Yt(m,n),'kd','MarkerSize',2);

% Try shading the dots (N.B. not a very pleasing effect)
%      plot(Xt(m,n),Yt(m,n),'kd',...
%	   'MarkerFaceColor',[MC(m,n) MC(m,n) MC(m,n)], ...
%	   'MarkerEdgeColor','k');
      hold on
    end
  end
  axis equal
  colormap([])
  %xaxis(-0.05,1.05);
  %yaxis(-0.05,1.05);
  set(gca,'XColor',[1 1 1],'YColor',[1 1 1]);
  set(gca,'XTick',[],'YTick',[]);
  set(gca,'Box','off');
  IM = frame2im(getframe(gca));
  if (nt==1)
    imwrite(IM(:,:,1),'IM1.gif','GIF','DelayTime',1/12,'LoopCount',Inf,'WriteMode','overwrite');
  else
    imwrite(IM(:,:,1),'IM1.gif','GIF','DelayTime',1/12,'WriteMode','append');
  end
  cla
end

  

