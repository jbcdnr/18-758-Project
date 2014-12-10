function [message, h0] = equalize(pilot, signal)
% equalize the signal using the pilot sequence at the begining
% and return the remaining equalized message

    receivedPilot = signal(1:length(pilot));
    h0 = (pilot .* receivedPilot) / (pilot .* pilot);
    message = signal(length(pilot)+1:length(signal)) / h0;
    
    % Plot of the equlalization before, after
    if 0
        figure
        subplot(2,1,1)
        plot(1:length(signal), real(signal), 1:length(signal), imag(signal))
        title('Signal before equalization')
        subplot(2,1,2)
        plot(1:length(signal), real(signal / h0), 1:length(signal), imag(signal / h0))
        title('Signal after equalization')
        pause
    end
end