ff = logspace(-2, 6, 1000);

R1 = 100.28 * 1e3;
R2 = 995.9;
C1 = 109.9 * 1e-9;
C2 = 54.03 * 1e-9;

t1 = R1*C1;
t2 = R2*C2;

A = t1+t2+R1*C2;

tb1 = 0.5 * ( A + sqrt( A^2 - 4*t1*t2) );
ta1 = t1*t2/tb1;

tb2 = 0.5 * ( A - sqrt( A^2 - 4*t1*t2) );
ta2 = t1*t2/tb1;


function y = tf(w, params)
    
    y = 1i*w*params(1) ./ ( (1+1i*w*params(2)).*(1+1i*w*params(3)) );

end

params1 = [t1, ta1, tb1];
params2 = [t1, ta2, tb2];


%plot(ff, tf(2*pi*ff))
loglog(ff, abs(tf(2*pi*ff, params1)), Color= 'red');
hold on
grid on
grid minor
loglog(ff, abs(tf(2*pi*ff, params2)), Color = 'blue');
legend('Positive root', 'Negative root');
xlabel("f [Hz]");
ylabel('Gain')
hold off

%fig = gcf;
%orient(fig, 'landscape')
%print(fig,'../Media/gainPlotPure.pdf','-dpdf')
%saveas(fig, '../Media/gainPlotPure', 'svg');

%{
ff = logspace(-1, 5, 1000);

semilogx(ff, 20*log10(tf(2*pi*ff, params1)), Color= 'red');
hold on
grid on
grid minor
%semilogx(ff, 20*log10(tf(2*pi*ff, params2)), Color = 'blue');
legend('Positive root', 'Negative root');
xlabel("f [Hz]");
ylabel('Gain [dB]')
hold off

fig = gcf;
orient(fig, 'landscape')
print(fig,'../Media/gainPlotdB.pdf','-dpdf')
saveas(fig, '../Media/gainPlotdB', 'svg');


%}