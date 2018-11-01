function [ave]=monte_carlo_x(nu,A,previous_x,trials)
%simulate expected number of observed events given network
%and observations at previous time period

M=length(nu);
counts=zeros(M,1);
for i=1:trials
    previous_realization = (rand(M,1)<= previous_x);
    new_odds = bern_link(nu + A*previous_realization);
    counts = counts + (rand(M,1)<=new_odds);
    
end

ave=counts/trials;


end
