function Y = channelEncode(X, g, nu)
% X The information bits
% Y The coded bits
% g  The table describing the trellis
% nu The number of bits of past state

    k = size(g, 1);
    n = size(g, 2);

    nPastBits = ceil(nu/k);

    % convert g to a 3-dimensional array:
    %  dim 1: k
    %  dim 2: nPastBits+1, one for each bit in octal number
    %  dim 3: n
    G = [];
    for i = 1:n
        G = cat(3, G, de2bi(g(:, i), nPastBits+1));
    end

    % ensure we have k rows to group bits by stage
    X = reshape(X, k, []);

    % add some zero padding so we finish in the first state
    X = [X zeros(k, nu + 1)];

    Y = zeros(1, size(X, 2)*n);
    Yi = 1;

    % for each column (size k), emit n coded bits
    state = zeros(k, nPastBits+1);
    for info = X
        % push info into front of state
        state = [info state(:,1:nPastBits)];
        % for each output bit, do "xor" computation
        for i = 1:n
            andResult = G(:, :, i) .* state; % "and"
            Y(Yi) = mod(sum(sum(andResult)), 2); % "xor"
            Yi = Yi + 1;
        end
    end

end
