function [ c, lags ] = xcorr5000( in1, data1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n=length(data1);
x1 = zeros(1,n);
x1(1:1, 1:length(in1)) = in1';
length(x1)
x2=data1';
lags=[-(n-1):(n-1)];
c=zeros(2*n-1,1);

for i=1:2*n-1
    if(i>n)
        j1=1;
        k1=2*n-i;
        j2=i-n+1;
        k2=n;
    else
        j1=n-i+1;
        k1=n;
        j2=1;
        k2=i;
    end
    c(i)=sum(conj(x1(j1:k1))*x2(j2:k2));
end

c=flipud(c);
