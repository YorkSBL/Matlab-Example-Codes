% plot the data shown in Salil5.jpg (as extracted via deplot.m)
clear
A= load('extractedData.txt');
A= A(:,1:2);    % ignore last column
semilogx(A(:,1),A(:,2),'ko','LineWidth',2);
axis([1 50 -185 185]);
xlabel('Frequency [kHz]'); ylabel('Phase [degrees]');
hold on; grid on;