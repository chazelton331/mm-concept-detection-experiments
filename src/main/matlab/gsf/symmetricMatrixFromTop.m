function [ symmetricMatrix ] = symmetricMatrixFromTop( Top )
% Create symmetric matrix from Top
% Input : Top [nSamples x nTop], contain nTop neighbros for nSamples
% Output: symmetricMatrix [nSamples,nSamples]
    
    nSamples   = size(Top,1);
    nNeighbors = size(Top,2);

    tempindex   = Top';
    rowindex    = reshape(tempindex, size(tempindex, 1)*size(tempindex, 2), 1);
    tempindex   = repmat(1:nSamples, nNeighbors, 1);
    columnindex = reshape(tempindex, size(tempindex, 1)*size(tempindex, 2), 1);
    As          = sparse(rowindex, columnindex, 1, nSamples, nSamples);
    
    clear rowindex columnindex;
    A1 = triu(As);
    A1 = A1+A1';
    A2 = tril(As);
    A2 = A2+A2';
    clear As;
    symmetricMatrix = max(A1,A2);
end
