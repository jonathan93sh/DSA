function [ X ] = DFT_funktion( x, N )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

X=(0:N-1)*0;
for m = 0:N-1
    for n = 0:N-1
        X(m+1)=X(m+1)+x(n+1)*exp((-j*2*pi*m*n)/N);
    end
end

end

