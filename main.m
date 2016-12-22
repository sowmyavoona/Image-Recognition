% A word from Jesse: Loading database is a common step in testing, so I
% saved the variables and loaded them from there. This helps skipping this
% first part of the code. From second time, please run from the next
% section.

nsubjects = 18; %nc
ntrain = 1; %nstr
ntest = 19; %nsts
nsamples = 20; %ts

% load database
[loaddb_train, loaddb_test, folder_name, row, col, ext, trainLabel] = load_database(nsubjects, ntrain, ntest, nsamples);


%% gabor train

tic;
myOptions = 'linear';
[train, test] = gabor_train(nsubjects, ntrain, ntest, loaddb_train, loaddb_test, row, col, trainLabel, myOptions);
time = toc;

train = normalize(train);

disp(strcat('gabor train completed in _', num2str(time)));

%% DTW 


found = dtwrecognition2(folder_name, nsubjects, nsamples, ext, ntrain, ntest, train, test, loaddb_test, row, col);			
percent = (found/(nsubjects * ntest))*100

msgbox(strcat('Gabor+DTW PERFORMANCE : ',num2str(percent)),'PERFORMANCE');
			