MSB = VDIFFm30mV.MSB;
Times = VDIFFm30mV.Times;
T = 1./(250e3);
toffset = 0.1*T;
Taxis_interp = 0:T:Times(end);
Taxis_interp2 = 0:-T:Times(1);
Taxis_interp2 = Taxis_interp2(2:end);

Taxis_interp = Taxis_interp + toffset;
Taxis_interp2 = Taxis_interp2 + toffset;

res1 = interp1(Times, MSB, Taxis_interp);
res2 = interp1(Times, MSB, Taxis_interp2);

N = length(res1) + length(res2)
P = (sum(res1) + sum(res2))/N

VDIFF = [-100 -50 -40 -30 -20 -16 -10 -6 -2 0 2 6 10 16 18 20 30 40 50 60 70 80 90 100 110 120 130 140 200]; % mV
P = [0 0 0.0024 0.9707 0.9829 0.9902 0.9890 0.9896 0.9902 0.9768 0.9646 0.8963 0.9878 0.9884 0.9829 0.9902 0.9811 0.9847 0.9902 0.9878 0.9933 0.9896 0.9597 0.9902 0.9793 0.9976 1 1 1];

% New data

VDIFF = -40:-30;
P = [0.0026 0.0013 0.032 0.3764 0.3622 0.079 0.1028 0.6898 0.3231 0.1895 0.5003];
plot(VDIFF, P, 'LineWidth', 2)
xlabel('VDIFF (mV)')
ylabel('Probability of 1')
title('CDF for Chip B1 MSB')