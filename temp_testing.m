%% gabor train
clc
tic;
myOptions = 'linear';
[train, test] = gabor_train(nsubjects, ntrain, ntest, loaddb_train, loaddb_test, row, col, trainLabel, myOptions);
time = toc;

disp(strcat('gabor train completed in _', num2str(time))); 

%% DTW 

found = dtwrecognition2(folder_name, nsubjects, nsamples, ext, ntrain, ntest, train, test, loaddb_test, row, col);			
percent = (found/(nsubjects * ntest))*100

msgbox(strcat('Gabor+DTW PERFORMANCE : ',num2str(percent)),'PERFORMANCE');
			