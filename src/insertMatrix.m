function S = insertMatrix(B,b)

%INPUT: B: Bigger matrix % b: small matrix that needs to put inside bigger matrix, B 
%OUTPUT: R: Resultant matrix % Example: % B=zeros(10,10); b=ones(5,5); % R=insertMatrix(B,b);

[P,Q,R]=size(B);

fx=floor(P/2)-floor(size(b,1)/2);

fy=floor(Q/2)-floor(size(b,2)/2);

S=B;

for s = 1:size(b,3)    
    for p=1:size(b,1)
        for q=1:size(b,2)
            
            S(fx+p,fy+q,s)=b(p,q,s);
        end
    end
end
S = uint8(S);
end

