filename = 'data006';

dataposition = '../Data/';
%rawdata = readmatrix("../Data/data001.txt");
rawdata = readmatrix(strcat(dataposition, filename, '.txt'));

tt = rawdata(:, 1);
vi = rawdata(:, 2);
vo = rawdata(:, 3);


plot(tt, vi, Color = 'Blue');
hold on
grid on
grid minor
plot(tt, vo, Color= 'Red');

plot(linspace(tt(1), tt(length(tt)), 100), repelem(0, 100), Color= 'Black');
xlim([tt(1), tt(length(tt))])
ylim([-2.5, 2.5])

title('Plot of Measurements - 50kHz Square Wave')
xlabel('time [s]');
ylabel('Voltage [V]');
legend('Vin', 'Vout');
hold off

mediaposition = '../Media/';

fig = gcf;
orient(fig, 'landscape')
print(fig, strcat(mediaposition, filename, '.pdf'), '-dpdf');
%print(fig,'./Media/dataPlot001.pdf','-dpdf')
%saveas(fig, strcat(position, filename), 'svg');
%saveas(fig, './Media/dataPlot', 'svg');
