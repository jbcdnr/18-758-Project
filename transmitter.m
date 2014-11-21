params;

fprintf('Transmitting message of %d bits\n', messageSizeBits);

n = txSamplingFrequency / symbolRate; % samples per symbol

% Note that we condider the message to be already padded to fit exactly the
% packet size
nChunks = messageSizeSymb / packetSizeInfo;
messageSymb = zeros(1, nChunks * packetSizeTot);
mb = ((1:nChunks) - 1) * packetSizeInfo * nextpow2(M) + 1;
ms = ((1:nChunks) - 1) * packetSizeTot + 1;
for i = 1:nChunks
   symbols = M_PSK_encode(messageBits(mb(i):mb(i) + packetSizeInfo * nextpow2(M) - 1), M, 0.9);
   messageSymb(ms(i) : ms(i) + packetSizeTot - 1)  = [ pilot symbols ];
end

symbols = [freqSync timingSync frameSync messageSymb];

padding = zeros(1, txPad);
X = applyPulse([padding symbols padding], n, alpha);
X = 0.9 * X / max(abs(X));

plotSignal(X, txSamplingFrequency);

transmitsignal = X;
save('transmitsignal.mat', 'transmitsignal');
