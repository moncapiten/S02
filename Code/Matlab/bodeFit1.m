rawData = readmatrix("../Data/bodeData002.txt");

ff = rawData(:, 1);
a = rawData(:, 2);
s_a = repelem(0.1, length(a));
ph = rawData(:, 4);


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

t1 = R1*C1
t2 = R2*C2

A = t1+t2+R1*C2;

tb = 0.5 * ( A + sqrt( A^2 - 4*t1*t2) );
ta = t1*t2/tb;

p0a = [t1, ta, tb]



[betaa, Ra, ~, covbetaa] = nlinfit(ff, a, @ampl, p0);

%beta = nlinfit(ff, a, @tf, p0);


beta






loglog(ff, a, Color= 'cyan');
hold on
loglog(ff, abs( tf(p0, ff)), Color= 'black' );
loglog(ff, abs( tf(beta, ff) ), Color= 'magenta')

grid on
grid minor

hold off

