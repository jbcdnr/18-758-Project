function Y = channelDecode(X)
% X The coded bits
% Y The information bits

    % rate 1/3
    g = oct2dec([367 331 225]);
    nu = 7;
    k = size(g, 1);
    n = size(g, 2);

    nStates = 2^nu;

    % convert g to a 3-dimensional array:
    %  dim 1: k
    %  dim 2: nu+1, one for each bit in octal number
    %  dim 3: n
    G = [];
    for i = 1:n
        G = cat(3, G, de2bi(g(:, i), nu+1));
    end

    % ensure we have n rows to group bits by stage
    X = reshape(X, n, []);
    Xlen = size(X, 2);

    dist = zeros(nStates, Xlen+1) + Inf;
    dist(1, 1) = 0;
    prevState = zeros(nStates, Xlen+1);
    prevInput = zeros(nStates, Xlen+1);

    % move forward through stages, filling dist and prevState
    for Xi = 1:Xlen
        coded = X(:, Xi)';
        for state = 0:nStates-1
            % TODO if k > 1, binState must be reshaped to have k rows
            binState = de2bi(state, nu);
            for input = 0:2^k-1
                binInput = de2bi(input, k);
                % TODO precompute idealCoded for all inputs/states
                idealCoded = zeros(1, n);
                for i = 1:n
                    andResult = G(:, :, i) .* [binInput binState]; % "and"
                    idealCoded(i) = mod(sum(sum(andResult)), 2); % "xor"
                end
                diff = sum(abs(idealCoded - coded));
                nextState = bi2de([binInput binState(1:nu-1)]);
                if dist(state+1, Xi) + diff < dist(nextState+1, Xi+1)
                    dist(nextState+1, Xi+1) = dist(state+1, Xi) + diff;
                    prevState(nextState+1, Xi+1) = state;
                    prevInput(nextState+1, Xi+1) = input;
                end
            end
        end
    end

    % move backward through stages, tracking min distance
    state = 0;
    Y = zeros(1, Xlen*k);
    for Xi = Xlen:-1:1
        input = prevInput(state+1, Xi+1);
        Y(Xi*k : (Xi-1)*k + 1) = de2bi(input, k);
        state = prevState(state+1, Xi+1);
    end

    % remove 0 padding from encoding
    Y = Y(1:length(Y)-nu-1);

end

