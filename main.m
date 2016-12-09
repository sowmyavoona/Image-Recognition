subjects = 10; %nc
ntrain = 3; %nstr
nsamples = 20; %ts
ntest = 7; %nsts

%% load database
[out_train, out_test, folder_name, row, col, ext] = load_database(subjects, ntrain, ntest, nsamples);

%% gabor train
