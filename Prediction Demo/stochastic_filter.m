function [X,prediction]=stochastic_filter(Z,nu,A,p)
%use stochastic filtering to estimate p(x_n|z_1,...,z_{n-1})
%and p(x_n|z_1,...,z_n)

%outputs are
%X: M by T matrix where X_{i,j} is an estimate of 
    %p(x_{i,j}=1|z_1,...,z_j)
%prediction: M by T matrix where X_{i,j} is an estimate of 
    %p(x_{i,j}=1|z_1,...,z_{j-1})
    
%inputs are
%Z: M by T matrix of observed data
%nu: constant bias term
%A: network
%p: estimated fraction of events which are observed

[M,T]=size(Z);
X=zeros(M,T);
X(:,1)=Z(:,1);
prediction=zeros(M,T);
for t=2:T
   %compute p(x_n)=\int p(x_n|x_n-1) F(x_n-1)
   px=monte_carlo_x(nu,A,X(:,t-1),10000);
   prediction(:,t)=px;
   %compute F(x_n)=p(x_n)*L(z_n|x_n)

   %compute F(x_n|z_n=0)
   normalization_constant=px*(1-p)+1-px;
   F_t=(px*(1-p))./normalization_constant;
   %ensure that F(x_n|z_n=1)=1
   F_t=max(F_t,Z(:,t));
   
   X(:,t)=F_t;
   
    
    
end




end
