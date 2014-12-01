% Setting variables
params;

load('receivedsignal.mat');

receivedsignal = resample(receivedsignal, rxUpsample, 1);

Fs = rxSamplingFrequency * rxUpsample; % Hz
n = Fs / symbolRate; % samples per symbol

% Signal processing

start = find(abs(receivedsignal) > 0.075, 1) + length(warmup)*n;

% Carrier recovery
freqSyncSignal = doFreqSync(receivedsignal, start, freqSync, Fs, n);

%figure;
%plot((0:length(freqSyncSignal)-1)' / Fs * 10^6, angle(freqSyncSignal));
plotSignal(receivedsignal, Fs);
plotSignal(freqSyncSignal, Fs);

% Time recovery and sampling for frame sync
[T_hat, tau_hat, theta_hat, rxPulse, rxCenterPulse] = doTimingSync(freqSyncSignal, timingSync, n, alpha);
nSample = length([timingSync frameSync]) + packetSizeTot * ceil(messageSizeSymb / packetSizeInfo);
samples = doSampling(freqSyncSignal, nSample, T_hat, tau_hat, theta_hat, rxPulse, rxCenterPulse);

% Frame synchronization
[cutSamples, ~] = doFrameSync(samples, frameSync);

% Equalization and pilot removal
nChunks = floor(messageSizeSymb / packetSizeInfo);
messageSymbols = zeros(1, messageSizeSymb);
samp = ((1:nChunks+1)-1) * packetSizeTot + 1;
mess = ((1:nChunks+1)-1) * packetSizeInfo + 1;
for i = 1:nChunks
    samples = cutSamples(samp(i) : samp(i)+packetSizeTot-1);
    eqSamples = equalize(pilot, samples);
    messageSymbols(mess(i):mess(i) + packetSizeInfo - 1) = eqSamples;
end

remainingSamples = mod(messageSizeSymb, packetSizeInfo);
if remainingSamples ~= 0
    samples = cutSamples(samp(nChunks + 1) : samp(nChunks + 1) + length(pilot) + remainingSamples - 1);
    eqSamples = equalize(pilot, samples);
    messageSymbols(mess(nChunks + 1):mess(nChunks + 1) + remainingSamples - 1) = eqSamples;
end

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
rxMessageBits = channelDecode(rxCodedBits, g, nu);

codedBER = sum(rxCodedBits ~= txCodedBits) / length(rxCodedBits);
BER = sum(rxMessageBits ~= txMessageBits) / length(rxMessageBits);
fprintf('Coded BER = %f\n', codedBER);
fprintf('BER = %f\n', BER);

rxImage = reshape(rxMessageBits, imageDimension);
figure
subplot(1,2,1)
imshow(txImage)
title('Image transmitted')
subplot(1,2,2)
imshow(rxImage)
title('Image received')