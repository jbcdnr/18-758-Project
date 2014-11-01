
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
