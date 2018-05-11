function [ cdata ] = compressToMinLen(data,minlen)
%Returns compressed data to minlen

len = length(data);

if len == minlen
    cdata = data;
else
   
    diff = len - minlen;
    seq = uint8(linspace(1,len,minlen));
    cdata = data(seq,:);
    
    
    
end


end

