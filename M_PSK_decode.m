function bitSequence = M_PSK_decode(symbolSequence, M)

    b = nextpow2(M);
    bitSequence = zeros(1, length(symbolSequence) * b);
    
    values = mod(round(angle(symbolSequence) * (M / (2*pi))), M);
    values = gray2bin(values, 'psk', M);
    
    for i = 1:length(symbolSequence)
        bits = de2bi(values(i), b);
        index = (i-1) * b + 1;
        bitSequence(index:index+b-1) = bits;
    end
end