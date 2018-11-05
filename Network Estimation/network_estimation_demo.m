load data.mat


p=.75; %estimated fraction of events which are observed
iters=20; %max iters used when estimating networks
tol=1e-3; %stopping criteria for estimating networks. stop if losses
          %from consecutive iterations are within tol
lambda=.5/sqrt(1000); %regularization paramter
M=9; %number of nodes in network
init=zeros(M+1,M+1); %initialization of network
[num_areas,num_weeks]=size(homicides_X); 


%display homicides_X
imagesc(homicides_X);
xlabel('Weeks (starting Jan 2001)');
ylabel('Community Area');
set(gca,'fontsize', 24)


%consider modified version of X containing only the nine community areas
%which recordered over 300 murders 

[~,high_crime]=sort(sum(homicides_X,2),'descend');
high_crime=sort(high_crime(1:9));
X=zeros(9,num_weeks);
Z=zeros(9,num_weeks);
for i=1:9
   X(i,:)=homicides_X(high_crime(i),:);
   Z(i,:)=homicides_Z(high_crime(i),:);
end





%split into train set and test set
X_train=[ones(1,600);X(:,1:600)];
X_test=X(:,601:918);
Z_train=[ones(1,600);Z(:,1:600)];
Z_test=Z(:,601:918);


fprintf('Estimating networks... \n');

%estimate network adjusting for missing data
adjusted=estimate_network(Z_train,init,lambda,tol,iters,p);
nu_adjusted=adjusted(2:M+1,1);
A_hat_adjusted=adjusted(2:M+1,2:M+1);
%estimate network without adjusting for missing data
unadjusted=full_data_estimate_network(Z_train,init,lambda,tol,iters);
nu_unadjusted=unadjusted(2:M+1,1);
A_hat_unadjusted=unadjusted(2:M+1,2:M+1);

adjusted_likelihood=calc_likelihood(nu_adjusted,A_hat_adjusted,X_test);
unadjusted_likelihood=calc_likelihood(nu_unadjusted,A_hat_unadjusted,X_test);

fprintf('Likelihood on complete data test set using A_hat_adjusted (adjusting for missing data):'); 
disp(adjusted_likelihood);
newline;

fprintf('Likelihood on complete data test set using A_hat_unadjusted (ignoring missing data):'); 
disp(unadjusted_likelihood);
newline;






