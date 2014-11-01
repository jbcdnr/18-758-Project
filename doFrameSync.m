function [cutSignal, index] = doFrameSync(signal, frameSync)
% Find the begining of the frame and return the signal cut at the 
% the beginning

    c = conv(signal, frameSync);
    [~, index] = max(real(c));
    cutSignal = signal(index + 1:length(signal));
    
end