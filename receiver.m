load('receivedsignal.mat')

figure
plot(real(receivedsignal), 'b'); hold on
plot(imag(receivedsignal), 'r')

% Fourier transform
xi = real(receivedsignal);
Xi = real(fft(xi));

% Remove frequency under 1kHz
Xi(1:1000) = 0;

% Find the carrier frequency
[maxFreq, frequency] = max(Xi)

figure
plot(real(Xi), 'b')

threshold = 0.04;

%% cut the signal at interesting part

from= -1; to = -1;
for i = 1:length(xi)
  if abs(xi(i)) > threshold
    if from == -1
      from = i;
    end
    to = i;
  end
end

cutxi = xi(from:to);
plot(cutxi)

%% sampling
rate = 10^3;
T = rate / frequency;
samples = [];
for i = [1:T:length(cutxi)]
  samples = [ samples ((cutxi(floor(i)) > 0) * 2 -1) ];
end

plot(samples)
