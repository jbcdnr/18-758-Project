function X = applyPulse(symbols, pulse, pulseCenter, n)

    nSamples = n * (length(symbols) + 1);
    X = zeros(1, nSamples);
    
    pulsePadded = [ zeros(1, nSamples) pulse zeros(1, nSamples) ];
    disp(length(symbols))
    for i = 1:length(symbols)
        t = n*i;
        start = nSamples + pulseCenter - t;
        pulseI = pulsePadded(start:start+nSamples-1);
        X = X + symbols(i) * pulseI;
    end

end
