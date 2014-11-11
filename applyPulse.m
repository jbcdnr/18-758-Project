function X = applyPulse(symbols, nSamples, T)

    Xi = 1:nSamples;
    X = zeros(1, nSamples);

    for i = 1:length(symbols)
        t = T*i;
        X = X + symbols(i) * srrc(Xi - t, 0.5, T);
    end

end
