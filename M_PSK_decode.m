function bitSequence = M_PSK_decode(symbolSequence, M)

    b = nextpow2(M);
    bitSequence = zeros(1, length(symbolSequence) * b);
    
    for i = 1:length(symbolSequence)
        symbol = symbolSequence(i);
        value = mod(round(angle(symbol) * M / (2*pi)), M);
        bits = dec2binary(value, b);
        
        index = (i-1) * b + 1;
        bitSequence(index:index+b-1) = bits;
    end
end

function binary = dec2binary(decimal, size)
    binary = zeros(1,size);
    for i = size:-1:1
        binary(i) = mod(decimal, 2);
        decimal = floor(decimal / 2);
    end
end