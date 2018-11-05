function [new_A]=project_l1(A,M,r)
%project A onto the l_1 ball of radius r

new_A=zeros(M,M);
for i=1:M
    a_m=A(i,:);
    if norm(a_m,1)>r
        s=sign(a_m);
        a_m=abs(a_m);
        sorted=sort(a_m,'descend');
        sm=0;
        j=1;
        while j<=M && sorted(j)>((sm+sorted(j)-r)/j)
            sm=sm+sorted(j);
            j=j+1;
        end
        j=j-1;
        theta=(sm-r)/j;
        new_a_m=max(a_m-theta,0);
        a_m=new_a_m.*s;
    end
    new_A(i,:)=a_m;


end
