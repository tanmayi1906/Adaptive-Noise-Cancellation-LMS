clear; close all; clc;

load handel
x = y;
fs = Fs;

x = x / max(abs(x));

N = length(x);

noise = 0.3*randn(N,1);
d = x + noise;
u = noise;

M = 32;
mu = 0.01;

w_lms = zeros(M,1);
y_lms = zeros(N,1);
e_lms = zeros(N,1);

for n = M:N
    u_vec = u(n:-1:n-M+1);
    y_lms(n) = w_lms' * u_vec;
    e_lms(n) = d(n) - y_lms(n);
    w_lms = w_lms + mu * u_vec * e_lms(n);
end

mu_n = 0.5;
eps = 1e-6;

w_nlms = zeros(M,1);
y_nlms = zeros(N,1);
e_nlms = zeros(N,1);

for n = M:N
    u_vec = u(n:-1:n-M+1);
    y_nlms(n) = w_nlms' * u_vec;
    e_nlms(n) = d(n) - y_nlms(n);
    norm_u = (u_vec' * u_vec) + eps;
    w_nlms = w_nlms + (mu_n / norm_u) * u_vec * e_nlms(n);
end

snr_in = 10*log10(sum(x.^2)/sum((d-x).^2));
snr_lms = 10*log10(sum(x.^2)/sum((e_lms-x).^2));
snr_nlms = 10*log10(sum(x.^2)/sum((e_nlms-x).^2));

fprintf('\n--- SNR Results ---\n');
fprintf('Input SNR  : %.2f dB\n', snr_in);
fprintf('LMS Output : %.2f dB\n', snr_lms);
fprintf('NLMS Output: %.2f dB\n', snr_nlms);

fprintf('\n--- Improvement ---\n');
fprintf('LMS Improvement : %.2f dB\n', snr_lms - snr_in);
fprintf('NLMS Improvement: %.2f dB\n', snr_nlms - snr_in);

e_lms = e_lms / max(abs(e_lms));
e_nlms = e_nlms / max(abs(e_nlms));
d = d / max(abs(d));

figure;
subplot(4,1,1); plot(x); title('Original Speech');
subplot(4,1,2); plot(d); title('Noisy Speech');
subplot(4,1,3); plot(e_lms); title('LMS Output');
subplot(4,1,4); plot(e_nlms); title('NLMS Output');

figure;
plot(10*log10(e_lms.^2)); hold on;
plot(10*log10(e_nlms.^2));
legend('LMS','NLMS');
title('Error Convergence');

audiowrite('noisy.wav', d, fs);
audiowrite('lms_output.wav', e_lms, fs);
audiowrite('nlms_output.wav', e_nlms, fs);