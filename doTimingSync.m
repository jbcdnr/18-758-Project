
function [T_hat, tau_hat, theta_hat] = doTimingSync(x, start, timingSync, Fs, T)

    C_hat = 0;
    T_hat = 0;
    tau_hat = 0;
    theta_hat = 0;

    % TODO try more values...?
    for T_prime = [T-1 T T+1]
        nSamples = T_prime*(length(timingSync) + 1);
        timingSignal = applyPulse(timingSync, nSamples, T_prime);
        [C, lag] = xcorr(x, timingSignal);
        figure;
        plot(abs(C));
        title(strcat('T'' = ', num2str(T_prime)));
        [C_max, i_max] = max(C);
        if (C_max > C_hat)
            C_hat = C_max;
            T_hat = T_prime;
            tau_hat = lag(i_max);
            theta_hat = angle(C(i_max));
        end
    end

end