function X = srrc(t, alpha, Ts)
%SRRC Returns a square-root raised cosine pulse

    X = (sin((1 - alpha) * pi / Ts * t) ...
        + 4 * alpha / Ts * t .* cos((1 + alpha) * pi / Ts * t)) ...
        ./ (pi / sqrt(Ts) * t .* (1 - (4 * alpha / Ts * t) .^ 2));

    X(t == 0) = (1 - alpha + 4 * alpha / pi) / sqrt(Ts);

    X(abs(t) == Ts / 4 / alpha) = alpha / sqrt(2 * Ts) * ...
        ((1 + 2 / pi) * sin(pi / 4 / alpha) + ...
        (1 - 2 / pi) * cos(pi / 4 / alpha));

end
