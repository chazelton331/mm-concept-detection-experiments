function optimization( v,topN,socialdimsnums,descriptor,dir_socialDimensions,collectionFolder)
%  tune distance matrix and similarity matrix for different
%  parameters and social dimension for the maximum parameter for each feature.
%  partitionSocialDims --> compute the other social dimensions for different
%  parameters

% Input:
% *v: the feature vector
% *topN: number of top neighbors
% *socialdimsnums: an array of social dimensions to compute
% *descriptor: the name of descriptor
% *dir_socialDimensions,collectionFolder: the folders of data

socialdimnum = socialdimsnums(numel(socialdimsnums));

 %===================Compute Distance Matrix=============================
   
   distanceStart =tic;
   dist = single(slmetric_pw(double(v'),double(v'),'eucdist'));
   DistanceEnd=toc(distanceStart);
   fprintf('compute Distance matrix %d minutes and %f seconds\n',floor(DistanceEnd/60),rem(DistanceEnd,60));  
   %===================Compute Similarity Matrix=============================
   similarityStart =tic;   
   dist = normalizeMatrix(dist,1);
   simMat = exp(-dist);
   [~,ids] = sort(simMat,2,'descend');
   clear v dist
   for current_topn= 1:length(topN)   
       top = topN(current_topn);
       topNids = ids(:,2:top+1);
       disp('Compute Similarity');
       sparseSimMat = symmetricMatrixFromTop(topNids);
       similarityEnd=toc(similarityStart);
       fprintf('compute Similarity matrix %d minutes and %f seconds\n',floor(similarityEnd/60),rem(similarityEnd,60));
       %===================Compute Similarity Matrix=============================
        socDimStart =tic;
        disp('Compute Social Dimensions');
        [socialdim,~]  = spectralclustering(sparseSimMat,socialdimnum);
        socDimEnd=toc(socDimStart);
        fprintf('compute social dimensions %d minutes and %f seconds\n',floor(socDimEnd/60),rem(socDimEnd,60));
        disp('Save Social Dimensions');
      
        %======================make dir to save Social Dimensions================
        socialDimDir = [dir_socialDimensions,collectionFolder,descriptor];
        if (exist(socialDimDir,'dir')==0)
            mkdir (socialDimDir)
        end
        addpath(dir_socialDimensions);
        addpath(socialDimDir);
        nameSocDimFile = [socialDimDir '/V_Top_',num2str(socialdimnum),'_TopN_',num2str(topN(current_topn))];  
        save(nameSocDimFile,'socialdim');   
        clear sparseSimMat 
   end

    partitionSocialDims(topN,socialdim,socialdimsnums,socialDimDir)
end

