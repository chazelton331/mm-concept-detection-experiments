% Demo for SMaL (Scalable Manifold Learning) framework on top
% of ALE for eigenfunction method for computing approximate
% eigenvectors of graph Laplacian.
%
% This demo find the k-approximate eigenvectors
% and runs three different variant of learning model methods:
% 1. Linear SVM.
% 2. RBF SVM.
% 3. Smooth Function
%
% The code is ready to run for flickr2013 (included ulr file) and twitter2013 datasets.
% You can download the datasets from
% 1. flickr2013: http://www.socialsensor.eu/datasets/mm-concept-detection-dataset-2013/mm-concept-detection-datasets.zip
% 2. twitter2013: http://www.socialsensor.eu/datasets/mm-concept-detection-dataset-2013/mm-concept-detection-twitter2013-images.zip
%      password: socialsensor
%
% It is tested in ImageCLEF2012, ACM Yahoo Grand Challenge 2013 competition and MediaEVal 2013 
% competition, SED task Challenge 2.
%
% SmaL uses SIFT/RGB-SIFT VLAD feature aggregation method (and with spatial pyramids)
% and PCA for image representation.
% The implementation of SmaL approach is general and can be applied to any data.
%
% If you do use this code in your paper, please cite our paper. For your
% convenience, here is the bibtex:
%
% @conference{smal_wiamis_13,
%  author = {Mantziou, E. and Papadopoulos, S. and Kompatsiaris, I.},
%  booktitle = {WIAMIS},
%  title = {Large-scale Semi-supervised Learning by Approximate Laplacian Eigenmaps, {VLAD} and Pyramids},
%  year = {2013}
%  }
%
% Version 1.0. Eleni Mantziou. 1/17/13.

clear;clc;
%===================================Set Parameters=========================
k = 500;                            % number of eigenvectors
sigma = 0.2;                        % controls affinity in graph Laplacian, how strong connected the edges are
num_experiment=1;                   % holds the number of experiment to be saved
nr_splits = 1;                      % in how many splits to splits the training dataset. for Validation reasons.
collectionFolder = 'flickr2013/';   % give a name of a folder to save experiments. just a convention
method = 'linear';                  % the training method (linear, rbf and smooth)

% =========================SetPaths========================================
dir_features ='./results/features/';
dir_data = './results/data/';
dir_predictions ='./results/predictions/';
dir_images = './results/images/';

% ==========================Set Features===================================
nameDescriptors  = {{'siftpca1024'}};
numDescriptors = length(nameDescriptors);

% =========================================================================
for current_desc=1:numDescriptors
    disp(nameDescriptors{current_desc});
    featureFile    = [ dir_features,collectionFolder,cell2mat(nameDescriptors{current_desc})];
    load(featureFile);                    % v: feature vector
    %----------------------------------------------------------------------
    % alternatively you can read txt files. A txt file can
    % be in form of "id vec1 vec2...."
    
    % featureFile    = [dir_features,collectionFolder,cell2mat(nameDescriptors{i}),'.txt'];
    % v = dlmread(featureFile,'',0,1);    % the feature vector
    
    %----------------------------------------------------------------------
    % alternatively if the features are in binary format you can use
    % the utility/vec_read.m function
    
    mAP = zeros(nr_splits,1);
    mIAP = zeros(nr_splits,1);
    for current_split=1:nr_splits
        SplitStart = tic;
        %==========Retrieve the list of images and the groundtruth=========
        [trainLabels,testLabels, trainListID, testListID ] = setData(collectionFolder, dir_data,current_split);
        
        %==compute approximate eigenvectors using eigenfunction approach===
        eigenfunctionStart =tic;
        % uu                        : the eigenvectors
        % dd                        : the eigenvalues
        [dd,uu] = eigenfunctions(v,sigma,k);
        eigenfunctionEnd= toc(eigenfunctionStart);
        fprintf('Eigenvectors computed at %d minutes and %f seconds\n',floor(eigenfunctionEnd/60),rem(eigenfunctionEnd,60));
        
        %==========================train model===============================
        fprintf('Computing Prediction Score\n');
        predictionStart = tic;
        
        switch method
            case 'linear'
                % use linear svm to train the model and extract the prediction
                % score
                % use of liblinear library
                C = 5; % the C parameter in SVM Classifier
                score = SocioDim(uu, trainLabels, trainListID, testListID,C);
            case 'rbf'
                % use non-linear svm to train the model and extract the prediction
                % score
                % use of libsvm library
                param = ('-c 5 -t 2 -g 0.0008 -q 1'); % the parameter in RBF SVM Classifier
                score = rbf_svm_parameters(uu, trainLabels, testLabels,trainListID, testListID, param);
            case 'smooth'
                % use smooth function to train the model and extract the prediction
                % score
                numOflamda = 100;                       % the weight of known samples
                score = smoothFunction( numOflamda, uu,dd, trainLabels,testListID);
        end
        
        %----------------------------------------------------------------------
        % u can normalize the score
        % ex. in range [-1 1]
        % score = normalizeMatrix(score,4);
        
        %======================make dir to save experiments================
        predictionsDir = [dir_predictions,collectionFolder,cell2mat(nameDescriptors{current_desc})];
        if (exist(predictionsDir,'dir')==0)
            mkdir (predictionsDir)
        end
        addpath(dir_predictions);
        addpath(predictionsDir);
        
        save([predictionsDir, '\predictionScore_', num2str(num_experiment),'split_',num2str(current_split)],'score');
        predictionEnd =toc(predictionStart);
        fprintf('train SVM computed at %d minutes and %f seconds\n',floor(predictionEnd/60),rem(predictionEnd,60));
        
        %========================Compute the evaluation metrics============
        
        
        AP  = zeros(size(trainLabels,2),1);
        InterPrecisionRecall = zeros(size(trainLabels,2),1);
        precistionStart=tic;
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
        mAP(current_split) =avgmAP;
        avgmIAP = mean(InterPrecisionRecall(:,1));
        mIAP(current_split) =avgmIAP;
        
        num_experiment= num_experiment+1;
        SplitEnd =toc(SplitStart);
        fprintf('procedure computed at %d minutes and %f seconds\n',floor(SplitEnd/60),rem(SplitEnd,60));
    end
    fprintf('MiAP %6.4f \n',avgmIAP);
    fprintf('MAP %6.4f \n',avgmAP);
    save([predictionsDir, '\mIAP',cell2mat(nameDescriptors{current_desc})],'mIAP');
    save([predictionsDir, '\mAP',cell2mat(nameDescriptors{current_desc})],'mAP');
end

%----------------------------------------------------------------------
% In this part examine the behavior of results by image snapshots
% and creating plots 
% for demonstration reason we have commented some of these tests.
% you can select anything you find useful.

%=========1. Retrieve Images & Create snapshots===========
%----------------------------------------------------------------------
% uncomment if you want to retrieve images
        
% fileImages = 'TheIDs';          % the name of image ids file. should be in txt format
% fileConcepts = 'concepts';      % the name of concepts file. should be in txt format
% nPhotosR = 20;                  % number of top-n photos to retrieve
% 
% createSnapshots(score,testListID,size(score,2),nPhotosR,dir_data,collectionFolder,fileImages,dir_images,fileConcepts);

%=========2. Create Plots===========
%----------------------------------------------------------------------
% uncomment if you want to extract plots
% InterPrecisionRecall_other        %InterPrecisionRecall_other of another
% framework or validation set
% score_other                       %prediction scores of another
% framework or validation set
% testResults (size(testLabels,2),InterPrecisionRecall_other,InterPrecisionRecall,score_other,score,nr_splits);


