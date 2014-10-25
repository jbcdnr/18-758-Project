carrierFrequency = 10^5; % Hz
symbolRate = 10^3; % Hz
samplesPerSymbol = carrierFrequency / symbolRate;

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

plot(Xi, X);

transmitsignal = X;
save('transmitsignal.mat', 'transmitsignal');
