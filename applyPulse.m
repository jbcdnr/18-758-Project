function X = applyPulse(symbols, n, alpha)

    nSamples = n * (length(symbols) + 1);
    Xi = 1:nSamples;
    X = zeros(1, nSamples);

    for i = 1:length(symbols)
        t = n*i;
        X = X + symbols(i) * srrc(Xi - t, alpha, n);
    end

end
