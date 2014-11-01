
function samples = doSampling(x, T_hat, tau_hat, theta_hat)
    % TODO sample dinamically
    nSamples = 10000;
    samples = zeros(1, nSamples);
    phase = exp(1j * theta_hat);

    for i = 1:nSamples
        t = (1:length(x))' - tau_hat - i*T_hat;
        samples(i) = phase * sum(rectpuls(t, T_hat) .* x);
    end

end
