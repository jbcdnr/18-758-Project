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

    rgnA = abs(F) > 11.25;
    rgnB = abs(F) > 12.5;
    rgnC = abs(F) > 35;
    valA = (abs(F) - 11.25) * -40 / 1.25;
    valB = (abs(F) - 12.5) * -30 / 22.5 - 40;
    envelope = zeros(length(F), 1);
    envelope(rgnA) = valA(rgnA);
    envelope(rgnB) = valB(rgnB);
    envelope(rgnC) = -70;

    subplot(2, 1, 2);
    plot(F, 10*log10(abs(Y)), F, envelope);
    xlabel('Frequency (MHz)');
    pan xon;
    zoom xon;
end

