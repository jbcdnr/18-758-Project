
% Setting variables

load('receivedsignal.mat');

freqSync = ones(1, 20);
timingSync = [1 1 -1 1 1 -1 -1 1 1 1 -1 1 1 -1 1 -1 -1 1 1 1];
frameSync = [ 0 0 0 0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 1 0 0 0 0 1 1 1 0 0 1 0 0 0 0 ];    
pilot = [ 0.3517 + 0.8308i, 0.5853 + 0.5497i, 0.9172 + 0.2858i, 0.7572 + 0.7537i, 0.3804 + 0.5678i, 0.0759 + 0.0540i, 0.5308 + 0.7792i, 0.9340 + 0.1299i, 0.5688 + 0.4694i, 0.0119 + 0.3371i ];

M = 2; % size of the constelation
% TODO send image size inside the packet
imageSize = 3036;
imageDimension = [66 46];
lengthFrame = 44;

receivedsignal = resample(receivedsignal, 4, 1);

Fs = 100; % MHz
symbolRate = 12.5; % MHz
n = Fs / symbolRate; % samples per symbol

% Signal processing

start = find(abs(receivedsignal) > 0.075, 1);

% Carrier recovery
freqSyncSignal = doFreqSync(receivedsignal, start, freqSync, Fs, n);

plotSignal(freqSyncSignal, Fs);

% Time recovery and sampling
timingSyncStart = start + length(freqSync)*n;
[T_hat, tau_hat, theta_hat] = doTimingSync(freqSyncSignal, timingSyncStart, timingSync, Fs, n);

samples = doSampling(freqSyncSignal, T_hat, tau_hat, theta_hat);

% Frame synchronization
[cutSamples, ~] = doFrameSync(samples, frameSync);

% Equalization and decoding

cycles = length(messageSymb) / lengthFrame;
messageSymbols = zeros( 1, lengthFrame * cycles );

for Xi = 1:lengthFrame:length(messageSymbols)
    eqMessage = equalize(pilot, cutSamples);
    messageSymbols(Xi : Xi + lengthFrame - 1) = eqMessage(1:lengthFrame);
    if  lengthFrame + 1 <= length(eqMessage)
        cutSamples = eqMessage(lengthFrame+1:length(eqMessage));
    end
end
messageBits = M_PSK_decode(messageSymbols, M);
messageBits = messageBits(1:imageSize);

% Reconstruct image
im = reshape(messageBits, imageDimension);
figure
imshow(im)
