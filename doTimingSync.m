function [T_hat, tau_hat, sign] = doTimingSync(sign, timingSync, T, alpha)

% Create the pulse centered
pulseCenterRx = 500;
pulseRx = srrc(-pulseCenterRx:pulseCenterRx, alpha, T);

% calculate expected timing frame
% sign = applyPulse(sign, pulseRx, pulseCenterRx, T);

% correlate that with entire signal
disp('before')
[C, lag] = xcorr(sign, timingSync);
disp('after')

% plot it
figure;
plot(abs(C));
title('Convolution peaks in timing synchronisation');

% find the maximum correlation
[~, i_max] = max(C);
tau_hat = lag(i_max);
T_hat = T;

end