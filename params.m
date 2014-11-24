% signal timing
txSamplingFrequency =  100 * 10^6; % Hz
rxSamplingFrequency =   25 * 10^6; % Hz
symbolRate          = 12.5 * 10^6; % Hz

% signal parameters
M = 4;        % size of constelation
constelation = zeros(1,M);
for i = 0:M-1
    constelation(i+1) = M_PSK_encode(de2bi(i, nextpow2(M)),M,1);
end
alpha = 0.25; % SRRC coefficient
txPad = 32;   % extra 0 symbols to transmit on either side of message

% receive paramters
rxUpsample = 4;

% transmit signal sync sequences
warmup = ones(1, 250*10^-6 * symbolRate);
freqSync = ones(1, 100);
timingSync = [1 1 0 1 1 0 0 1 1 1 0 1 1 0 1 0 0 1 1 1]*2-1;
frameSync = [0 0 0 0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 1 0 0 0 0 1 1 1 0 0 1 0 0 0 0]*2-1;
pilot = ones(1, 20);

imageDimension = [66 46];
imageSize = imageDimension(1) * imageDimension(2);
imageFile = strcat('images/shannon', int2str(imageSize), '.bmp');
txImage = imread(imageFile);
txMessageBits = reshape(txImage, [1 imageSize]);

% TODO put coding parameters in here too
txCodedBits = channelEncode(txMessageBits);

messageSizeBits = length(txCodedBits);
messageSizeSymb = messageSizeBits / nextpow2(M);
packetSizeInfo = 80; % information symbols
packetSizeTot = length(pilot) + packetSizeInfo;
