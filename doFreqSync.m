function y = doFreqSync(x, start, freqSync, Fs, T)
% x        The received signal
% start    The estimated offset (in samples) of the frequency sync frame
% freqSync The symbols expected for the frequency sync frame
% Fs       The sample rate in Hz
% T        The symbol period in samples

    % total length of frequency sync in number of samples
    len = length(freqSync) * T;

    % received frequency sync frame
    sync = x(start : start + len - 1);

    % find peak value of the DTFT
    [~, f, X] = DTFT(sync, Fs, 5);
    [~, maxSample] = max(abs(X));
    delta = f(maxSample);
    theta = -angle(X(maxSample));

    % shift so that the peak value is around 0, and correct phase
    t = ((0:length(x)-1)' - start) / Fs;
    y = exp(-1j * ((2*pi*delta) * t - theta)) .* x;

end
