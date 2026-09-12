function [knnResult,svmResult,rfResult] = classifyML(V,Fs)

load PowerQualityModel.mat

%% Feature Extraction

testFeature = extractFeatures(V,Fs)';

%% Normalize

trainingFeatures = (features-meanValue)./stdValue;

testFeature = (testFeature-meanValue)./stdValue;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% MANUAL KNN %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = 5;

distances = zeros(size(trainingFeatures,1),1);

for i = 1:size(trainingFeatures,1)

    distances(i)=sqrt(sum((trainingFeatures(i,:)-testFeature).^2));

end

[~,idx]=sort(distances);

nearestLabels = labels(idx(1:K));

knnResult = string(mode(nearestLabels));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% SVM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

svmPrediction = predict(SVMModel,testFeature);

svmResult = string(svmPrediction);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% RANDOM FOREST %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rfPrediction = predict(RFModel,testFeature);

rfResult = string(rfPrediction);

end