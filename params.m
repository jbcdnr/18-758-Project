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
timingSync = [1 1 1 -0.4352 - 0.4398i  -0.2497 + 0.5485i  -0.0417 - 0.1385i  -0.4626 + 0.6763i  -0.1335 + 0.4968i   0.1663 - 0.1779i 0.5440 + 0.4108i  -0.0505 + 0.4528i   0.5746 - 0.1020i  -0.2389 + 0.1394i   0.5797 + 0.2914i  -0.1767 + 0.3388i 0.6549 + 0.0617i   0.0578 - 0.2724i  -0.6183 - 0.4586i  -0.5870 - 0.0527i  -0.7076 + 0.5985i   0.2059 - 0.7190i -0.6773 - 0.4204i  -0.0649 - 0.5375i  -0.7086 + 0.3275i  -0.2104 + 0.4044i  -0.0914 - 0.0915i  -0.6501 - 0.6495i -0.5897 + 0.1356i  -0.3734 + 0.4923i   0.5152 + 0.6686i  -0.0160 - 0.4034i  -0.3948 + 0.0531i   0.3780 - 0.2198i -0.0559 + 0.2009i   0.6019 - 0.4881i   0.3110 + 0.1121i  -0.0962 + 0.5541i  -0.1542 - 0.4630i   0.1923 + 0.1788i -0.2481 + 0.4369i   0.7203 + 0.6936i  -0.5379 - 0.3861i  -0.6870 + 0.1549i  -0.5613 - 0.1335i   0.5539 + 0.0694i -0.1889 - 0.4206i  -0.0852 + 0.6579i  -0.5422 - 0.0422i   0.5147 - 0.6585i   0.2764 + 0.6908i  -0.3126 - 0.5281i 0.2672 + 0.5905i   0.1599 + 0.5768i  -0.4421 + 0.3669i  -0.2217 - 0.1174i  -0.4965 + 0.4600i   0.1802 + 0.3440i 0.4400 - 0.6241i   0.6501 - 0.0035i   0.3680 + 0.3496i   0.4775 - 0.4954i  -0.0616 + 0.1703i   0.6233 + 0.4832i 0.5703 + 0.1190i   0.1193 + 0.5119i  -0.6708 + 0.5558i  -0.1331 - 0.6686i   0.3550 - 0.4978i  -0.5135 + 0.1528i -0.3541 - 0.2536i  -0.1416 - 0.1350i  -0.1641 + 0.1584i  -0.4804 - 0.4498i  -0.5846 - 0.2550i   0.3888 - 0.3834i 0.3466 + 0.2781i   0.4674 + 0.4730i  -0.2980 - 0.2749i   0.0332 - 0.2519i   0.4786 + 0.4475i   0.0822 - 0.3418i 0.2604 - 0.3841i  -0.0628 - 0.1665i   0.0557 + 0.7091i   0.3681 + 0.6929i  -0.3825 + 0.0412i  -0.6469 + 0.3705i 0.1471 + 0.5151i   0.7042 + 0.6194i  -0.1305 - 0.7206i   0.0590 - 0.4215i  -0.4048 - 0.2512i  -0.5827 + 0.3570i 0.3584 + 0.0624i  -0.2334 + 0.4793i   0.0758 + 0.6598i   0.5665 - 0.2069i   0.0669 - 0.2211i   0.1771 + 0.4278i 0.3546 - 0.5400i   0.4649 - 0.6848i  -0.1234 + 0.3337i   0.4058 - 0.1914i ones(1,10) zeros(1,10)];
pilot = ones(1, 5);

%imageDimension = [66 46];
% imageDimension = [97 68];
imageDimension = [140 98];
imageSize = imageDimension(1) * imageDimension(2);
imageFile = strcat('images/shannon', int2str(imageSize), '.bmp');
txImage = imread(imageFile);
txMessageBits = reshape(txImage, [1 imageSize]);
txMessageBits = [ txMessageBits 0 0];

% channel coding parameters
% rate 1/3
%g = oct2dec([367 331 225]);
%nu = 7;
% rate 2/3
% g = oct2dec([34 31 17; 3 16 15]);
% nu = 7;
% rate 3/4
g = oct2dec([6,1,4,3;3,4,0,7;2,6,7,1]);
nu = 6;

txCodedBits = channelEncode(txMessageBits, g, nu);

messageSizeBits = length(txCodedBits);
messageSizeSymb = messageSizeBits / nextpow2(M);
packetSizeInfo = 120; % information symbols
packetSizeTot = length(pilot) + packetSizeInfo;
