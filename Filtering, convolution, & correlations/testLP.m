
% initial stab at making a 'low pass' filter

clear
x=linspace(0,10,8192);
y=sinc((x-5)*80);
figure(1); clf;
subplot(211)
plot(x,y); xlabel('time');
subplot(212)
plot(db(rfft(y))); xlabel('pseudo-frequency [bin #]');


% Hartmann
w= linspace(0,10,8192);
tau= 100;
H= 1./(1+i*w*tau);
timeH= irfft(H);
figure(2);
subplot(211)
plot(timeH); xlabel('pseudo-time [bin #]');
subplot(212)
plot(db(H)); xlabel('pseudo-frequency [bin #]');