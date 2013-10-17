function experiments(topN,socialdimsnums,nameDescriptors,nr_splits,dir_predictions,dir_data,dir_socialDimensions,collectionFolder,method,C)
% Run all the features with different TopN (top-k neighbors), Social Dimension and C (for
%  SVM) to tune the parameters
%  and extract evaluation metrics for different dataset splits for each concept for every combination.
% This code should be used in order to extract the best parameters and then fuse them.

% Input:
% *topN: number of top neighbors
% *nameDescriptors: the name of descriptors
% *nr_splits: how many splits to use for the dataset
% *dir_predictions,dir_data,dir_socialDimensions,collectionFolder: the folders of data
% *C: the SVM parameter



numSocialDim = length(socialdimsnums);
numTopN = length(topN);

if nargin ==9
    C = 5;
end

mAPresultsTable = [];
mIAPresultsTable = [];

numDescriptors = length(nameDescriptors);


experimentsStart =tic;
disp ('Start Running tuning Experiment!');


for current_desc=1:numDescriptors
    disp(current_desc)
    for current_k=1:numSocialDim
        disp(['Social Dimension:',num2str(socialdimsnums(current_k))]);
        
        for current_TopN= 1:numTopN
            disp(['Top N neighbor:',num2str(topN(current_TopN))]);
            for current_C= 1:length(C)
                % load social dimensions
                vName = ['V_Top_',num2str(socialdimsnums(current_k)),'_','TopN','_',num2str(topN(current_TopN))];
                load ([dir_socialDimensions,collectionFolder,cell2mat(nameDescriptors{current_desc}),'/', vName]);
                
                AP =cell( zeros(nr_splits));
                InterPrecisionRecall = cell(zeros(nr_splits));
                
                %======================make dir to save experiments================
                predictionsDir = [dir_predictions,collectionFolder,cell2mat(nameDescriptors{current_desc}),'/'];
                if (exist(predictionsDir,'dir')==0)
                    mkdir (predictionsDir)
                end
                addpath(dir_predictions);
                addpath(predictionsDir);
                
                for current_split=1:nr_splits
                    disp(['Dataset:',num2str(current_split)]);
                    [trainLabels,testLabels, trainListID, testListID ] = setData(collectionFolder, dir_data,current_split);
                    [AP{current_split},  InterPrecisionRecall{current_split}] = RunExperiments(socialdim ,trainLabels,testLabels, trainListID, testListID,method);
                    disp(num2str(mean(cell2mat(InterPrecisionRecall(:,current_split)))));
                    
                end
                
                avgAP = mean(cell2mat(AP),2);
                
                avgmIAP = mean(cell2mat(InterPrecisionRecall),2);
                disp(mean(avgmIAP));
                
                class_nr = size(avgmIAP,1);
                
                socdim_nr = socialdimsnums(current_k)*ones(class_nr,1);
                topN_val = topN(current_TopN)*ones(class_nr,1);
                C_val = C(current_C)*ones(class_nr,1);
                class_nr_val = 0:class_nr-1;
                
                tmpmAPresultsTable = [socdim_nr topN_val C_val class_nr_val' avgAP];
                mAPresultsTable = [mAPresultsTable; tmpmAPresultsTable];
                
                tmpmIAPresultsTable = [socdim_nr topN_val C_val class_nr_val' avgmIAP];
                mIAPresultsTable = [mIAPresultsTable;tmpmIAPresultsTable];
                
                %======================Save tuned metrics================== 
                if current_TopN == numTopN && current_k == numSocialDim
                    nameSaveExperiments = ['mIAP','_','results_Top_','all','_','TopN_','all'];
                    save([predictionsDir nameSaveExperiments],'mIAPresultsTable');
                    nameSaveExperiments = ['mAP','_','results_Top_','all','_','TopN_','all'];
                    save([predictionsDir nameSaveExperiments],'mAPresultsTable');
                end      
            end
        end
    end
    mIAPresultsTable=[];
    mAPresultsTable = [];
end

experimentsEnd= toc(experimentsStart);
fprintf('Tuning of parameters computed at %d minutes and %f seconds\n',floor(experimentsEnd/60),rem(experimentsEnd,60));
end

