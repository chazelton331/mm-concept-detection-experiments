function [ fmeasure,precision,recall ] = compute_precision_recall( groundtruthLabels, predictionLabels )
% compute the precision recall curve and F1-score
% Input: 
%  *groundtruthLabels: the ground truth labels for test set
% must be in the format: number of cocept/line
%  *predictionLabels: the predicted labels 
% must be in the format: number of cocept/line
fmeasure = [];
precision = [];
recall = [];

for i=1:size(predictionLabels,2)
    idx = find(groundtruthLabels==i);
    tp = length(find(predictionLabels(idx)==i));
    all_pos = length(idx);
    all_pred = length(find(predictionLabels==i));
    prec  =tp/all_pred;
    rec = tp/all_pos;
    precision(i) = prec;
    recall(i) = rec;
    fmeasure(i) = 2*prec*rec/(prec+rec);
end
end

