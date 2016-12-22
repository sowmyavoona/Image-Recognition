function [mappedDataTrain, mappedDataTest] = gabortrain(nsubjects, ntrain, ntest, out_train, out_test, row, col, trainLabel, myOptions)

    fea = []; 
    featdb = [];
    mappedDataTest = [];
    mappedDataTrain = [];
    
    mu = [0 1 2 3 4 5 6 7]; % angle
    nu = [0 1 2 3 4]; % scale
    imgSz = 32;
    [G, gWinLen] = gabor_kernel(mu, nu, pi, 0, imgSz);    
    
    for i = 1:nsubjects*ntrain

        a = out_train(:, i);
        a = reshape(a, col, row);
        a = imresize(a, [imgSz imgSz]);

        %g = gaborbank(a);

        Gimg = gaborConvF(a, G, gWinLen);

        g = cell2mat(Gimg);

        temp = reshape(g, size(g, 1)*size(g, 2), 1);
        fea = [fea temp];
    end

	for i = 1:nsubjects*ntrain
		data = fea(:, i);
		mappedDataTrain(:, i) = gda(data, fea, trainLabel, myOptions);
    end
    
    disp('train files done');

    for i = 1:nsubjects*ntest

        a = out_test(:, i);
        a = reshape(a, col, row);
        a = imresize(a, [imgSz imgSz]);

        %g = gaborbank(a);
        Gimg = gaborConvF(a, G, gWinLen);
        g = cell2mat(Gimg);

        temp = reshape(g, size(g, 1)*size(g, 2), 1);
        featdb = [featdb temp];
    end


	for i = 1:nsubjects*ntest
		data = featdb(:, i);
		mappedDataTest(:, i) = gda(data, fea, trainLabel, myOptions);
    end

    disp('test files done');
  
	
end