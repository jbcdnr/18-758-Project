%g = oct2dec([367 331 225]);
%nu = 7;

g = oct2dec([34 31 17;
              3 16 15]);
nu = 7;

message = randi([0 1], 1, 60);
coded = channelEncode(message, g, nu);
decoded = channelDecode(coded, g, nu);
if message == decoded
    fprintf('Lookin'' good!\n');
else
    fprintf('Decoded did not match message\n');
    fprintf('Differences: %d\n', sum(abs(message - decoded)));
    abs(message-decoded)
end
coded(104) = 1-coded(104);
coded(4) = 1-coded(4);
coded(24) = 1-coded(24);
coded(27) = 1-coded(27);
decoded = channelDecode(coded, g, nu);
if message == decoded
    fprintf('Lookin'' even better!\n');
else
    fprintf('Decoded could not handle errors\n');
    fprintf('Differences: %d\n', sum(abs(message - decoded)));
end