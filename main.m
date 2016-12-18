nsubjects = 10; %nc
ntrain = 3; %nstr
nsamples = 20; %ts
ntest = 7; %nsts

% load database
[out_train, out_test, folder_name, row, col, ext, trainLabel, testLabel] = load_database(nsubjects, ntrain, ntest, nsamples);

% gabor train
[mappedDataTrain, mappedDataTest] = gabor_train(nsubjects, ntrain, ntest, out_train, out_test, row, col, trainLabel, testLabel);

%dtw
[recognizedLabels] = dtwRecognition(nsubjects, ntrain, ntest, mappedDataTrain, mappedDataTest);
