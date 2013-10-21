% Implementation of Graph Structure Features. This demo computes the top-k 
% social dimensions (eigenvectors) and 
% Demo optimize the top-neighbors, the top-k eigenvectors and the C SVM
% parameter and find the best parameters/concept. Then run two different variant
% of learning model methods:
% 1. Linear SVM.
% 2. RBF SVM.
% to find the best metric/concept and finally the average metric for the
% dataset.
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
% [2] L. Tang, H. Liu.  Relational Learning via Latent Social Dimensions. In Proceedings of The 15th ACM SIGKDD 
% Conference on Knowledge Discovery and Data Mining (KDD’09), Pages 817–826, 2009.
% Version 1.0. Eleni Mantziou. 9/1/12.

clear;clc;

%===================================Set Parameters=========================
nr_splits = 1;                      % in how many splits to splits the dataset. for Validation reasons.
collectionFolder = 'flickr2013/';   % give a name of a folder to save experiments. just a convention
method = 'linear';                  % the training method (linear, rbf and smooth)

% =========================SetPaths========================================
dir_features ='./results/features/';
dir_data = './results/data/';
dir_predictions ='./results/predictions/';
dir_socialDimensions ='./results/socialDimensions/';

% ==========================Set Features===================================
nameDescriptors  = {{'siftpca1024'}};
numDescriptors = length(nameDescriptors);


for current_desc=1:numDescriptors
    % ==========================Compute all parameters for tuning==========

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
    % the utility/vec_read.m 
    
    topN =[100,200, 500, 1000, 1500, 2000];          % top-N neighbors
    socialdimsnums = [10,50,100,200,400,500];        % the nunber of Social Dimensions

    optimization(v,topN,socialdimsnums,cell2mat(nameDescriptors{current_desc}),dir_socialDimensions,collectionFolder);
end
% ==========================Tune the parameters============================

experiments(topN,socialdimsnums,nameDescriptors,nr_splits,dir_predictions,dir_data,dir_socialDimensions,collectionFolder,method);
% ==========================Choose the best parameters=====================
featureConcept( nameDescriptors,dir_predictions,collectionFolder,14);



