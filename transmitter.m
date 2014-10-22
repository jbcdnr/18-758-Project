T = 100; % samples per symbol

freqSync = ones(1, 20);
timingSync = [1 1 -1 1 1 -1 -1 1 1 1 -1 1 1 -1 1 -1 -1 1 1 1];
frameSync = [-1 -1 -1 -1 1 1 1 -1 -1 1 -1 -1 1 1 1 -1 -1 -1 -1];
pilot = [1 -1 1 -1 1 -1 1 -1 1 -1];
message = [1];


symbols = [freqSync timingSync frameSync pilot message];

nSamples = T*(length(symbols) + 1);
Xi = 1:nSamples;
X = zeros(1, nSamples);

for i = 1:length(symbols)
    t = T*i;
    X = X + symbols(i) * rectpuls(Xi - t, T);
end

plot(Xi, X);

transmitsignal = X;
save('transmitsignal.mat', 'transmitsignal');
