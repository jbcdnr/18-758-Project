% Setting constants

samplingFrequency = 100 * 10^6; % Hz
symbolRate = 12.5 * 10^6; % Hz
n = samplingFrequency / symbolRate; % samples per symbol
M = 2; % size of constelation
r = 0.9;
imageSize = 3036;
imageDimension = [66 46];
lengthFrame = 44;
freqSync = ones(1, 20);
timingSync = [1 1 -1 1 1 -1 -1 1 1 1 -1 1 1 -1 1 -1 -1 1 1 1];
frameSync = [ 0 0 0 0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 1 0 0 0 0 1 1 1 0 0 1 0 0 0 0 ] ; 
pilot = [ 0.3517 + 0.8308i, 0.5853 + 0.5497i, 0.9172 + 0.2858i, 0.7572 + 0.7537i, 0.3804 + 0.5678i, 0.0759 + 0.0540i, 0.5308 + 0.7792i, 0.9340 + 0.1299i, 0.5688 + 0.4694i, 0.0119 + 0.3371i ];

% Creating message from image

messageBits = reshape(imread(strcat('images/shannon', int2str(imageSize), '.bmp')), [1 imageSize]);
messageSymb = M_PSK_encode(messageBits, M, r);
   
padding = mod(length(messageSymb), lengthFrame);

if padding ~= 0
   messageSymb = [ messageSymb, zeros(1, lengthFrame - padding) ];
end

cycles = length(messageSymb) / lengthFrame;
symbols = [freqSync timingSync frameSync zeros(1, (lengthFrame + length(pilot)) * cycles)];
start = length([freqSync timingSync frameSync]) + 1;
Xi = 1:lengthFrame:length(messageSymb);

for i = 1 : cycles
   symbols(start : start + lengthFrame + length(pilot) - 1) = [ pilot messageSymb(Xi(i) : Xi(i) + lengthFrame - 1) ];
   start = start + length(pilot) + lengthFrame;
end

% Creating wave form

nSamples = n*(length(symbols) + 1);
Xi = 1:nSamples;
X = zeros(1, nSamples);

for i = 1:length(symbols)
    t = n*i;
    X = X + symbols(i) * rectpuls(Xi - t, n);
end

plot(Xi, real(X), 'b'); hold on;
plot(Xi, imag(X), 'r'); hold off;

transmitsignal = X;
save('transmitsignal.mat', 'transmitsignal');
