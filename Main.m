%%Kimberly Winter                       3/12/19
%Main function OFDM

%TODO: Generate message to send through channel using generateMessage
bufferSize=50;

header=generateRand(64*100);
message=generateRand(64);

mess2send=generateMessage(header,message,bufferSize);

%Send message through channel

receivedMess=nonflat_channel(mess2send);

%Estimate H
%Trim header and divide by known header
[correlation,lag] = xcorr(receivedMess,header);
[M,I]=max(abs(correlation));
lagDiff=lag(I);
trimmedMessage=receivedMess(-lagDiff+1:(-1*lagDiff)+length(mess2send));

%TODO: Trim signal and take last 64 samples

%TODO: take FFT of trimmed signal

%TODO: divide by

%Divide Yk/Hk