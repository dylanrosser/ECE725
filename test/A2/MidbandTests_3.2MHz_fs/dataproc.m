dat = readtable('sanitycheck.csv');
t = dat.(1);
y = dat.(2);

f = 1e3; w = 2*pi*f;
A = 1050/2;
Off = A;
phase = -70*pi/180;

params_guess = [A; phase; Off];
mod = @(params, t) params(1).*cos(w.*t + params(2)) + params(3);
fcn = @(params) (sum(abs(mod(params, t) - y))).^2;
params_fit = fminsearch(fcn, params_guess);

plot(t, y, t, mod(params_fit, t))
title('Sine Fit')
figure

Vfs = 0.82; % measured
Vampl = 0.5*0.9;
Vwave = Vampl*cos(w*t + params_fit(2)) + Vampl;
% Normalize
Vwave_norm = Vwave*1024/Vfs;

plot(t, y, t, Vwave_norm)
xlabel('Time')
ylabel('Output')
title('ADC Output vs. Projected ADC output for 900 mVpp Input 1kHz Sine Wave')

figure
plot(Vwave, y, 'x')
xlabel('Input Diff Voltage')
ylabel('Code');
title('ADC Low Freq. Transfer Characteristic (FS = 3.2 MHz)')
