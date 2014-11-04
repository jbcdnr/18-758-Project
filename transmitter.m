samplingFrequency = 100 * 10^6; % Hz
symbolRate = 12.5 * 10^6; % Hz
n = samplingFrequency / symbolRate; % samples per symbol

M = 4;        % size of constelation
alpha = 0.5;  % SRRC coefficient
pad = 50;     % extra samples to transmit on either side of message

freqSync = ones(1, 40);
timingSync = [1 1 -1 1 1 -1 -1 1 1 1 -1 1 1 -1 1 -1 -1 1 1 1];
frameSync = [0 0 0 0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 1 0 0 0 0 1 1 1 0 0 1 0 0 0 0]*2-1;
pilot = [ 0.3517 + 0.8308i, 0.5853 + 0.5497i, 0.9172 + 0.2858i, 0.7572 + 0.7537i, 0.3804 + 0.5678i, 0.0759 + 0.0540i, 0.5308 + 0.7792i, 0.9340 + 0.1299i, 0.5688 + 0.4694i, 0.0119 + 0.3371i ];
messageBits = [ 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1 ];
messageSymb = M_PSK_encode(messageBits, M, 1);

symbols = [freqSync timingSync frameSync pilot messageSymb];

nSamples = n*(length(symbols) + 2 * pad);
Xi = 1:nSamples;
X = zeros(1, nSamples);

for i = 1:length(symbols)
    t = n * (i + pad);
    X = X + symbols(i) * srrc(Xi - t, alpha, n);
end
X = 0.9 * X / max(abs(X));

plotSignal(X, samplingFrequency);

transmitsignal = X;
save('transmitsignal.mat', 'transmitsignal');
