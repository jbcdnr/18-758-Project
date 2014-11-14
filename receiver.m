% Setting variables
params;

load('receivedsignal.mat');

receivedsignal = resample(receivedsignal, rxUpsample, 1);

Fs = rxSamplingFrequency * rxUpsample; % Hz
n = Fs / symbolRate; % samples per symbol

% Signal processing

start = find(abs(receivedsignal) > 0.075, 1);

% Carrier recovery
freqSyncSignal = doFreqSync(receivedsignal, start, freqSync, Fs, n);
plotSignal(freqSyncSignal, Fs);

% Time recovery and sampling
[T_hat, tau_hat, theta_hat] = doTimingSync(freqSyncSignal, timingSync, n, alpha);
samples = doSampling(freqSyncSignal, alpha, n, T_hat, tau_hat, theta_hat);

% Frame synchronization
[cutSamples, ~] = doFrameSync(samples, frameSync);

% Equalization and decoding
messageSymboles = equalize(pilot, cutSamples);
messageSymboles = messageSymboles(1:messageSize / nextpow2(M));
rxMessageBits = M_PSK_decode(messageSymboles, M);

figure;
messageSamples = cutSamples(1:messageSize / nextpow2(M));
constelation = [1 1i -1 -1i];
plot(real(messageSamples), imag(messageSamples), 'bo', real(constelation), imag(constelation), 'r*');
figure;
plot(real(messageSymboles), imag(messageSymboles), 'bo', real(constelation), imag(constelation), 'r*');

BER = sum(rxMessageBits ~= messageBits) / length(rxMessageBits);
fprintf('BER = %f\n', BER);
