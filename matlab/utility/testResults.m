function testResults (numOfConcept,interprec_other,interprec_test,otherScores,smalScores,nr_splits)
% create some plots to compare the results between SMaL test set and SMaL validation set
% or another framework
% Inputs:
% numOfConcept: number of concepts
% *interprec_other: InterPrecisionRecall from SMaL validation set or
% another framework
% *interprec_test: InterPrecisionRecall from SMaL test set
% *otherScores: prediction scores from SMaL validation set or
% another framework
% *smalScores: prediction scores from SMaL test set
% *nr_splits: number of splits from training set
%

%===========================InterPrecisionRecall per concept between SMaL and other===============================
% comparee InterPrecisionRecall/concept for one split between validation and test
% results or between SMaL and state-of-the-art

figure
hold on
bar_array = [interprec_other interprec_test];
range = 1:numOfConcept;
tick = 1:numOfConcept;
bar(bar_array(range,:),1.5);
mycolor=[0 0 0;0.6 0.6 0.6;0.6 0.6 0.6];
colormap(mycolor)
set(gca,'XTick',tick, 'XTickLabel',range)
title('InterPrecisionRecall per concept between SMaL and other')
xlabel('Concepts')
ylabel('mIAP')
legend('InterPrecision other','InterPrecision SMaL', 'Location','NorthWest')
hold off

%====================MiAP/MAP scores between SMaL and other================
% compare results between validation and test results or between SMaL and
% state-of-the-art
% with this plot you can define overfitting
figure
hold on;
bar_scores = [otherScores' smalScores'];
bar(bar_scores);
mycolor=[1 0.5 0;0.8 0.9 1];
colormap(mycolor)
range = 1:nr_splits;   
title('MiAP/MAP scores between SMaL and other')
set(gca, 'XTick',range, 'XTickLabel',range)
legend('mIAP train','mIAP test', 'Location','NorthWest');
hold off;
end




