function createSnapshots(score,testListID,nClasses,nPhotosR,dir_data,collectionFolder,fileImages,dir_images,fileConcepts)
% Retrieve images and create snapshots from top-a images
% Inputs:
% *score: the prediction scores
% *testListID: a list of ids belong to test set
% *nClasses: number of concepts
% *nPhotosR: top-a photos to retrieve
% *dir_data,collectionFolder,fileImages,dir_images,fileConcepts: folders
%

%=============================load Image Ids==============================
fid = fopen([dir_data,collectionFolder,fileImages,'.txt']);
Images = textscan(fid,'%s');
fclose(fid);
Images = Images(:)';
%=============================load concepts================================
Concepts= importdata([dir_data,collectionFolder,fileConcepts,'.txt']);

IDtopScores = zeros(nClasses,nPhotosR);

if islogical(testListID)
    testListID_double = +testListID;
    index = find(testListID_double==1);
    [~,ids] = sort(score,1,'descend');
    IDtopScores = ids(1:nPhotosR,:);
    IDtopScores = index(IDtopScores);
else
    [~,ids] = sort(score,1,'descend');
    IDtopScores = ids(1:nPhotosR,:);
    IDtopScores = testListID(IDtopScores);
end


%======================make dir to save retrieved images===================
if (exist(dir_images,'dir')==0)
    mkdir (dir_images)
    addpath(dir_images);
end

dir_snapshots = ('./results/snapshots/');
if (exist(dir_snapshots,'dir')==0)
mkdir (dir_snapshots);
addpath(dir_snapshots);
end

for current_class=1:nClasses
    
    folderN = [dir_snapshots,'Class_',num2str(current_class),'_',Concepts{current_class}];
    mkdir(folderN);
    for current_num=1:nPhotosR
        imgName = strcat(dir_images,Images{IDtopScores(current_num,current_class),:},'.jpg' );
        im = imread(imgName);
        imgNameWrite = [folderN,'\',num2str(current_num),'_',Images{IDtopScores(current_num,current_class),:},'.jpg']
        imwrite(im,imgNameWrite);
    end
end
fprintf('folders of top images/concept created');
end

