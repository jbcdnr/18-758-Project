function [cutSignal, index] = doFrameSync(signal, frameSync)
% Find the begining of the frame and return the signal cut at the 
% the beginning

    c = conv(signal, frameSync);
    figure
    plot(real(c))
    title('Convolution peak in frame synchronisation')
    [~, index] = max(real(c));
    cutSignal = signal(index + 1:length(signal));
    
end