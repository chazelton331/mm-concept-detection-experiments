function  decisionValues = smoothFunction( numOflamda, uu,dd, trainLabels, testListID )
% Use Smooth Function alpha to train the model accorfing to eigenvecntors and labeled data
% and create the prediction scores
% implementation of R. Fergus et al. "Semi-Supervised Learning in
% Gigantic Image Collections", NIPS 2009
% Input: 
%  *numOflamda: the weight the labeled data will have 
%  *uu: the eigenvectors
%  *dd: the eigenvalues
%  *trainLabels: the labels of train samples
%  *testListID: the number of points refered to test samples
% Output:
%  *decisionValues: the prediction scores 
%

nPoints = size(uu,1);
lambda=zeros(nPoints,1);
classnr = size(trainLabels,2);
trainvector = size(trainLabels,1);

% Setup positive examples(1), negative examples(-1) from train set and Unlabeled data(0)
labelst = trainLabels;              % train set
labelst(labelst==0)=-1;             % set negative examples to -1 from train set
labels = zeros(nPoints,classnr); 
labels(1:trainvector,:)=labelst;    % In the end we have positive examples(1), negative examples(-1) from train set and Unlabeled data(0)
lambda(1:trainvector,:)=numOflamda;

%----------------------------------------------------------------------
Lambda=diag(lambda);

% Smooth Function alpha
alpha2=(dd +uu'*Lambda*uu)\(uu'*Lambda*labels);
decisionValues=uu*alpha2;           % prediction score

decisionValues =  decisionValues(testListID,:);

end

