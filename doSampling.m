function samples = doSampling(x, alpha, nSamples, T_hat, tau_hat, theta_hat)
% x         The received signal, after carrier recovery
% alpha     The SRRC coefficient
% T_hat     From timing recovery
% tau_hat   From timing recovery
% theta_hat From timing recovery

    if nSamples == -1
        nSamples = floor((length(x) - tau_hat) / T_hat);   
    end
    samples = zeros(1, nSamples);

    for i = 1:nSamples
        t = (1:length(x))' - tau_hat - i*T_hat;
        samples(i) = sum(srrc(t, alpha, T_hat) .* x);
    end

    samples = exp(1j * -theta_hat) * samples;

end
