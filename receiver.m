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

% Equalization and pilot removal
nChunks = messageSizeSymb / packetSizeInfo;
messageSymbols = zeros(1, messageSizeSymb);
samp = ((1:nChunks)-1) * packetSizeTot + 1;
mess = ((1:nChunks)-1) * packetSizeInfo + 1;
for i = 1:nChunks
    samples = cutSamples(samp(i) : samp(i)+packetSizeTot-1);
    eqSamples = equalize(pilot, samples);
    messageSymbols(mess(i):mess(i) + packetSizeInfo - 1) = eqSamples;
end

constelation = [1 1i -1 -1i];
figure;
subplot(1,2,1)
endMessage = find(abs(cutSamples) > 0.075, 5, 'last');
plot(real(cutSamples(1:endMessage)), imag(cutSamples(1:endMessage)), 'bo', real(constelation), imag(constelation), 'r*');
title('Samples before equalization')
subplot(1,2,2)
plot(real(messageSymbols), imag(messageSymbols), 'bo', real(constelation), imag(constelation), 'r*');
title('Samples after equalization')

% symobols to bit decoding
rxCodedBits = M_PSK_decode(messageSymbols, M);

rxMessageBits = channelDecode(rxCodedBits);

codedBER = sum(rxCodedBits ~= txCodedBits) / length(rxCodedBits);
BER = sum(rxMessageBits ~= txMessageBits) / length(rxMessageBits);
fprintf('Coded BER = %f\n', codedBER);
fprintf('BER = %f\n', BER);
