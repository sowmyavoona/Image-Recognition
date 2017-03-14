% A word from Jesse: Loading database is a common step in testing, so I
% saved the variables and loaded them from there. This helps skipping this
% first part of the code. From second time, please run from the next
% section.

nsubjects = 15; %nc
nsamples = 11; %ts
ntrain = 2; %nstr
ntest = 9; %nsts
normalizeFlag = 1;
%folder_name = 'C:\Users\Ganesh\Documents\sowmya\projects\faceRecognition\Datasets\grimace_database';
%folder_name = 'C:\Users\Ganesh\Documents\sowmya\projects\faceRecognition\Datasets\Dataset';
folder_name = 'C:\Users\Ganesh\Documents\sowmya\projects\faceRecognition\jesseDatasets\yalefaces_edited';
%folder_name = uigetdir('', 'Select training images path');

%% load database
[loaddb_train, loaddb_test, folder_name, row, col, ext, trainLabel, testLabel] = load_database(folder_name, nsubjects, ntrain, ntest, nsamples);

save Variables/loaddb_train.mat loaddb_train;
save Variables/loaddb_test.mat loaddb_test;
save Variables/folder_name folder_name;
save Variables/row row;
save Variables/col col;
save Variables/ext ext;
save Variables/trainLabel trainLabel;
save Variables/testLabel testLabel;
save Variables/nsubjects nsubjects;
save Variables/nsamples nsamples;
save Variables/ntrain ntrain;
save Variables/ntest ntest;

%%
load Variables/normalized_train;
load Variables/normalized_test;
load Variables/loaddb_train;
load Variables/loaddb_test;
load Variables/folder_name;
load Variables/row;
load Variables/col;
load Variables/ext;
load Variables/trainLabel;
load Variables/testLabel;
load Variables/nsubjects;
load Variables/nsamples;
load Variables/ntrain;
load Variables/ntest;

%% normalize

if(normalizeFlag == 1)
    normalized_train = normalize(loaddb_train);
    normalized_test = normalize(loaddb_test);
elseif(normalizeFlag == 0)
    normalized_train = (loaddb_train);
    normalized_test = (loaddb_test);
end

save Variables/normalized_train.mat normalized_train;
save Variables/normalized_test.mat  normalized_test;

%%
load Variables/normalized_train;
load Variables/normalized_test;

%% gabor train

tic;
%[train, test] = gabor_train(nsubjects, ntrain, ntest, loaddb_train, loaddb_test, row, col, trainLabel);
[train, test] = gabor_train(nsubjects, ntrain, ntest, normalized_train, normalized_test, row, col, trainLabel);
time = toc;
% train = double(train);
% test = double(test);
save Variables/gabor_train train
save Variables/gabor_test test

disp(strcat('gabor train completed in _', num2str(time)));

%% 

load Variables/gabor_train;
load Variables/gabor_test;

%% SVM
svmTrainLabel = transpose(trainLabel);
svmTrain = transpose(train);
svmTest = transpose(test);
incorrectSVM = [];
svmRecognized = [];
%SVMModel = fitcsvm(svmTrain,svmTrainLabel,'KernelFunction','rbf','Standardize',true,'ClassNames',{'1','2'});
Mdl = fitcecoc(svmTrain,svmTrainLabel);
[svmLabel,svmScore] = predict(Mdl,svmTest);
svmLabel = transpose(svmLabel);
svmPercent = 0;

for i = 1: size(testLabel,2)
    if(svmLabel(1,i) == testLabel(1,i))
        svmPercent = svmPercent + 1;
    else
        incorrectSVM = [incorrectSVM;[i,svmLabel(1,i),testLabel(1,i)]];
    end
     svmRecognized = [svmRecognized; [i, svmLabel(1,i), testLabel(1,i)]];
end

save Variables/incorrectSVM incorrectSVM;
save Variables/svmRecognized svmRecognized;

svmPercent = (svmPercent/(size(testLabel,2))) * 100;
disp(svmPercent);
msgbox(strcat('SVM PERFORMANCE : ',num2str(svmPercent)),'PERFORMANCE');


%% DTW 
	
[matchPercent, allCostMatrix, incorrectDTW, dtwRecognized] = dtwRecognition(nsubjects, ntrain, ntest, train, test);
save Variables/allCostMatrix allCostMatrix;
save Variables/incorrectDTW incorrectDTW;
save Variables/dtwRecognized dtwRecognized;

disp(matchPercent);
msgbox(strcat('Gabor+DTW PERFORMANCE : ',num2str(matchPercent)),'PERFORMANCE');

%% DTW to SVM

