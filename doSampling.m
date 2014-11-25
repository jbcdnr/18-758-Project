function samples = doSampling(x, nSamples, T_hat, tau_hat, theta_hat,  pulse, centerPulse)
% x         The received signal, after carrier recovery
% alpha     The SRRC coefficient
% T_hat     From timing recovery
% tau_hat   From timing recovery
% theta_hat From timing recovery

    samples = zeros(1, nSamples);

    thePulse = [zeros(1, length(x)) pulse zeros(1, length(x))];
    
    for i = 1:nSamples
        t = (1:length(x)) - tau_hat - i*T_hat + length(x) + centerPulse;
        samples(i) = sum(thePulse(t) .* x.');
    end

    samples = exp(1j * -theta_hat) * samples;

end
