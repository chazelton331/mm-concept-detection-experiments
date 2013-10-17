function featureConcept( nameDescriptors,dir_predictions,collectionFolder,num_classes)
% FeatureConceptAP
%  find the best metrics and store the parameters that guide
%  to it for each combination Feature-Concept.
% Input:
% *nameDescriptors: the name of descriptors
% *dir_predictions,collectionFolder: the folders of data
% *num_classes: the number of concepts

numDescriptors = length(nameDescriptors);

for current_desc=1:numDescriptors
    
    Descname = char(nameDescriptors{current_desc});
    
    vName = ['mIAP','_','results_Top_','all','_','TopN_','all'];
    predictionsDir = [dir_predictions,collectionFolder,cell2mat(nameDescriptors{current_desc})];
    load ([predictionsDir,'/', vName]);
    
    features_iAP=[];
    Concepts=mIAPresultsTable(:,4);
    num_classes = num_classes-1;    
    
    for i= 0:num_classes
        Spec_Concept = find(Concepts==i);
        iAP = mIAPresultsTable(Spec_Concept,5);
        best_iAP = max(iAP);
        iAPs = mIAPresultsTable(:,5);
        position_AP = find(iAPs == best_iAP);
        if size(position_AP,1)>1
            position_AP = position_AP(1,:);
        end
        mIAP(i+1) = best_iAP;
        features_iAP = [features_iAP; mIAPresultsTable(position_AP,:)];
    end
    
    nameSaveExperiments = ['mIAP','_','results_Feature_Concept'];
    save([predictionsDir,'/', nameSaveExperiments],'features_iAP');
    disp(['mIAP for:',Descname,' ',num2str(mean(mIAP))])
    %======================Save best mIAP==================
    nameSavemIAP = ['MiAP','_',Descname];
    save([predictionsDir,'/', nameSavemIAP], 'mIAP');
    
end
end

