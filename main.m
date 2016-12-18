% A word from Jesse: Loading database is a common step in testing, so I
% saved the variables and loaded them from there. This helps skipping this
% first part of the code. From second time, please run from the next
% section.

nsubjects = 10; %nc
ntrain = 3; %nstr
nsamples = 20; %ts
ntest = 7; %nsts

% load database
[loaddb_train, loaddb_test, folder_name, row, col, ext, trainLabel, testLabel] = load_database(nsubjects, ntrain, ntest, nsamples);

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

%% gabor train

tic;
[train, test] = gabor_train(nsubjects, ntrain, ntest, loaddb_train, loaddb_test, row, col, trainLabel, testLabel);
time = toc;

save Variables/gabor_train train
save Variables/gabor_test test

disp(strcat('gabor train completed in _', num2str(time)));

%% 

load Variables/gabor_train
load Variables/gabor_test

%% DTW 


found = dtwrecognition2(folder_name, nsubjects, nsamples, ext, ntrain, ntest, train, test, loaddb_test, row, col);			
percent = (found/(nsubjects * ntest))*100

msgbox(strcat('Gabor+DTW PERFORMANCE : ',num2str(percent)),'PERFORMANCE');
			