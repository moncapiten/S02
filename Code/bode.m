ff = logspace(-1, 5, 1000);

R1 = 100.28 * 1e3;
R2 = 995.9;
C1 = 109.9 * 1e-9;
C2 = 54.03 * 1e-9;

t1 = R1*C1;
t2 = R2*C2;

A = t1+t2+R1*C2;

tb1 = 0.5 * ( A + sqrt( A^2 - 4*t1*t2) );
ta1 = t1*t2/tb;

tb2 = 0.5 * ( A - sqrt( A^2 - 4*t1*t2) );
ta2 = t1*t2/tb;


function y = tf(w, params)
    
    y = 1i*w*params(1) ./ ( (1+1i*w*params(2)).*(1+1i*w*params(3)) );

end

params1 = [t1, ta1, tb1]
params2 = [t1, ta2, tb2]


%plot(ff, tf(2*pi*ff))
loglog(ff, tf(2*pi*ff, params1), Color= 'red');
hold on
loglog(ff, tf(2*pi*ff, params2), Color = 'blue');
hold off

