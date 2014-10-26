sampleFrequency = 100 * 10^6; % Hz
symbolRate = 10^6; % Hz
samplesPerSymbol = sampleFrequency / symbolRate;

freqSync = ones(1, 20);
timingSync = [1 1 -1 1 1 -1 -1 1 1 1 -1 1 1 -1 1 -1 -1 1 1 1];
frameSync = [1 -1 1 1 -1 -1 1 1 1 -1 -1 -1 1 1 1 1 -1 -1 -1 -1 1 1 1 1];
pilot = [1 -1 1 -1 1 -1 1 -1 1 -1];
message = [1];

symbols = [freqSync timingSync frameSync pilot message];

nSamples = samplesPerSymbol * length(symbols);
Xi = 1:nSamples;
X = zeros(1, nSamples);

for i = 1:length(symbols)
    t = samplesPerSymbol*i;
    X = X + symbols(i) * rectpuls(Xi - t, samplesPerSymbol);
end

figure
plot(Xi, X);

transmitsignal = X;
save('transmitsignal.mat', 'transmitsignal');
