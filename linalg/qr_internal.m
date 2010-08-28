function [Q,R]=qr_internal( A, G, orth_columns )

if nargin<2
    G=[];
end
if nargin<3
    orth_columns=0;
end

if isdiag(G)
    % if G is diagonal this is way faster than using the conjugate Gram
    % Schmidt algorithm
    S=sqrt(diag(G));
    SA=diag(S)*A;
    [SQ,R]=qr_internal( SA, [], orth_columns );
    %Q=diags(1./S)*SQ;
    Q=row_col_mult(SQ,1./S);
    return
end


if isempty(G)
    if orth_columns>0
        n=orth_columns;
        Q1=A(:,1:n);
        s1=sqrt(sum(Q1.^2,1));
        Q1=Q1*spdiags(1./s1(:),0,n,n);
        B=A(:,n+1:end);
        P=B-Q1*(Q1'*B);
        [Q2,R2]=qr(P,0);
        R=[diag(s1), Q1'*B; zeros(size(R2,1),n), R2 ];
        Q=[Q1, Q2];
    else
        [Q,R]=qr(A,0);
    end
else
    [Q,R]=gram_schmidt(A,G,false,1);
end


function bool=isdiag(G)
[r,c]=find( G );
bool=all(r==c) && ~isempty(G);