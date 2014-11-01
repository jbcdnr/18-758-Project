function [message, h0] = equalize(pilot, signal)
% equalize the signal using the pilot sequence at the begining
% and return the following equalized message
% pilot | message | ... -> message_eq | ..._eq

    receivedPilot = signal(1:length(pilot));
    h0 = (pilot .* receivedPilot) / (pilot .* pilot);
    message = signal(length(pilot)+1:length(signal)) / h0;
    
end