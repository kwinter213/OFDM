%%Generate Message                      3/12/19
%Kimberly Winter

function ifftMess=generateMessage(header, message, bufferSize)
    mess2send=zeros((length(header)+length(message))*(80/64)+2*bufferSize,1);
    totalmessage=[header;message];
    
    for i=1:length(totalmessage)/64
        mess2send(bufferSize+1+(i-1)*64:bufferSize+16+(i-1)*64)=totalmessage(i*64-15:i*64);
        mess2send(bufferSize+17+(i-1)*64:bufferSize+80+(i-1)*64)=totalmessage((i-1)*64+1:i*64);
    end
    
    %IFFT
    ifftMess=ifft(mess2send);
end