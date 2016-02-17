function [ Xm ] = mDFT( x )
%MDFT Summary of this function goes here
%   Detailed explanation goes here

Xm=zeros(1, round(N/2));
for m = 0:round(N/2)-1
    for n = 0:N-1
        Xm(m+1)=Xm(m+1)+x(n+1)*exp((-j*2*pi*m*n)/N);
    end
end
Xm=abs(Xm);
end

