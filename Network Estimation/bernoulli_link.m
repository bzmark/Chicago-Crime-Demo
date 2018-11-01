function [fx]=bernoulli_link(x)
%bernoulli GLM link function used in full_data_estimate_network
    fx=1./(1+exp(-x));

end