trainAndTest = horzcat(train,test);
nDtsTrain = 11;
dtsTrain = trainAndTest(:,1:(nsamples/nDtsTrain):end);
[matchPercent, allCostMatrix, incorrect] = dtwRecognition(nsubjects, nDtsTrain, nsamples, dtsTrain, trainAndTest);
dtwToSvmTrainLabel = transpose(trainLabel);
dtwToSvmTestLabel =  transpose(testLabel);
dtwToSvmTrain = allCostMatrix(1:nsubjects*ntrain, :);
dtwToSvmTest = allCostMatrix((nsubjects*ntrain+1):nsubjects*nsamples,:);

%reduce feature vectors in the above matrix to 14dimensions
% for i = 1:nsubjects*ntrain
% 		data = allCostMatrix(:, i);
% 		dtwToSvmTrain(:, i) = gdaSir(data, allCostMatrix, trainLabel, 'linear');
% end
% for i = 1:nsubjects*ntest
% 		data = featdb(:, i);
% 		dtwToSvmTest(:, i) = gdaSir(data, allCostMatrix, trainLabel,'linear');
% end
svmResult = fitcecoc(dtwToSvmTrain,dtwToSvmTrainLabel);
[dtwToSvmLabel,dtwToSvmScore] = predict(svmResult,dtwToSvmTest);

incorrectDtwToSvm = [];
dtwToSvmRecognized = [];
dtwToSvmPercent = 0;
for(i = 1: size(dtwToSvmTestLabel,1))
    if(dtwToSvmLabel(i,1) == dtwToSvmTestLabel(i,1))
        dtwToSvmPercent = dtwToSvmPercent + 1;
    else
        incorrectDtwToSvm = [incorrectDtwToSvm; [i, dtwToSvmLabel(i,1), dtwToSvmTestLabel(i,1)]];
    end
    
    dtwToSvmRecognized = [dtwToSvmRecognized; [i, dtwToSvmLabel(i,1), dtwToSvmTestLabel(i,1)]];
end

dtwToSvmPercent = (dtwToSvmPercent/(size(testLabel,2))) * 100;

save Variables/incorrectDtwToSvm incorrectDtwToSvm;
save Variables/dtwToSvmRecognized dtwToSvmRecognized;
disp(dtwToSvmPercent);
msgbox(strcat('DTW to SVM PERFORMANCE : ',num2str(dtwToSvmPercent)),'PERFORMANCE');


%% are incorrects matching
incorrectsMatch = intersect(incorrectSVM(:,1), incorrectDtwToSvm(:,1));
%% voting among dtw, dtw to svm, svm
allRecognized = horzcat(dtwRecognized(:,2), svmRecognized(:,2), dtwToSvmRecognized(:,2));
votingLabel = mode(allRecognized, 2);
votingPercent = 0;
for i = 1: (nsubjects * ntest)
    if(votingLabel(i,1) == testLabel(1,i))
        votingPercent = votingPercent + 1;
    end
end
votingPercent = (votingPercent/size(testLabel,2)) * 100;

%% feature vector from dtw minimum score, svm minimum score, back propagation algorithm
twoDimTrain = [];
twoDimTest = [];
newSvmPercent = 0;

allLabels = horzcat(trainLabel, testLabel);
allSvmResult = fitcecoc(dtwToSvmTrain,dtwToSvmTrainLabel);
[allSvmLabel,allSvmScore] = predict(allSvmResult,allCostMatrix);
  
for i = 1: (nsubjects * ntrain)
    %twoDimTrain = [twoDimTrain; [min(setdiff(allCostMatrix(i,:),min(allCostMatrix(i,:)))), min(allSvmScore(i,:))]];
    twoDimTrain = [twoDimTrain; [min(allCostMatrix(i,:)), min(allSvmScore(i,:))]];
end

for i = (nsubjects*ntrain+1): (nsubjects*nsamples)
    %twoDimTest = [twoDimTest; [min(setdiff(allCostMatrix(i,:),min(allCostMatrix(i,:)))), min(allSvmScore(i,:))]];
    twoDimTest = [twoDimTest; [min(allCostMatrix(i,:)), min(allSvmScore(i,:))]];
end

newSvmResult = fitcecoc(twoDimTrain,dtwToSvmTrainLabel);
[newSvmLabel,newSvmScore] = predict(newSvmResult,twoDimTest);

newSvmLabel = transpose(newSvmLabel);
    
for i = 1: size(testLabel,2)
    if(newSvmLabel(1,i) == testLabel(1,i))
        newSvmPercent = newSvmPercent + 1;
    end
end
newSvmPercent = (newSvmPercent / size(testLabel,2)) * 100;

%%
testMdl = fitcecoc(svmTrain,svmTrainLabel);
[testsvmLabel,testsvmScore] = predict(testMdl,svmTrain);