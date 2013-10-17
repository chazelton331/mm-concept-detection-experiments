function [ decisionValues ] = rbf_svm_parameters( samples, trainLabels,testLabels, trainID, testID, paramSVM )
% Train SVM and create the prediction scores
% Input: 
%  *samples: matrix which contain all the samples (test & train) 
%  *trainLabels: the labels of training samples
%  *testLabels: the labels of test samples
%  *trainID, test ID: IDs of train and test samples
%  *paramSVM: parameters for SVM
% Output:
%  *decisionValues: the prediction scores for test samples
%

% find train and test samples
samplesTrain = samples(trainID, :);
samplesTest  = samples(testID,:);
% number of classes
numClasses   = size(trainLabels,2);

%train
for i=1:numClasses
	% create y vector for training samples of each class, (-1,1)
    y = -1*ones(size(trainLabels,1), 1);
    y(trainLabels(:, i)==1)=1; 
	% train SVM
    modelClass(i) = svmtrain(y,samplesTrain,paramSVM); 
end

%test 
decisionValues = zeros(size(samplesTest,1),numClasses);

for i=1:numClasses
	disp(['Class ',num2str(i)]);
	% create y vector for testing samples of each class, (-1,1)
    y = -1*ones(size(samplesTest,1), 1);
	y(testLabels(:, i)==1)=1;
	% create decision values 
    [~,~,decisionValues(:,i)] = svmpredict(y,samplesTest,modelClass(i)); 
    decisionValues(:,i) = decisionValues(:,i).*modelClass(i).Label(1);
end

end

