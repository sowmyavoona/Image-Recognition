function [out_train, out_test, folder_name, row, col, ext, trainLabel] = load_database(nsubjects, ntrain, ntest, nsamples)

    %10 3 7 20
    %{
    nsubjects = 10; %nc
    ntrain = 3; %nstr
    nsamples = 20; %ts
    ntest = 7; %nsts
    %}
    
    % SETTING UP
    
    folder_name = '/home/jesse/Documents/Face_Recognition_Project/Datasets/grimace_database';
    %folder_name = '/home/jesse/Documents/Face_Recognition_Project/Datasets/yalefaces_edited';
    %folder_name = uigetdir('', 'Select training images path');

    ext = '';
    possible_ext = {'.bmp' '.png' '.jpg' '.pgm' '.tif' '.gif'};
    clc

    % CHECK WHICH ONE RETURNS TRUE
    for i = 1:size(possible_ext, 2)
        try
            file = strcat(folder_name, '/(1)/(1)', char(possible_ext(i)));
            test = imread(file);
            [col row d] = size(test);
            ext = char(possible_ext(i));
        catch
        end
    end

    % FIND WHICH SAMPLES OF EACH nsubjects SHOULD BE USED FOR TRAINING AND
    % USE THE REMAINING FOR TESTING
    for z=1:nsubjects
    
        alltrain = [];
        alltest = [];
        tv = [];
        index = [];

        % READ ALL SAMPLES
        for j=1:nsamples
            file_name = strcat(folder_name,'/(', num2str(z), ')/(', num2str(j),')', ext);
            file = imread(file_name);
            if d > 1
                file = rgb2gray(file);
            end
            tv(j, :) = reshape(file, 1, size(file, 1)*size(file, 2));
        end

        % PICKING THE BEST NTRAIN SAMPLES WHICH HAVE THE HIGHEST CORRELATION
        % WITH OTHER SAMPLES
        id = kmeans(double(tv), ntrain);

        for k=1:ntrain

            index{k} = find(id == k);
            meancor = [];
            cor = [];

            for i = 1:size(index{k}, 1)
                for j = 1:size(index{k}, 1)
                	cor(i, j) = corr2(double(tv(index{k}(i), :)), double(tv(index{k}(j), :)));
                end
            end
            
            meancor = mean(cor(:, :));
            max_mean = find(max(meancor) == meancor);
            alltrain = [alltrain index{k}(max_mean(1))];
 
        end

        % THE UNSELECTED SAMPLES ARE FOR TESTING
        test1 = [1:nsamples];
        test = ismember(test1, alltrain);
        alltest = find(~test);
        
        % STORE ALL TRAIN SAMPLE DATA IN A SINGLE VARIABLE
        for k = 1:ntrain
            file = imread(strcat(folder_name, '/(', num2str(z), ')/(', num2str(alltrain(k)), ')', ext));
            try
                file = rgb2gray(file);
            catch
            end
            out_train(:, (z-1)*ntrain+k) = reshape(file, size(file, 1)*size(file, 2), 1);
        end

        % STORE ALL TEST SAMPLE DATA IN A SINGLE VARIABLE
        for k = 1:ntest
            file = imread(strcat(folder_name, '/(', num2str(z), ')/(', num2str(alltest(k)), ')', ext));
            try
                file = rgb2gray(file);
            catch
            end
            out_test(:, (z-1)*ntest+k) = reshape(file, size(file, 1)*size(file, 2), 1);
        end 
    end

    % STORE TRAIN LABELS FOR FUTURE USE
    trainLabel = [];
    for z = 1:nsubjects
        for j = 1:ntrain
            trainLabel(:, (z-1)*ntrain+j) = z;
        end
    end
    
    
    % COVERT TO DOUBLE AND YOU'RE DONE!
    out_train = double(out_train);
    out_test = double(out_test);
    
    disp('database loading done!');
end