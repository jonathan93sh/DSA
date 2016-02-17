function [ x ] = IDFT_funktion( X, N )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
x=(0:N-1)*0;
for n = 0:N-1
    for m = 0:N-1
        x(n+1)=x(n+1)+X(m+1)*exp((j*2*pi*m*n)/N);
    end
    x(n+1)=x(n+1)/N;
end

end

