params;
n = txSamplingFrequency / symbolRate;

nSegments = ceil(messageSizeSymb / packetSizeInfo);
messageSymb = zeros(1, nSegments * length(pilot) + messageSizeSymb);
mb = ((1:nSegments) - 1) * packetSizeInfo * nextpow2(M) + 1;
ms = ((1:nSegments) - 1) * packetSizeTot + 1;
for i = 1:nSegments
   symbols = M_PSK_encode(txCodedBits(mb(i):min(length(txCodedBits), mb(i) + packetSizeInfo * nextpow2(M) - 1)), M, 1);
   messageSymb(ms(i) : min(length(messageSymb), ms(i) + packetSizeTot - 1))  = [ pilot symbols ];
end

symbols = [ones(1, 200) timingSync messageSymb];

fprintf('Transmitting message of %d bits in %d us\n', messageSizeBits, ceil(length(symbols) / symbolRate * 10^6));
if length(transmitsignal) > 800 * 10^-6 * txSamplingFrequency
    error('Signal is too long (%d samples)\n', ...
        length(transmitsignal));
end

pulseTx = srrc(-pulseCenter:pulseCenter, alpha, n);
padding = zeros(1, txPad);
X = applyPulse([padding symbols padding], pulseTx, pulseCenterTx, n);
X = 0.9 * X / max(abs(X));

plotSignal(X, txSamplingFrequency);

transmitsignal = X;
save('transmitsignal.mat', 'transmitsignal');
