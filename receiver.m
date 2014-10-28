function receiver

    load('receivedsignal.mat');

    freqSync = ones(1, 20);
    timingSync = [1 1 -1 1 1 -1 -1 1 1 1 -1 1 1 -1 1 -1 -1 1 1 1];
    frameSync = [-1 -1 -1 -1 1 1 1 -1 -1 1 -1 -1 1 1 1 -1 -1 -1 -1];
    pilot = [1 -1 1 -1 1 -1 1 -1 1 -1];

    Fs = 25; % MHz
    T = 2; % samples per symbol
    L = length(receivedsignal);

    % for now, assume preamble starts when the signal goes above some value
    start = find(abs(receivedsignal) > 0.075, 1);

    freqSyncSignal = doFreqSync(receivedsignal, start, freqSync, Fs, T);

    plotSignal(freqSyncSignal, Fs);

    timingSyncStart = start + length(freqSync)*T;

    [T_hat, tau_hat, theta_hat] = doTimingSync(freqSyncSignal, timingSyncStart, ...
        timingSync, Fs, T)

    samples = doSampling(freqSyncSignal, T_hat, tau_hat, theta_hat);

    figure();
    stem([real(samples); imag(samples)]);
    pan xon;
    zoom xon;

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

function [T_hat, tau_hat, theta_hat] = doTimingSync(x, start, timingSync, Fs, T)

    C_hat = 0;
    T_hat = 0;
    tau_hat = 0;
    theta_hat = 0;

    % TODO try more values...?
    for T_prime = [T-1 T T+1]
        nSamples = T_prime*(length(timingSync) + 1);
        timingSignal = applyPulse(timingSync, nSamples, T_prime);
        [C, lag] = xcorr(x, timingSignal);
        [C_max, i_max] = max(C);
        if (C_max > C_hat)
            C_hat = C_max;
            T_hat = T_prime;
            tau_hat = lag(i_max);
            theta_hat = angle(C(i_max));
        end
    end

end

function samples = doSampling(x, T_hat, tau_hat, theta_hat)

    nSamples = 100;
    samples = zeros(nSamples)';
    phase = exp(1j * theta_hat);

    for i = 1:nSamples
        t = (1:length(x))' - tau_hat - i*T_hat;
        samples(i) = phase * sum(rectpuls(t, T_hat) .* x);
    end

end
