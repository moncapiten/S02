% data import and creation of variance array
rawData = readmatrix("../Data/bodeData002.txt");

ff = rawData(:, 1);
a = rawData(:, 2);
s_a = repelem(5e-4, length(a));
ph = rawData(:, 4);

% preparation of fitting function and p0 parameters
function y = tf(params, f)

    w = 2*pi.*f;
    y = 1i*w*params(1) ./ ( (1+1i*w*params(2)) .* (1+1i*w*params(3)) );

end

function y = ampl(params, f)
    
    y = abs(tf(params, f));

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

p0a = [t1, ta, tb];

% fit and k^2 calculation
[betaa, Ra, ~, covbetaa] = nlinfit(ff, a, @ampl, p0a);
betaa
covbetaa


ka = 0;
for i = 1:length(Ra)
    ka = ka + Ra(i)^2/s_a(i)^2;
end
ka = ka/(length(ff)-3);
ka


% plot seffing and execution
t = tiledlayout(2, 1);

% plot of the data, prefit and fit
ax1 = nexttile([1 1]);

errorbar(ff, a, s_a, 'o', Color= '#0072BD');
set(gca, 'XScale','log', 'YScale','log')
hold on
loglog(ff, ampl(p0a, ff), '--', Color= 'black');
loglog(ff, ampl(betaa, ff), '-', Color= 'red');
hold off
grid on
grid minor


% residual plots for both fits
ax2 = nexttile;
plot(ff, repelem(0, 100), '--', Color= 'black');
hold on
errorbar(ff, Ra, s_a, Color= '#0072BD');
set(gca, 'XScale','log', 'YScale','lin')
hold off
grid on
grid minor


% plot seffings
title(t, 'Fit and residuals of Amplitude Fit');
t.TileSpacing = "tight";
linkaxes([ax1, ax2], 'x');


%xlabel(ax1, 'frequency [Hz]')
ylabel(ax1, 'Gain [pure]')
legend(ax1, 'data', 'model - p0', 'model - fitted', Location= 'ne')
dim = [.15 .6 .3 .3];
str = ['$ k^2 $ = ' sprintf('%.2f', ka) ];
annotation('textbox', dim, 'interpreter','latex','String',str,'FitBoxToText','on');


xlabel(ax2, 'frequency [Hz]');
ylabel(ax2, 'Amplitude - Residuals [V]');


% image saving
mediaposition = '../Media/';
medianame = 'Misura_CRRC';

%fig = gcf;
%orient(fig, 'landscape')
%print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf');
