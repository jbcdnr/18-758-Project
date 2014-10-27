function [cutSignal, index] = doFrameSync(signal, frameSync)
% Find the begining of the frame and return the signal cut at the 
% the beginning

    c = conv(signal, frameSync);
    [~, index] = max(c);
    cutSignal = signal(index:length(signal));
    
end