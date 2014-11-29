function Y = channelDecode(X, g, nu)
% X  The coded bits
% Y  The information bits
% g  The table describing the trellis
% nu The number of bits of past state

    k = size(g, 1);
    n = size(g, 2);

    nStates = 2^nu;
    nInputs = 2^k;
    nPastBits = ceil(nu/k);

    % convert g to a 3-dimensional array:
    %  dim 1: k
    %  dim 2: nPastBits+1, one for each bit in octal number
    %  dim 3: n
    G = [];
    for i = 1:n
        G = cat(3, G, de2bi(g(:, i), nPastBits+1));
    end

    % ensure we have n rows to group bits by stage
    X = reshape(X, n, []);
    Xlen = size(X, 2);

    % generate table of state transitions and codes ahead of time
    nextStateTable = zeros(nStates, nInputs);
    codedTable = zeros(n, nStates, nInputs);
    for state = 0:nStates-1
        % zero fill binState to ensure it can be reshaped into k rows
        binState = [de2bi(state, nu) zeros(1, mod(nu, k))];
        binState = reshape(binState, k, []);
        for input = 0:nInputs-1
            binInput = de2bi(input, k);
            for i = 1:n
                andResult = G(:, :, i) .* [binInput' binState]; % "and"
                codedTable(i, state+1, input+1) = ...
                    mod(sum(sum(andResult)), 2); % "xor"
            end
            nextState = [binInput' binState(:,1:nPastBits-1)];
            nextState = reshape(nextState, 1, []);
            nextStateTable(state+1, input+1) = bi2de(nextState(1:nu));
        end
    end

    dist = zeros(nStates, Xlen+1) + Inf;
    dist(1, 1) = 0;
    prevState = zeros(nStates, Xlen+1);
    prevInput = zeros(nStates, Xlen+1);

    % move forward through stages, filling dist, prevState, and prevInput
    for Xi = 1:Xlen
        % get a column vector of received bits, repeated for each state
        coded = repmat(X(:, Xi), 1, nStates);
        for input = 0:nInputs-1
            % get table of (coded bits, states)
            idealCoded = codedTable(:, :, input+1);
            % get row vector of next states
            nextStates = nextStateTable(:, input+1)';
            % compute difference for each state
            diff = sum(abs(idealCoded - coded))';
            totalDists = dist(:, Xi) + diff;
            for state = 1:nStates
                nextState = nextStates(state)+1;
                if totalDists(state) < dist(nextState, Xi+1)
                    dist(nextState, Xi+1) = totalDists(state);
                    prevState(nextState, Xi+1) = state-1;
                    prevInput(nextState, Xi+1) = input;
                end
            end
        end
    end

    % move backward through stages, tracking min distance
    state = 0;
    Y = zeros(1, Xlen*k);
    for Xi = Xlen:-1:1
        input = prevInput(state+1, Xi+1);
        Y((Xi-1)*k + 1 : Xi*k) = de2bi(input, k);
        state = prevState(state+1, Xi+1);
    end

    % remove 0 padding from encoding
    Y = Y(1:length(Y)-(nu+1)*k);

end

