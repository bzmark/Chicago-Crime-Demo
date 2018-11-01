function [fx]=partition(x)
%log partition function used in calc_likelihood

    fx=log(1+exp(x));

end
