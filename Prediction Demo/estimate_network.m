function A_hat=estimate_network(X,init,lambda,epsilon,iters,p)
% estimate network outputs A_hat of dimension M by M where 
% M-1 is the number of nodes in the network

% A_hat(2:M,1) is the constant bias vector
% A_hat(2:M,2:M) is the estimated network

%inputs: 

% X: training data of dimension M by number of training samples.
%    first row of X must be all ones.

%init: initialization of A
%lambda: regularization parameter
%epsilon: stopping criteria.  stop if loss of successive iterations is
%         within epsilon
%iters: maximum number of iterations if stopping criteria is not met
%p : estimated fraction of events which are observed


[M, T]=size(X);
loss_init=taylor_loss(init,X,lambda,p);
A_hat=init; 

grad_constant=zeros(M);

vec_p=(1/p)*ones(1,M);
vec_p(1)=1;

for t=2:T
        grad_constant=grad_constant+(X(:,t).*vec_p')*(X(:,t-1)'.*vec_p);
        grad_constant=grad_constant-ones(M,1)*(X(:,t-1)'.*vec_p)/2;
end

loss=zeros(1,iters+1);

diff=inf;
kk=1;

%while stopping criteria is not met, perform gradient descent with 
%soft thresholding

while diff>epsilon && kk<iters

    %Calculate gradient at current estimate
    grad=-grad_constant;
    
    %degree 2 term
    grad = grad + 2*A_hat*(X(:,1:T-1).*vec_p')*(X(:,1:T-1)'.*vec_p)/8;
   
    %degree 2 correction
    grad = grad - 2*A_hat.*(ones(M,T-1)*(X(:,1:T-1)'.*X(:,1:T-1)')).*(vec_p.*vec_p-vec_p)/8;
    
    grad=grad/T;

    if kk>1

        r_t=grad-grad_prev;
        alpha=(s_t(:)'*r_t(:))/(s_t(:)'*s_t(:));
        if isnan(alpha)
            alpha=1;
        end
        if alpha<=0
            alpha=.1;
        end
    else
        alpha=1;
    end
    
    accept=false;
    

    while ~accept
        % take gradient step
        A2=A_hat-1/alpha*grad;
        A2=project_l1(A2,M,5);
        
        %perform soft thresholding
        A2=(A2-lambda/alpha).*(A2>=lambda/alpha)+(A2+lambda/alpha).*(A2<=-lambda/alpha);
        loss_temp=taylor_loss(A2,X,lambda,p);
        if kk>1
            accept=(loss_temp<=loss(kk-1));
        else
            accept=(loss_temp<=loss_init);
           
        end
        
        %Backtracking:  if initial step is too large
        %try again with smaller step
        
        if ~accept && alpha<3000
            alpha=alpha*2;
        else
            accept=true;
            s_t=A2-A_hat;
            grad_prev=grad;
            A_hat=A2;
        end
    end
    loss(kk)=loss_temp;
    if kk>1
        diff=abs(loss(kk)-loss(kk-1));
    end
    
    kk=kk+1;
end


end