fs = 1000;
t = 0:1/fs:1;

x = sin(2*pi*50*t);

noise = 0.3*randn(size(t));
d = x + noise;

mu = 0.005;
M = 8;
N = length(d);

w = zeros(M,1);
y = zeros(1,N);
e = zeros(1,N);

for n = M:N
    xn = d(n:-1:n-M+1)';
    y(n) = w' * xn;
    e(n) = d(n) - y(n);
    w = w + mu * e(n) * xn;
end

figure;

subplot(4,1,1);
plot(t,x);
title('Original Signal');

subplot(4,1,2);
plot(t,d);
title('Noisy Signal');

subplot(4,1,3);
plot(t,y);
title('Filtered Signal');

subplot(4,1,4);
plot(t,e);
title('Error Signal (Convergence)');
figure;
plot(e.^2);
title('Mean Square Error Convergence');