% signal timing
txSamplingFrequency =  100 * 10^6; % Hz
rxSamplingFrequency =   25 * 10^6; % Hz
symbolRate          = 12.5 * 10^6; % Hz

% signal parameters
M = 4;        % size of constelation
alpha = 0.25; % SRRC coefficient
txPad = 32;   % extra 0 symbols to transmit on either side of message

% receive paramters
rxUpsample = 4;

% transmit signal sync sequences
freqSync = ones(1, 40);
timingSync = [1 1 0 1 1 0 0 1 1 1 0 1 1 0 1 0 0 1 1 1]*2-1;
frameSync = [0 0 0 0 1 0 0 1 1 1 0 0 0 0 1 1 1 1 1 0 0 0 0 1 1 1 0 0 1 0 0 0 0]*2-1;
pilot = ones(1, 20);
txMessageBits = [0 1 0 1 1 1 0 1 0 1 0 0 0 1 0 0 1 0 1 0 1 0 1 1 1 1 0 1 1 1 0 0 0 0 1 1 0 1 0 1];
txMessageBits = [txMessageBits txMessageBits txMessageBits txMessageBits txMessageBits txMessageBits txMessageBits txMessageBits];
% messageBits = [ 1 0 1 1 1 1 0 0 0 0 1 1 0 0 1 0 0 1 0 1 0 0 1 1 1 1 0 0 1 0 1 1 0 1 0 1 1 0 1 1 0 1 1 1 1 0 0 1 0 1 1 1 0 0 1 0 1 0 1 0 1 1 1 0 0 1 1 0 1 1 0 1 0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 0 1 1 1 1 1 1 1 1 0 0 1 1 0 1 0 0 0 0 0 0 0 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 0 0 1 0 0 0 1 0 1 1 0 0 0 1 1 0 0 1 1 1 1 0 1 1 0 1 1 0 0 0 1 0 0 1 0 0 1 1 0 1 0 0 1 0 0 1 1 1 0 0 0 1 0 0 1 0 1 1 1 1 1 1 0 0 0 1 1 0 0 1 0 0 0 0 0 0 0 1 0 0 1 1 0 0 0 0 1 0 1 1 1 1 1 1 1 0 0 0 1 0 1 1 1 1 1 0 0 1 0 0 0 1 1 1 0 1 1 0 1 0 1 1 0 0 1 0 1 0 0 1 1 1 1 0 1 1 1 1 0 1 1 1 0 0 1 0 0 1 1 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1 1 1 0 1 0 0 1 1 0 0 1 1 0 0 0 0 0 0 1 0 0 1 1 0 ];

% TODO put coding parameters in here too
txCodedBits = channelEncode(txMessageBits);

messageSizeBits = length(txCodedBits);
messageSizeSymb = messageSizeBits / nextpow2(M);
packetSizeInfo = 80; % information symbols