function [T_hat, tau_hat, theta_hat] = doTimingSync(x, timingSync, T, alpha)
% x          The received signal, after carrier recovery
% timingSync The symbols expected for the timing sync frame
% T          The expected symbol period in samples
% alpha      The SRRC coefficient
% T_hat      The actual symbol period in samples
% tau_hat    The offset of the timing sync frame in x
% theta_hat  Yet another phase correction

    C_hat = 0;
    T_hat = 0;
    tau_hat = 0;
    theta_hat = 0;

    % TODO try more values...?
    T_primes = [T-1 T T+1];

    figure;
    sp = 1;

    for T_prime = T_primes

        % calculate expected timing frame
        timingSignal = applyPulse(timingSync, T_prime, alpha);

        % correlate that with entire signal
        % TODO should search smaller window
        [C, lag] = xcorr(x, timingSignal);

        % plot it
        subplot(length(T_primes), 1, sp);
        sp = sp + 1;
        plot(abs(C));
        title(strcat('Convolution peaks in timing synchronisation (T''=', num2str(T_prime), ')'));

        % find the maximum correlation, and if it is the maximum we've seen
        % so far, record all parameters
        [C_max, i_max] = max(C);
        if (C_max > C_hat)
            C_hat = C_max;
            T_hat = T_prime;
            tau_hat = lag(i_max);
            theta_hat = angle(C(i_max));
        end
    end

end