function likelihood=calc_likelihood(nu,A,data)
% compute the log likelihood of observing data given constant bias vector
% nu and network A 

[M,T]=size(data);
likelihood=0;
%loss_vec=zeros(M,1);
for m=1:M
    for t=1:(T-1)
        f=nu(m)+A(m,:)*data(:,t);
        likelihood=likelihood+data(m,t+1)*f-partition(f);
        %loss_vec(m)=loss_vec(m)+data(m,t+1)*f-partition(f);
    end
end
end