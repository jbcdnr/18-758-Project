function [t, f, Z] = DTFT(z, Fs, n)
%DTFT Computes the DTFT of a signal with proper units

    L = length(z);
    L2 = pow2(n + nextpow2(L));
    t = (0:L-1) / Fs;
    f = (-L2/2:L2/2-1) * (Fs / L2);
    Z = fftshift(fft(z, L2)) * 2 / L;

end

