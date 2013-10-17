function [ mat ] = normalizeMatrix( mat, flag )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if flag==1
% [0 1]
    for i=1:size(mat,2)
       mat(:,i) = (mat(:,i) - min(mat(:,i)))/(max(mat(:,i))-min(mat(:,i)));         
    end
    
elseif flag==2
    for i=1:size(mat,2)
       mat(:,i) = mat(:,i) - mean(mat(:,i))/std(mat(:,i));         
    end
    
elseif flag==3
    mat = (mat - min(min(mat)))./(max(max(mat))-min(min(mat)));
    
elseif flag==4
% [-1 1]
    for i=1:size(mat,2)
        mat(:,i) = (mat(:,i) -2* min(mat(:,i)))/(max(mat(:,i))-min(mat(:,i)));
    end

end


end

