% ------------------------------------------------------------------------
% returns the index of the largest N values in the array
function mink_vals = mink(x,N)

if(length(x)<N); N=length(x); mink_vals=zeros(N,1); end
for ii=1:N
    [mink_vals(ii) min_index]= min(x);
    x(min_index) = +inf;
end
