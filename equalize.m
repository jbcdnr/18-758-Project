function [message, h0] = equalize(pilot, signal)
% equalize the signal using the pilot sequence at the begining
% and return the following equalized message
% pilot | message | ... -> message_eq | ..._eq

    receivedPilot = signal(1:length(pilot));
    h0 = (pilot .* receivedPilot) / (pilot .* pilot);
    message = signal(length(pilot)+1:length(signal)) / h0;
    
    if 0
        figure
        subplot(2,1,1)
        plot(1:length(signal), real(signal), 1:length(signal), imag(signal))
        subplot(2,1,2)
        plot(1:length(signal), real(signal / h0), 1:length(signal), imag(signal / h0))
        pause
    end
end