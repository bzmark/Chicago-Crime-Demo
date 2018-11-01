load prediction_demo.mat

fprintf('Stochastic filtering... \n');

[posterior_X,prediction_X]=stochastic_filter(Z_test,nu_unadjusted,A_hat_unadjusted,1);
[posterior_Z,prediction_Z]=stochastic_filter(Z_test,nu_adjusted,A_hat_adjusted,.75);

fprintf('Estimated test period murders using A_hat_adjusted (adjusting for missing data):'); 
disp(round(sum(sum(posterior_Z))));
newline;

fprintf('Estimated test period murders using A_hat_unadjusted (ignoring missing data):'); 
disp(round(sum(sum(posterior_X))));
newline;

fprintf('Actual number of test period murders:'); 
disp(round(sum(sum(X_test))));
newline;

fprintf('Displaying results... \n');

k = 2;

h = fspecial('gaussian',[1,50],2);
h2 = fspecial('gaussian',[1,20],2);
true_full = X_test(k,2:end);
true_missing = Z_test(k,2:end);
smooth_full = conv(true_full,h,'same');
smooth_missing = conv(true_missing,h,'same');
pred_X = conv(prediction_X(k,2:end),h2,'same');
pred_Z = conv(prediction_Z(k,2:end),h2,'same');


figure(2);clf;
b =5;
subplot(211);
plot([pred_X(b:end-b)/.75;pred_Z(b:end-b)]','linewidth',2)
xlabel('Week')
ylabel('Likelihood')
set(gca,'fontsize',24)
legend(['Smoothed predicted event likelihood, A_{Z,1}'],...
   ['Smoothed predicted event likelihood, A_{Z,.75}'],...
   'location','northoutside','orientation','horizontal')
ax = axis;ax(1) = 1; ax(2) = length(pred_X(b:end-b));axis(ax);
subplot(212);
plot(([smooth_full(b:end-b);smooth_missing(b:end-b)]'),'linewidth',2)
legend('Smoothed true events','Smoothed observed events',...
   'location','northoutside','orientation','horizontal')
xlabel('Week')
ylabel('Frequency')
set(gca,'fontsize',24)
ax = axis;ax(1) = 1; ax(2) = length(pred_X(b:end-b));axis(ax);





