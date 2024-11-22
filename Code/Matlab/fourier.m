filename1 = 'dataFourier001';
filename2 = 'dataFourier002';
dataposition = '../Data/';

% importing data from two different sources

rawdata = readmatrix(strcat(dataposition, filename1, '.txt'));
rawdata2 = readmatrix(strcat(dataposition, filename2, '.txt'));


tt = rawdata(:, 1);
vo = rawdata(:, 3);

dt = mean( diff( tt));
fs = 1/dt;

y = fft(vo);
y = fftshift(y);
f = (0:length(y)/2)*fs/length(y);
y = y(length(y)/2:end);



tt2 = rawdata2(:, 1);
vo2 = rawdata2(:, 3);

dt2 = mean(diff(tt2));
fs2 = 1/dt2;

y2 = fft(vo2);
y2 = fftshift(y2);
f2 = (0:length(y2)/2)*fs2/length(y2);
y2 = y2(length(y2)/2:end);

% plot
plot(f, abs(y));
hold on
plot(f2, abs(y2));
grid on
grid minor

title('Fourier transform of data001 and 002 superimposed');
ylabel('Amplitude');
xlabel('Frequency [Hz]');
legend('data001 - 1MSa/s', 'data002 - 38kSa/s')
xlim([0 2.5e4]);
hold off

% image saving
mediaposition = '../Media/';
medianame = 'aliasing';

fig = gcf;
orient(fig, 'landscape')
print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf');
