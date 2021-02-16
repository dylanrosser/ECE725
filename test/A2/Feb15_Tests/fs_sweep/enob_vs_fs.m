% ENOB vs. fs

clear all; close all; clc;


csvfiles = dir('*.csv');
enobs = []
fs = str2double(erase(extractfield(csvfiles, 'name'), 'kHz.csv'))
count = 1;

for file = csvfiles'
    num_bits = get_enob(string(file.name), fs(count)*1e3);
    fprintf(1, 'file is %s %d \n', file.name, fs(count)*1e3);
    enobs = [enobs, num_bits];
    count = count+1;
    
end

[fs_sorted, idx] = sort(fs);
enobs_sorted = enobs(idx);
semilogx(fs_sorted, enobs_sorted);
xlabel('f_{s} (kHz)');
ylabel('ENOB')
title('ENOB vs.  Sample Rate');

% read into matlab variables
function ge = get_enob(file, f_s)


dat = readtable(file);
t = dat.(1);
y = dat.(2);


% Number of cycles of the input sinusoid
cycles = 5;
% Sampling frequency
fs = f_s;
%simulation variables
fin = cycles*fs/4096;
% Number of time/frequency points
N = round(cycles/fin*fs);


t = t(1:N);
vod = y(1:N);

% Input frequency
%fin = cycles/N*fs;

% When I ran this, vod contained 66 points [NaN, value0, value1, ... value0];
% I skipped the first two
%vod = vod(2:end)'; % use this if vod winds up to be 65x1
%vod = vod(3:end)';
% Check and see what Spectre does to your data

% Two-sided PSD
s = abs(fft(vod) / N).^2;
% Convert to single-sided PSD
%s = [s(1), 2*s(2:end/2), s(end/2+1)];
s = [s(1), transpose(2*s(2:end/2)), s(end/2+1)];

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
%figure()
% plot(f, s, 'linewidth', 2);
% xlabel('Frequency [f/fs]')
% ylabel('DFT Magnitude [dBFS]');
% %title(['Post-Layout SDR = ', num2str(sndr), ' dB', ' (V_{ref}=0.52 V, V_{in,amp}=0.445 V, f_s=50M)']);
% title(['SDR = ', num2str(sndr), ' dB']);

ge = enob;
end