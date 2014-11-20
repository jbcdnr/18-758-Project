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

% Time recovery and sampling for frame sync
[T_hat, tau_hat, theta_hat] = doTimingSync(freqSyncSignal, timingSync, n, alpha);
nSample = length(timingSync) + length(frameSync) + (length(pilot) + packetSizeInfo ) * messageSizeSymb / packetSizeInfo + 10;
samples = doSampling(freqSyncSignal, alpha, nSample, T_hat, tau_hat, theta_hat);

% Frame synchronization
[cutSamples, ~] = doFrameSync(samples, frameSync);

% Equalization and decoding
nChunks = messageSizeSymb / packetSizeInfo;
packetSizeTot = length(pilot) + packetSizeInfo;
rxMessageBits = zeros(1, messageSizeBits);
for i = 1:nChunks
    si = (i-1) * packetSizeTot + 1;
    samples = cutSamples(si : si+packetSizeTot-1);
    disp(size(samples));
    eqSamples = equalize(pilot, samples);
    messageChunck = M_PSK_decode(eqSamples, M);
    mi = (i-1) * packetSizeInfo * nextpow2(M) + 1;
    rxMessageBits(mi : mi + packetSizeInfo * nextpow2(M) - 1) = messageChunck;
end

% figure;
% messageSamples = cutSamples(1:messageSize / nextpow2(M));
% constelation = [1 1i -1 -1i];
% plot(real(messageSamples), imag(messageSamples), 'bo', real(constelation), imag(constelation), 'r*');
% figure;
% plot(real(messageSymbols), imag(messageSymbols), 'bo', real(constelation), imag(constelation), 'r*');

BER = sum(rxMessageBits ~= messageBits) / length(rxMessageBits);
fprintf('BER = %f\n', BER);
