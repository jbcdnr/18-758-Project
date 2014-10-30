T = 10; % samples per symbol
Fs = 100; % sample frequency

freqSync = ones(1, 100);
timingSync = [1 1 -1 1 1 -1 -1 1 1 1 -1 1 1 -1 1 -1 -1 1 1 1];
frameSync = [-1 -1 -1 -1 1 1 1 -1 -1 1 -1 -1 1 1 1 -1 -1 -1 -1];
pilot = [1 -1 1 -1 1 -1 1 -1 1 -1];
message = [1];

symbols = [freqSync timingSync frameSync pilot message];

nSamples = T * (length(symbols) + 60);
Xi = 1:nSamples;
X = zeros(1, nSamples);

for i = 1:length(symbols)
    t = T * (i + 30);
    X = X + symbols(i) * srrc(Xi - t, 0.9, T);
end

plotSignal(X, Fs);

transmitsignal = X;
save('transmitsignal.mat', 'transmitsignal');
