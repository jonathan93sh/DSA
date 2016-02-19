function [ Xm ] = mDFT( x, fstart, fstop, fs, workers, cut )
%MDFT Summary of this function goes here
%   Detailed explanation goes here

poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    parpool('local',workers)
    poolsize = workers;
else
    poolsize = poolobj.NumWorkers;
end

N=length(x);



Xm=zeros(1, round(N/2));
if(cut)
    n_start=round(N*(fstart/fs));
    n_stop=round(N*(fstop/fs));
    if(round(N/2)<n_stop)
        disp('fejl fs er for lille');
        return;
    end
else
    n_start=0;
    n_stop=round(N/2);
end


parfor m = n_start:n_stop
    for n = 0:N-1
        Xm(m+1)=Xm(m+1)+x(n+1)*exp((-j*2*pi*m*n)/N);
    end
end
Xm=abs(Xm);
end

