%%Kimberly Winter                       3/12/19
%Main function OFDM

%Generate message to send through channel using generateMessage
bufferSize=50;

header=generateRand(64*100);
message=generateRand(64);

mess2send=generateMessage(header,message,bufferSize);

%Send message through channel

%plot(real(mess2send));
receivedMess=nonflat_channel(mess2send);

%Estimate H
%Trim header and divide by known header
[correlation,lag] = xcorr(receivedMess,mess2send(1:160));
[M,I]=max(abs(correlation));
lagDiff=lag(I);
receivedMess=receivedMess.';
trimmedMessage=receivedMess(lagDiff+1+50:50+(lagDiff)+length(header)*80/64);
trimmedTotal=receivedMess((lagDiff)+length(header)*80/64+1000+1+50+16:50+16+(lagDiff)+length(header)*80/64+1000+length(message));

%plot(real(receivedMess));
%plot(real(trimmedMessage));
%plot(real(trimmedTotal));

%take FFT of trimmed signal for header
for i=1:(length(trimmedMessage))/80
    final(64*(i-1)+1:64*(i-1)+64)= fft(trimmedMessage((i-1)*80+17:(i-1)*80+80));
end
final(6401:6464)= fft(trimmedTotal);

%Divide Yk/Hk
HEstimate=mean(final(1:6400)./header.');

MessageEstimate=final(6401:6464)/HEstimate;
normalEst=normalize(MessageEstimate);
%plot(real(MessageEstimate));

error=0;
for i=1:length(normalEst)
    if(normalEst(i)~=message(i))
        error=error+1
        i
    end
end