function samples = doSampling(signal, nSamples, T_hat, tau_hat)

    signal = signal(tau_hat:tau_hat+nSamples*T_hat-1);
    preSamples = reshape(signal, T_hat, nSamples);
    samples = preSamples(1,:);

end
