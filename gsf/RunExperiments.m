function [ AP , InterPrecisionRecall] = RunExperiments( V, trainLabels,testLabels, trainListID, testListID,method)


switch method
    case 'linear'
        % use linear svm to train the model and extract the prediction
        % score
        % use of liblinear library
        C = 5; % the C parameter in SVM Classifier
        score = SocioDim(V, trainLabels, trainListID, testListID,C);
    case 'rbf'
        % use non-linear svm to train the model and extract the prediction
        % score
        % use of libsvm library
        param = ('-c 5 -t 2 -g 0.0008 -q 1'); % the parameter in RBF SVM Classifier
        score = rbf_svm_parameters(V, trainLabels, testLabels,trainListID, testListID, param);
        
end


% [-1 1]
% normpred = normalizeMatrix(score,4);

% compute the AP and the Interpolated Precision Recall
AP  = zeros(size(testLabels,2),1);
InterPrecisionRecall = zeros(size(testLabels,2),11);

for i=1:size(testLabels,2)
    [AP(i),InterPrecisionRecall(i,:),~] = statistics(testLabels(:,i),score(:,i)) ;
end


end

