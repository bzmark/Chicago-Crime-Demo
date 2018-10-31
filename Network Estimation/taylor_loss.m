function loss=taylor_loss(A,X,lambda,p)
% taylor_loss computes loss of estimated network A.  
% It is used in the estimate_network routine.

% A: estimated network
% X: data in format (number of nodes +1) by (number of observations)
    % note that in order to estimate a constant bias term nu, first row of
    % X should be all ones.
% lambda: regularization parameter
% p: estimated fraction of events which are observed 


[M, T]=size(X);
loss=0;

vec_p=(1/p)*ones(1,M);
vec_p(1)=1;

%compute data fit part of loss function
for t=1:(T-1)
    for m=1:length(A)
        loss = loss-X(m,t+1)*vec_p(m)*(A(m,:)*(X(:,t).*vec_p')) + A(m,:)*(X(:,t).*vec_p')/2 +(A(m,:)*(X(:,t).*vec_p'))^2/8;
        %degree 2 correction
        loss = loss-sum(A(m,:)'.*X(:,t).*A(m,:)'.*X(:,t).*(vec_p'.*vec_p'-vec_p'))/8;
    end
end

%compute l_1 norm part of loss funciton
l_1=0;
for i=1:length(A)
    for j=1:length(A)
        l_1=l_1+abs(A(i,j));
    end
end

loss=loss+lambda*l_1;

end
