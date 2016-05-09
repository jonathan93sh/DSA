function [ c, lags ] = xcorr5000(x1, x2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n=length(x1);
lags=[-(n-1):(n-1)];
c=zeros(1,2*n-1);
x1_extend=[zeros(1,n-1) x1 zeros(1,length(x2)-1)];
for i=1:2*n-1
    c(i)=sum(x1_extend(i:i+length(x2)-1).*x2);
end
