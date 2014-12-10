function symbolSequence = M_PSK_encode(bitSequence, M, r)

    b = nextpow2(M);
    if 2^b ~= M || mod(length(bitSequence), b) ~= 0
        error('error during constellation encoding')
    end
    
    symbolSequence = zeros(1, length(bitSequence) / b);
    reshaped = reshape(bitSequence, [length(bitSequence) / b, b]);
    for i = 1:length(bitSequence) / b
        n = bin2gray(bi2de(reshaped(i,:)), 'psk', M);
        symbolSequence(i) = r * exp(1j*2*pi*n/M);
    end
end