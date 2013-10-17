function [trainLabels,testLabels, trainListID, testListID ] = setData(folder, dir_data,current_split)
% setup Annotation set and how we should split out dataset in case of
% validation reasons

switch folder
    case 'imageclef/'
        %CLEF2012
        load ([dir_data,folder, 'allLabels']);  % Annotation set
        load ([dir_data,folder, 'trainList',num2str(current_split)]); % the number of lines to use as training set
        load ([dir_data,folder 'testList',num2str(current_split)]);   % the number of lines to use as test set
        
        trainLabels = allLabels(trainListID,:);
        testLabels =allLabels(testListID,:);
    case 'flickr2013/'
        %flickr2013
        labels = dlmread([dir_data,folder,'annotation.txt'],'',0,1);
        %         load ([dir_data,folder, 'allLabels']);  % Annotation set
        load ([dir_data,folder, 'trainList',num2str(current_split)]); % the number of lines to use as training set
        load ([dir_data,folder 'testList',num2str(current_split)]);   % the number of lines to use as test set
        
        trainLabels = labels(trainListID,:);
        testLabels =labels(testListID,:);
    case 'twitter2013/'
        %twitter2013
        labels = dlmread([dir_data,folder,'annotation.txt'],'',0,1);
        load ([dir_data,folder, 'trainList',num2str(current_split)]); % the number of lines to use as training set
        load ([dir_data,folder 'testList',num2str(current_split)]);   % the number of lines to use as test set
        
        trainLabels = labels(trainListID,:);
        testLabels =labels(testListID,:);
end
if size(testListID,1)==1 ||size(trainListID,1)==1
    trainListID = trainListID';
    testListID = testListID';
end
end



