%% load and plot the received signal

load('receivedsignal.mat')
x = receivedsignal;
xi = real(x);
xq = imag(x);

figure
plot(xi, 'b'); hold on
plot(xq, 'r')

%% remove the padding part of the signal

threshold = 0.06;

from= -1; to = -1;
for i = 1:length(x)
  if abs(x(i)) > threshold
    if from == -1
      from = i;
    end
    to = i;
  end
end

x = x(from:to);

figure
plot(real(x), 'b'); hold on
plot(imag(x), 'r')

%% Carrier recovery
Xfft = fft(x);

XModulus = abs(Xfft);
XModulus(1:400) = 0;
[modulus, frequency] = max(XModulus);
phaseShift = angle(Xfft(frequency));

t = [1:length(x)].';
corrector = exp(-1i*(2*pi*frequency*t-phaseShift));
xCorrected = x.*corrector

figure
plot(real(xCorrected), 'b'); hold on
plot(imag(xCorrected), 'r')

%% sampling 
symbolRate = 10^6; % Hz
sampleFrequency = 25*10^6; % Hz
n = sampleFrequency / symbolRate;
samples = zeros(1, ceil(length(xCorrected) / n));
i=1;
for t = 1:n:length(xCorrected)
  sample = xCorrected(floor(t));
  samples(i) = (real(sample) > 0) * 2 - 1;
  i=i+1;
end

figure
plot(samples)
