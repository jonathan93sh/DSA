%function [ a ] = FSK dekoder( f, fstart, fend )
%FSK DEKODER Summary of this function goes here
%   Detailed explanation goes here
a=' ';
f = [3350 3400 3450 3500 3550];
fstart = 500;
fstop = 16000;

N=length(f);
farray = linspace(fstart, fstop, 256);

f_temp=0;
p=1;
for n = 1:N
   if(f(n)<=fstop)&&(f(n)>=fstart)
       f_temp(p) = f(n);
       p=p+1;
    
   elseif(p>= 2)
       break;
   end
    
   
end
 p=1;
for i = 1:length(f_temp)
    for n = 1:256
       if(f(i)<=farray(n))
           a(p)=char(n-1)
           p=p+1;
           break;
        end
    end
end


