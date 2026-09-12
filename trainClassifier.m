clc;
clear;

%% Load Training Dataset

load TrainingData.mat

disp("-----------------------------------------")
disp("Training Machine Learning Models")
disp("-----------------------------------------")

%% ===========================
% Normalize Features
%% ===========================

meanValue = mean(features);
stdValue = std(features);

featuresNormalized = (features - meanValue)./stdValue;

%% ===========================
% Train SVM
%% ===========================

disp("Training SVM...")

SVMModel = fitcecoc(featuresNormalized,labels);

disp("SVM Training Completed")

%% ===========================
% Train Random Forest
%% ===========================

disp("Training Random Forest...")

RFModel = TreeBagger(100,...
                     featuresNormalized,...
                     labels,...
                     'Method','classification',...
                     'OOBPrediction','On');

disp("Random Forest Training Completed")

%% ===========================
% Save Everything
%% ===========================

save PowerQualityModel.mat ...
     features ...
     labels ...
     meanValue ...
     stdValue ...
     SVMModel ...
     RFModel

disp("-----------------------------------------")
disp("Power Quality Models Saved Successfully")
disp("-----------------------------------------")
disp("Models Available:")
disp("1. Manual KNN")
disp("2. SVM")
disp("3. Random Forest")