function receiver

    load('receivedsignal.mat');

    freqSync = ones(1, 20);
    timingSync = [1 1 -1 1 1 -1 -1 1 1 1 -1 1 1 -1 1 -1 -1 1 1 1];
    frameSync = [-1 -1 -1 -1 1 1 1 -1 -1 1 -1 -1 1 1 1 -1 -1 -1 -1];
    pilot = [1 -1 1 -1 1 -1 1 -1 1 -1];

    Fs = 25; % MHz
    T = 25; % samples per symbol
    L = length(receivedsignal);

    % for now, assume preamble starts when the signal goes above some value
    start = find(abs(receivedsignal) > 0.075, 1);

    freqSyncSignal = doFreqSync(receivedsignal, start, freqSync, Fs, T);

    plotSignal(freqSyncSignal, Fs);

end

function y = doFreqSync(x, start, freqSync, Fs, T)

    len = length(freqSync) * T;
    sync = x(start : start + len - 1);

    [~, f, X] = DTFT(sync, Fs, 5);

    [~, maxSample] = max(abs(X));
    delta = f(maxSample);
    theta = -angle(X(maxSample));

    t = ((0:length(x)-1)' - start) / Fs;
    y = exp(-1j * ((2*pi*delta) * t - theta)) .* x;

end