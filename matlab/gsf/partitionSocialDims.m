function  partitionSocialDims( topN,socialdim,socialdimsnums,dir_socialDimensions )
% Optimize different values of social dimensions for every similarity matrix
% of top-k neighbors

% Input:
% *topN: number of top neighbors
% *socialdim: max social dimension
% *socialdimsnums: an array of social dimensions to compute
% *descriptor: the name of descriptor
% *dir_socialDimensions,collectionFolder: the folders of data

for current_topn=1:length(topN)
    %===================Compute Social Dimensions==========================
    maxsocialdim = socialdim;
    clear socialdim
    for current_socialdim=1:length(socialdimsnums)
        disp('Compute rest of Social Dimensions!');
        
        socialdim = maxsocialdim(:,1:socialdimsnums(current_socialdim));
       
        nameSocDimFile = [dir_socialDimensions '/V_Top_',num2str(socialdimsnums(current_socialdim)),'_TopN_',num2str(topN(current_topn))];
        save(nameSocDimFile,'socialdim');
    end
end
end

