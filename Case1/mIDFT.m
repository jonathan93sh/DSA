function [ Xn ] = mIDFT( x )
%MIDFT Summary of this function goes here
%   Detailed explanation goes here

Xn=zeros(1, round(N/2));
for m = 0:round(N/2)-1
    for n = 0:N-1
        Xn(n+1)=(1/N)*(Xn(n+1)+x(m+1)*exp((-j*2*pi*m*n)/N));
    end
end
Xn=abs(Xn);
end


