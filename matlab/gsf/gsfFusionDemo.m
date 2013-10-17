% Implementation of Graph Structure Features. This demo computes the top-k
% social dimensions (eigenvectors) and
% After the optimization of top-neighbors, top-k eigenvectors and  C SVM
% parameter and finding the best parameters/concept, demo concatenates the
% eigenvectors/concept and run two different variant
% of learning model methods:
% 1. Linear SVM.
% 2. RBF SVM.
%
% It is used as state-of-the art in Wia2mis 2013 conference:
%
% % @conference{smal_wiamis_13,
%  author = {Mantziou, E. and Papadopoulos, S. and Kompatsiaris, I.},
%  booktitle = {WIAMIS},
%  title = {Large-scale Semi-supervised Learning by Approximate Laplacian Eigenmaps, {VLAD} and Pyramids},
%  year = {2013}
%  }
% The implementation is based on references below.
% References
% [1] S. Papadopoulos, C. Sagonas, Y. Kompatsiaris, A. Vakali. Semi-supervised concept detection by learning the
% structure of similarity graphs. 19th international conference on Multimedia Modeling (MMM 2013),
% accepted for publication.
% [2] P. Jia, J. Yin, X. Huang, D. Hu.  Incremental Laplacian Eigenmaps by preserving adjacent information between
% data points. Pattern Recognition Letters, 30 (16) (2009), pp. 1457–1463
% Version 1.0. Eleni Mantziou. 9/1/12.
clear;clc;

%===================================Set Parameters=========================
nr_splits = 1;                      % in how many splits to splits the dataset. for Validation reasons.
collectionFolder = 'flickr2013/';    % give a name of a folder to save experiments. just a convention
method = 'linear';                  % the training method (linear, rbf and smooth)

% =========================SetPaths========================================
dir_features ='./results/features/';
dir_data = './results/data/';
dir_predictions ='./results/predictions/';
dir_socialDimensions ='./results/socialDimensions/';

% ==========================Set Features===================================
nameDescriptors  = {{'siftpca1024'}};
numDescriptors = length(nameDescriptors);


for current_split=1:nr_splits
    %==========Retrieve the list of images and the groundtruth=========
    
    [trainLabels,testLabels, trainListID, testListID ] = setData(collectionFolder, dir_data,current_split);
    
    
    nr_class = size(trainLabels,2); % the number of concepts
    
    score = [];
    for current_class=1:nr_class
        uuext = [];
        disp(['class: ',current_class]);
        for current_desc=1:numDescriptors
            
            bestparName = 'mIAP_results_Feature_Concept';
            predictionsDir = [dir_predictions,collectionFolder,cell2mat(nameDescriptors{current_desc})];
            load ([predictionsDir,'/', bestparName]);            % load best parameters
            
            % find the social dimension for the current class which extract the
            % best evaluation results
            socialDimnum = features_iAP(current_class,1);
            topN = features_iAP(current_class,2);
            
            vName = ['V_Top_',num2str(socialDimnum),'_','TopN_',num2str(topN)];
            load ([dir_socialDimensions,collectionFolder,cell2mat(nameDescriptors{current_desc}),'/', vName]);
            
            uuext = [uuext socialdim];
        end
        
        switch method
            case 'linear'
                % use linear svm to train the model and extract the prediction
                % score
                % use of liblinear library
                C = 5; % the C parameter in SVM Classifier
                testPrediction = SocioDim(uuext, trainLabels(:,current_class), trainListID,C);
            case 'rbf'
                % use non-linear svm to train the model and extract the prediction
                % score
                % use of libsvm library
                param = ('-c 5 -t 2 -g 0.0008 -q 1'); % the parameter in RBF SVM Classifier
                testPrediction = rbf_svm_parameters(uu, trainLabels(:,current_class), testLabels(:,current_class),trainListID, testListID, param);
        end
        score = [score testPrediction];
    end
    % [0 1]
    %  normalizedpred=normalizeMatrix(score,1);
    
    %==============================Save prediction score=======================
    save([predictionsDir,'/fusion_predSCore'], 'score');
    
    
    %========================Compute the evaluation metrics============
    
    
    AP  = zeros(size(trainLabels,2),1);
    InterPrecisionRecall = zeros(size(trainLabels,2),11);
  
    for j=1:size(testLabels,2)
        [AP(j),InterPrecisionRecall(j,:),~] = statistics(testLabels(:,j),score(:,j)) ;
    end
    
    %----------------------------------------------------------------------
    % uncomment if you want to compute more metrics
    % predictionLabels: according to prediction scores compute the
    % predictionLabels
    % groundtuthLabels: according to testLabels compute the
    % groundtuthLabels
    % [fmeasure, precision, recall ]= compute_precision_recall( groundtuthLabels,predictionLabels );
    
    avgmAP = mean(AP,1);    
    avgmIAP = mean(InterPrecisionRecall(:,1));
end
