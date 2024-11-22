% data import

filename = 'tcurve';
dataposition = '../Data/';

rawdata = readmatrix(strcat(dataposition, filename, '.txt'));

ff = rawdata(:, 1);
Av = rawdata(:, 2);
Pv = rawdata(:, 3);


% data manipulation( going from decibels and degress to pure numbers and
% radians

Av = Av/20;
Av = 10.^Av;

deg2rad = pi/180;
Pv = Pv.*deg2rad;


% simulation of the transfer function

function y = tf(params, f)

    w = 2*pi.*f;
    y = 1i*w*params(1) ./ ( (1+1i*w*params(2)) .* (1+1i*w*params(3)) );

end

function y = ampl(params, f)
    
    y = abs(tf(params, f));

end

function y = phase(params, f)
    
    y = angle(tf(params, f));

end

R1 = 100.28 * 1e3;
R2 = 995.9;
C1 = 109.9 * 1e-9;
C2 = 54.03 * 1e-9;

t1 = R1*C1;
t2 = R2*C2;

A = t1+t2+R1*C2;

tb = 0.5 * ( A + sqrt( A^2 - 4*t1*t2) );
ta = t1*t2/tb;

p0 = [t1, ta, tb];


% plot
t = tiledlayout(2, 1);

% gain plot
ax1 = nexttile;

loglog(ff, Av, 'o', Color = 'Blue');
hold on
grid on
grid minor
loglog(ff, ampl(p0, ff), Color = 'Red');


% phase plot
ax2 = nexttile;

semilogx(ff, Pv, 'o', Color= 'Blue');
hold on
semilogx(ff, phase(p0, ff), Color= 'Red');
grid on
grid minor
hold off


% plot settings
title(t, 'Plot of Tina-Ti and Matlab simulation data superimposed');
title(ax1, 'Gain plot');
title(ax2, 'Phase Plot');
t.TileSpacing = "tight";
linkaxes([ax1, ax2], 'x');


xlabel(ax2, 'Frequency [Hz]');
ylabel(ax1, 'Gain [Pure]');
ylabel(ax2, 'Phase [radians]');
yticks(ax2, [-pi/2 -pi/4 0 pi/4, pi/2])
yticklabels(ax2, {'-\pi/2', '-\pi/4', '0', '\pi/4', '\pi/2'})
legend(ax1, 'Tina-TI  simulation', 'Matlab simulation', Location= 'ne');


%title('Mathematical simulation superimposed on Tina-TI simulation')


% image saving

mediaposition = '../Media/';
medianame = ' Simulazioni CRRC';

fig = gcf;
orient(fig, 'landscape')
print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf');
