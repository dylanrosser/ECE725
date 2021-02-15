clear all; close all; clc;

% dir = '/afs/ece/class/ece725/Groups/Group1/sim/SARADC_validation_dylan/spectre/schematic/psf';
% load sim output
%vod_=cds_srr(dir,'tran-tran','vod');

% read into matlab variables
%dat = readtable('sanitycheck.csv');
dat = readtable('../HighSpeedTests/3MHz_fs/Vref_0.47.csv');
t = dat.(1);
y = dat.(2);

t = t - t(1);

%t_new = linspace(0,t(100e3), 6e3);
t_new = 0:1/3e6:2e-3;
t_new = t_new + 6/30e6;
t_new = t_new(1:end-1);
%resample for 3MHz
% y = resample(y, 1, 16);
% t = resample(t, 1, 16);
vod = interp1(t, y, t_new, 'nearest')
% cut into 2 cycles, 3000 samples per cycle
%t = t(100:6100);
%vod = y(100:6100);

% cut into 5 cycles, 3200 samples per cycle
% t = t(1:16000);
% vod = y(1:16000);
%t    = vod_.time;
%vod  = vod_.V;

% Number of time/frequency points

%N = 64;
N = 6000;
% Sampling frequency
fs = 3e6;
% Number of cycles of the input sinusoid
cycles = 2;
% Input frequency
fin = cycles/N*fs;

% When I ran this, vod contained 66 points [NaN, value0, value1, ... value0];
% I skipped the first two
%vod = vod(2:end)'; % use this if vod winds up to be 65x1
%vod = vod(3:end)';
% Check and see what Spectre does to your data

% Two-sided PSD
s = abs(fft(vod) / N).^2;
% Convert to single-sided PSD
%s = [s(1), 2*s(2:end/2), s(end/2+1)];
s = [s(1), 2*s(2:end/2), s(end/2+1)];

% PSD bin containing signal
sigbin = cycles + 1;

% Signal power
psig = s(sigbin);
% Noise and distortion power excludes DC and signal bin
pnd = sum([s(2:sigbin-1), s(sigbin+1:end)]);
% Signal to noise and distortion ratio
sndr = 10*log10(psig/pnd);
enob = (sndr-1.76)/6.02;

% Scale to dBFS for plot
% Output full-scale amplitude
% Open VerilogA for bin2v_10bit and you'll see it scales the signal to +/- 0.5V
FSA = 1024;
s = 10*log10(s / (FSA^2/2));
f = [0:N/2]/N;
figure()
plot(f, s, 'linewidth', 2);
xlabel('Frequency [f/fs]')
ylabel('DFT Magnitude [dBFS]');
%title(['Post-Layout SDR = ', num2str(sndr), ' dB', ' (V_{ref}=0.52 V, V_{in,amp}=0.445 V, f_s=50M)']);
title(['SDR = ', num2str(sndr), ' dB']);


