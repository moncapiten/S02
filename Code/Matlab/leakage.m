filename1 = 'dataFourier001';
filename2 = 'dataLeakage001';
dataposition = '../Data/';

% importing data from two different sources

rawdata = readmatrix(strcat(dataposition, filename1, '.txt'));
rawdata2 = readmatrix(strcat(dataposition, filename2, '.txt'));


minorlim = 0;
majorlim = 17000;


tt = rawdata(:, 1);
vo = rawdata(:, 3);

dt = mean( diff( tt));
fs = 1/dt;

y = fft(vo);
y = fftshift(y);
f = (0:length(y)/2)*fs/length(y);
y = y(length(y)/2:end);

f3 = [];
y3 = [];

for i = 1:length(y)
    if f(i) > minorlim && f(i)<majorlim
        
        y3 = [y3 y(i)];
        f3 = [f3 f(i)];
    end
end


tt2 = rawdata2(:, 1);
vo2 = rawdata2(:, 3);

dt2 = mean(diff(tt2));
fs2 = 1/dt2;

y2 = fft(vo2);
y2 = fftshift(y2);
f2 = (0:length(y2)/2)*fs2/length(y2);
y2 = y2(length(y2)/2:end);

y4 = [];
f4 = [];

for i = 1:length(y2)
    if f2(i) > minorlim && f2(i)<majorlim
        y4 = [y4 y2(i)];
        f4 = [f4 f2(i)];
    end
end



sum1 = sqrt( sum( abs(y3).^2 ) )
sum2 = sqrt( sum( abs(y4).^2 ) )




% plot
plot(f, abs(y));
hold on
plot(f2, abs(y2));
plot(f3, abs(y3), 'x', Color= 'Green');
plot(f4, abs(y4), 'o', Color= 'Magenta');
hold off
grid on
grid minor

title('Fourier transform of data001 and a leakage measurement superimposed');
ylabel('Amplitude');
xlabel('Frequency [Hz]');
legend('data001 - 1MSa/s', 'leakage measurement - 17MSa/s', 'data001 squared sum points', 'leakage squared sum points')
xlim([0 2.5e4]);



a=sprintf('%.2e', sum1);
b=sprintf('%.2e', sum2);

dim = [.15 .5 .3 .3];
str = ['Squared sum data001 = ' a  newline  'Squared sum leakage  = ' b];
annotation('textbox',dim,'String',str,'FitBoxToText','on');



% image saving
mediaposition = '../Media/';
medianame = 'leakage';

fig = gcf;
orient(fig, 'landscape')
print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf');
