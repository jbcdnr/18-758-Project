% Setting variables
params;

load('receivedsignal.mat');

receivedsignal = resample(receivedsignal, rxUpsample, 1);

Fs = rxSamplingFrequency * rxUpsample; % Hz
n = Fs / symbolRate; % samples per symbol

%figure;
%plot((0:length(freqSyncSignal)-1)' / Fs * 10^6, angle(freqSyncSignal));
plotSignal(receivedsignal, Fs);

% start = find(abs(receivedsignal) > 0.075, 1);
% receivedsignal = receivedsignal(start:length(receivedsignal));

% Time recovery and sampling for frame sync
[T_hat, tau_hat] = doTimingSync(receivedsignal, timingSync, n, alpha);
nSample = length(timingSync) + packetSizeTot * ceil(messageSizeSymb / packetSizeInfo);
samples = doSampling(receivedsignal, nSample, T_hat, tau_hat);

cutSamples = samples((length(timingSync) + 2) : length(samples));

figure;
t = 1:length(cutSamples);
plot(t, real(cutSamples), 'b', t, imag(cutSamples), 'r')
title('cutSamples')

% Equalization and pilot removal
nChunks = floor(messageSizeSymb / packetSizeInfo);
messageSymbols = zeros(1, messageSizeSymb);
samp = ((1:nChunks+1)-1) * packetSizeTot + 1;
mess = ((1:nChunks+1)-1) * packetSizeInfo + 1;
for i = 1:nChunks
    s = cutSamples(samp(i) : samp(i)+packetSizeTot-1);
    eqSamples = equalize(pilot, s);
    messageSymbols(mess(i):mess(i) + packetSizeInfo - 1) = eqSamples;
end

remainingSamples = mod(messageSizeSymb, packetSizeInfo);
if remainingSamples ~= 0
    samples = samples(samp(nChunks + 1) : samp(nChunks + 1) + length(pilot) + remainingSamples - 1);
    eqSamples = equalize(pilot, samples);
    messageSymbols(mess(nChunks + 1):mess(nChunks + 1) + remainingSamples - 1) = eqSamples;
end

figure;
subplot(1,2,1)
endMessage = find(abs(samples) > 0.075, 5, 'last');
plot(real(samples(1:endMessage)), imag(samples(1:endMessage)), 'bo', real(constelation), imag(constelation), 'r*');
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

rxMessageBits = rxMessageBits(1:length(rxMessageBits)-2);
rxImage = reshape(rxMessageBits, imageDimension);
figure
subplot(1,3,1)
imshow(txImage)
title('Image transmitted')
subplot(1,3,2)
imshow(rxImage)
title('Image received')
subplot(1,3,3)
imshow(1-abs(rxImage-txImage))
title('Pixel errors')