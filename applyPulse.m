function X = applyPulse(symbols, pulse, pulseCenter, n)

    nSamples = n * (length(symbols) + 1);
    X = zeros(1, nSamples);
    
    paddedPulse = [ zeros(1, nSamples) pulse zeros(1, nSamples) ];
    for i = 1:length(symbols)
        t = n*i;
        start = nSamples + pulseCenter - t;
        pulseI = paddedPulse(start:start+nSamples-1);
        X = X + symbols(i) * pulseI;
    end

end
