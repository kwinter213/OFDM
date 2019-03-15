%%Kimberly Winter                       3/12/19
%Main function OFDM

%Generate message to send through channel using generateMessage
bufferSize=50;

header=generateRand(64*100);
message=generateRand(64);

mess2send=generateMessage(header,message,bufferSize);

%Send message through channel

receivedMess=nonflat_channel(mess2send);

%Estimate H
%Trim header and divide by known header
[correlation,lag] = xcorr(receivedMess,mess2send(1:160));
[M,I]=max(abs(correlation));
lagDiff=lag(I);
trimmedMessage=receivedMess(lagDiff+1:(lagDiff)+length(mess2send)-(2*bufferSize));

%take FFT of trimmed signal for header
for i=1:(length(mess2send)-(2*bufferSize))/80
    final(64*(i-1)+1:64*(i-1)+64)= ifft(trimmedMessage((i-1)*64+17:(i-1)*64+80));
end

%Divide Yk/Hk
HEstimate=mean(abs(final(1:6400).'./header));

MessageEstimate=final(6401:6464)/HEstimate;
normalEst=normalize(MessageEstimate);

error=0;
for i=1:length(normalEst)
    if(normalEst(i)~=message(i))
        error=error+1
        i
    end
end