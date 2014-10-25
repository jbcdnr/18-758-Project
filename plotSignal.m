function plotSignal(X, Fs)
%PLOTSIGNAL Plots a complex signal in time and frequency domains
%   X is the signal. Fs is the sample frequency in MHz.

    if (isrow(X))
        X = X';
    end

    [T, F, Y] = DTFT(X, Fs, 5);

    figure();

    subplot(2, 1, 1);
    plot(T, real(X), T, imag(X));
    xlabel('Time (us)');
    pan xon;
    zoom xon;

    subplot(2, 1, 2);
    %plotyy(F, abs(Y), F, angle(Y));
    plot(F, abs(Y));
    xlabel('Frequency (MHz)');
    pan xon;
    zoom xon;
end

