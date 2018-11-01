function loss=full_data_loss(A,X,lambda,T)
% full_data_loss computes loss of an estimated network A using MLE with an 
% l_1 penalization term for the Bernoulli autoregressive model

% A: estimated network
% X: data in format (number of nodes +1) by (number of observations)
    % note that in order to estimate a constant bias term nu, first row of
    % X should be all ones.
% lambda: regularization parameter
% T: number of observations


loss=0;

%compute data fit part of loss function
for t=1:(T-1)
    for m=1:length(A)
        loss=loss+partition(A(m,:)*X(:,t))-X(m,t+1)*(A(m,:)*X(:,t));
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
