params;

fprintf('Transmitting message of %d bits\n', messageSize);

n = txSamplingFrequency / symbolRate; % samples per symbol

messageSymb = M_PSK_encode(messageBits, M, 1);

symbols = [freqSync timingSync frameSync pilot messageSymb];

padding = zeros(1, txPad);
X = applyPulse([padding symbols padding], n, alpha);
X = 0.9 * X / max(abs(X));

plotSignal(X, txSamplingFrequency);

transmitsignal = X;
save('transmitsignal.mat', 'transmitsignal');
