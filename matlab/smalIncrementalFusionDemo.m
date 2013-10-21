% Implementation of Incremental Learning of k-approximate eigenvectors.
% Demo computes the eigenfunctions and eigenvalues from training data
% and compute the training eigenvector. From this eigenvectors, demo
% computes the eigenfunctions and eigenvectors of test data by
% interpolating them.
% For efficient reasons, demo compute the eigenvectos from test data
% in batches (1000 items/batch).
%
% This demo find the k-approximate smallest eigenvectors for every feature
% and concatenate all the eigenvectors. We call this method as "fusion of Laplacian Eigenmaps"
% finally runs three different variant
% of learning model methods:
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
% It is tested in ACM Yahoo Grand Challenge 2013 competition
%
% SmaL uses SIFT/RGB-SIFT VLAD feature aggregation method (and with spatial pyramids)
% and PCA for image representation.
% The implementation of SmaL approach is general and can be applied to any data.
%
% Version 1.0. Eleni Mantziou. 6/1/13.

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

% ==========================Set Features===================================
nameDescriptors  = {{'siftpca1024'}};           % name of features
numDescriptors = length(nameDescriptors);


for current_split=1:nr_splits
    SplitStart = tic;
    uuext=[];
    ddindx=1;
    dd = zeros(k*numDescriptors,k*numDescriptors);
    vOrdered = [];
    num_experiment= num_experiment+1;
    
    %==========Retrieve the list of images and the groundtruth=========
    [trainLabels,testLabels, trainListID, testListID ] = setData(collectionFolder, dir_data,current_split);
    
    for current_desc=1:numDescriptors
        disp(nameDescriptors{current_desc});
        featureFile    = [ dir_features,collectionFolder,cell2mat(nameDescriptors{current_desc})];
        load(featureFile);
        %----------------------------------------------------------------------
        % alternatively you can read txt files. A txt file can
        % be in form of "id vec1 vec2...."
        
        % featureFile    = [dir_features,collectionFolder,cell2mat(nameDescriptors{i}),'.txt'];
        % v = dlmread(featureFile,'',0,1);    % the feature vector
        
        %------------------------------------------------------------------
        % alternatively if the features are in binary format you can use
        % the utility/vec_read.m function
        
        vOrdered = v(trainListID,:);
        vOrdered = [vOrdered;v(testListID,:)];
        
        %------------------------------------------------------------------
        % ======Find bins g and eigenvectors in train set==================
        trainnum = size(trainLabels,1);
        for dim=1:size(vOrdered,2)
            [bins(:,dim),g(:,:,dim),lambdas(:,dim),pp]=numericalEigenFunctions(vOrdered(1:trainnum,dim),sigma);
        end
        
        [ddtrain,uutrain,ii,jj] = eigenfunctionsIncremental(vOrdered(1:trainnum,:),g,lambdas,k,bins);
        
        % % ======Incremental approach in test set in batches================
        vtest = vOrdered(trainnum+1:end,:);       % choose the test set from feature space
        indx = 1;
        uutest = [];                              % test eigenvectors
        numPerBatch = 1000;                     % the number of batches to splt the test set
        batches = round(size(vtest,1)/numPerBatch);    % the number of loops
        
        %============== Interpolation on test batches======================
        BatchesStart = tic;
        fprintf('start batches');
        for i = 1:batches
            
            if mod(size(vtest,1),numPerBatch)~=0    % if the dataset does not diverse it with the numPerBatch
                % we have to compute the reamining items
                if i==batches
                    res = (size(vtest,1)- ((i-1)* numPerBatch )-1);    % the remaining items
                    vtmp = vtest(indx:indx+res,:);
                else
                    vtmp = vtest(indx:indx+999,:);
                end
            else
                vtmp = vtest(indx:indx+999,:);
            end
            
            LOWER = 2.5/100; %% clip lowest CLIP_MARIN percent
            UPPER = 1-LOWER; % clip symmetrically
            for a=1:size(vtmp,2)
                [clip_lower(a),clip_upper(a)] = percentile(vtmp(:,a),LOWER,UPPER);
                q = vtmp(:,a)<clip_lower(a);
                % set all values below threshold to be constant
                vtmp(q,a) = clip_lower(a);
                q2 = vtmp(:,a)>clip_upper(a);
                % set all values above threshold to be constant
                vtmp(q2,a) = clip_upper(a);
            end
            for a=1:k
                bins_out(:,a) = bins(:,jj(a));
                uu1(:,a) = g(:,ii(a),jj(a));
                
                uu2(:,a) = interp1(bins_out(:,a),uu1(:,a),vtmp(:,jj(a)),'linear','extrap');
            end
            suu2 = sqrt(sum(uu2.^2));
            uu2 = uu2 ./ (ones(size(vtmp,1),1) * suu2);
            
            indx=indx+numPerBatch;
            uutest = [uutest;uu2];
            clear uu2
        end
        
        BatchesEnd =toc(BatchesStart);
        fprintf('test batches computed at %d minutes and %f seconds\n',floor(BatchesEnd/60),rem(BatchesEnd,60));
        
        uu  = [uutrain;uutest];
        uuext = [uuext uu];
        dd(ddindx:size(uuext,2),ddindx:size(uuext,2))=ddtrain;
        ddindx = ddindx+k;
        clear uu uutest uutrain suu2 q q2 pp lambdas lambda ii jj g bins bins_out alpha2 Lambda
    end
    %==========================train model===============================
    fprintf('Computing Prediction Score\n');
    predictionStart = tic;
    
    switch method
        case 'linear'
            % use linear svm to train the model and extract the prediction
            % score
            % use of liblinear library
            C = 5;                                 % the C parameter in SVM Classifier
            trainID = (1:trainnum)';
            testID=(trainnum+1:size(uuext,1))';
            score = SocioDim(uuext, trainLabels, trainID, testID,C);
        case 'rbf'
            % use non-linear svm to train the model and extract the prediction
            % score
            % use of libsvm library
            param = ('-c 5 -t 2 -g 0.0008 -q 1');   % the parameter in RBF SVM Classifier
            trainID = (1:trainnum)';
            testID=(trainnum+1:size(uuext,1))';
            score = rbf_svm_parameters(uuext, trainLabels, testLabels,trainListID, testListID, param);
        case 'smooth'
            % use smooth function to train the model and extract the prediction
            % score
            numOflamda = 100;                       % the weight of known samples
            testID=(trainnum+1:size(uuext,1))';
            score = smoothFunction( numOflamda, uuext,ddtrain, trainLabels,testID);
    end
    
    %----------------------------------------------------------------------
    % u can normalize the score
    % ex. in range [-1 1]
    % score = normalizeMatrix(score,4);
    
    %======================make dir to save experiments================
    predictionsDir = [dir_predictions,collectionFolder,'IncrementalSvm\',cell2mat(nameDescriptors{current_desc})];
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
    
    num_experiment= num_experiment+1;
    
end
fprintf('MiAP %6.4f \n',avgmIAP);
fprintf('MAP %6.4f \n',avgmAP);
save([predictionsDir, '\mIAP'],'mIAP');
save([predictionsDir, '\mAP'],'mAP');




