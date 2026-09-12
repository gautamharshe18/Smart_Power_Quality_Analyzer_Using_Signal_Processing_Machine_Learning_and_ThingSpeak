clc;
clear;
close all;

%% ==========================================
% COMPARE KNN, SVM AND RANDOM FOREST
% ===========================================

load TrainingData.mat

%% Normalize Features

meanValue = mean(features);
stdValue = std(features);

X = (features-meanValue)./stdValue;
Y = labels;

%% Train-Test Split (80-20)

cv = cvpartition(Y,'HoldOut',0.2);

XTrain = X(training(cv),:);
YTrain = Y(training(cv));

XTest = X(test(cv),:);
YTest = Y(test(cv));

fprintf("\n");
disp("===========================================");
disp("TRAINING MACHINE LEARNING ALGORITHMS");
disp("===========================================");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% MANUAL KNN %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp("Running Manual KNN...")

K = 5;

knnPrediction = categorical(strings(length(YTest),1));

tic

for j = 1:length(YTest)

    testPoint = XTest(j,:);

    distances = sqrt(sum((XTrain-testPoint).^2,2));

    [~,idx] = sort(distances);

    nearestLabels = YTrain(idx(1:K));

    knnPrediction(j) = mode(nearestLabels);

end

knnTime = toc;

knnAccuracy = mean(knnPrediction==YTest)*100;

disp("Manual KNN Completed")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% SVM %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp("Training SVM...")

tic

SVMModel = fitcecoc(XTrain,YTrain);

svmPrediction = predict(SVMModel,XTest);

svmTime = toc;

svmAccuracy = mean(svmPrediction==YTest)*100;

disp("SVM Completed")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% RANDOM FOREST %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp("Training Random Forest...")

tic

RFModel = TreeBagger(100,...
    XTrain,...
    YTrain,...
    'Method','classification',...
    'OOBPrediction','On');

rfPrediction = predict(RFModel,XTest);

rfPrediction = categorical(rfPrediction);

rfTime = toc;

rfAccuracy = mean(rfPrediction==YTest)*100;

disp("Random Forest Completed")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(" ")

disp("==============================================")
disp("ALGORITHM COMPARISON")
disp("==============================================")

fprintf("Manual KNN      Accuracy : %.2f %%\n",knnAccuracy);
fprintf("SVM             Accuracy : %.2f %%\n",svmAccuracy);
fprintf("Random Forest   Accuracy : %.2f %%\n",rfAccuracy);

disp("==============================================")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% PRECISION / RECALL %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

knnCM = confusionmat(YTest,knnPrediction);
svmCM = confusionmat(YTest,svmPrediction);
rfCM  = confusionmat(YTest,rfPrediction);

% Macro Precision
knnPrecision = mean(diag(knnCM)./sum(knnCM,1)');
svmPrecision = mean(diag(svmCM)./sum(svmCM,1)');
rfPrecision  = mean(diag(rfCM)./sum(rfCM,1)');

% Macro Recall
knnRecall = mean(diag(knnCM)./sum(knnCM,2));
svmRecall = mean(diag(svmCM)./sum(svmCM,2));
rfRecall  = mean(diag(rfCM)./sum(rfCM,2));

% Macro F1 Score
knnF1 = 2*(knnPrecision*knnRecall)/(knnPrecision+knnRecall);
svmF1 = 2*(svmPrecision*svmRecall)/(svmPrecision+svmRecall);
rfF1  = 2*(rfPrecision*rfRecall)/(rfPrecision+rfRecall);

disp(" ")

disp("Performance Metrics")

fprintf("\nManual KNN")
fprintf("\nPrecision : %.4f",knnPrecision)
fprintf("\nRecall    : %.4f",knnRecall)
fprintf("\nF1 Score  : %.4f\n\n",knnF1)

fprintf("SVM")
fprintf("\nPrecision : %.4f",svmPrecision)
fprintf("\nRecall    : %.4f",svmRecall)
fprintf("\nF1 Score  : %.4f\n\n",svmF1)

fprintf("Random Forest")
fprintf("\nPrecision : %.4f",rfPrecision)
fprintf("\nRecall    : %.4f",rfRecall)
fprintf("\nF1 Score  : %.4f\n\n",rfF1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% EXECUTION TIME %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp("Execution Time")

fprintf("\nManual KNN      : %.4f sec",knnTime)
fprintf("\nSVM             : %.4f sec",svmTime)
fprintf("\nRandom Forest   : %.4f sec\n",rfTime)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% ACCURACY GRAPH %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

bar([knnAccuracy svmAccuracy rfAccuracy])

set(gca,'XTickLabel',{'Manual KNN','SVM','Random Forest'})

ylabel('Accuracy (%)')

title('Accuracy Comparison of ML Algorithms')

grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% TIME GRAPH %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

bar([knnTime svmTime rfTime])

set(gca,'XTickLabel',{'Manual KNN','SVM','Random Forest'})

ylabel('Time (seconds)')

title('Execution Time Comparison')

grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% CONFUSION MATRICES %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
confusionchart(YTest,knnPrediction)
title('Manual KNN')

figure
confusionchart(YTest,svmPrediction)
title('SVM')

figure
confusionchart(YTest,rfPrediction)
title('Random Forest')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% BEST ALGORITHM %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

accuracy = [knnAccuracy svmAccuracy rfAccuracy];

[maxAccuracy,index] = max(accuracy);

algorithmNames = ["Manual KNN","SVM","Random Forest"];

disp(" ")

fprintf("Best Performing Algorithm : %s\n",algorithmNames(index));

fprintf("Best Accuracy             : %.2f %%\n",maxAccuracy);

disp(" ")

disp("Comparison Completed Successfully")