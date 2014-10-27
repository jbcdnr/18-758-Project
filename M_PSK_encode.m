function symbolSequence = M_PSK_encode(bitSequence, M, r)
    b = nextpow2(M);
    if 2^b ~= M || mod(length(bitSequence), b) ~= 0
        error('impossible encoding')
    end
    
    symbolSequence = zeros(1,length(bitSequence) / b);
    
    for i = 1:b:length(bitSequence)
       bits = bitSequence(i:i+b-1);
       n = bin2dec(bits);
       symbolSequence(ceil(i/b)) = r * exp(1j*2*pi*n/M);
    end
end

function decimal = bin2dec(binaryArray)
    power = 1; decimal = 0;
    for i = length(binaryArray):-1:1
       decimal = decimal + binaryArray(i) * power;
       power = 2 * power;
    end
end