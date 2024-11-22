filename1 = 'dataPulsed008';
dataposition = '../Data/';

% importing data and manipulation to obtain transfer function
rawdata = readmatrix(strcat(dataposition, filename1, '.txt'));

tt = rawdata(:, 1);
vi = rawdata(:, 2);
vo = rawdata(:, 3);

dt = mean( diff( tt));
fs = 1/dt;
N = length(tt);

Hv = fft(vo)./fft(vi);
Hv = Hv(1:N/2+1);
fv = (0:N/2)*fs/N;


% removing data overly contaminated by noise
thr= 0.6;
Hv(abs(fft(vo))<thr)=NaN;
fv(abs(fft(vo))<thr)=NaN;

% flag to see original signals transform, in case useful
plotPulsed = true;

yi = fftshift( fft(vi) );
yi = yi(N/2, end);
yo = fftshift( fft(vo) );
yo = yo(N/2, end);


% plots

if not(plotPulsed)
    plot(fv, abs(yi), 'o', Color= 'Blue');
    hold on
    %plot(fv, abs(yo), 'v', Color= 'Red');
    grid on
    grid minor
    hold off

end


if plotPulsed
    loglog(fv, abs(Hv), 'o');
    hold on
    grid on
    grid minor
    title('Fourier transform of pulsed measurement');
    ylabel('Amplitude [pure]');
    xlabel('Frequency [Hz]');
    ylim([0.05, 2]);
    dim = [.15 .6 .3 .3];
    str = ['Threshold = ' sprintf('%.2f', thr) ];
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    hold off

end


% image saving
mediaposition = '../Media/';
medianame = 'MisuraImpulsata_CRRC';

%fig = gcf;
%orient(fig, 'landscape')
%print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf');
