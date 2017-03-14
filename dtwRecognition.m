function [matchPercent, allCostMatrix, incorrect, dtwRecognized]  = dtwRecognition(nsubjects, ntrain, ntest, mappedDataTrain, mappedDataTest)

    total = nsubjects * ntest;
    matched = 0;
    recognizedLabel = [];
    allCostMatrix = []; %zeros(nsubjects*ntest, nsubjects*ntrain);
    incorrect = [];
    dtwRecognized = [];
    for i = 1: nsubjects * ntest
        testImage = mappedDataTest(:,i);
        minCost = 111111;
        testLab = 1;
        actualLabel = ceil(i/ntest);
        eachTestCost = []; % zeros(nsubjects*ntrain);
        
        for j = 1: nsubjects * ntrain
            
            trainImage = mappedDataTrain(:,j);
            
            if( i == 65)
                flag = 1;
            else
                flag = 0;
            end
            
            flag = 0;
            str = strcat('test: ', num2str(ceil(i/ntest)) , ' train: ', num2str(ceil(j/ntrain)) );
 
           %[cost,path, distances] = dtw_mathworks(testImage, trainImage, 2, flag, str);
           [cost, path, rawDistances] = dtw(testImage, trainImage, flag, str);
           %[cost, path, distances] = dtw_mathworks(testImage, trainImage, 0, flag, str);
            
            if(i == 65 && j == 17)
                %save Variables\distances distances;
                save Variables\rawDistances rawDistances;

            end
            eachTestCost = [eachTestCost, cost];
            if(minCost > cost)
                minCost = cost;
                %testLabel = trainLabel(1,j);
                testLab = ceil(j/ntrain);
            end   
            
        end
        allCostMatrix = [allCostMatrix; eachTestCost];
        recognizedLabel = [recognizedLabel;testLab];
        
        if(testLab == actualLabel)
            matched = matched + 1;
        else
            incorrect = [incorrect;[i,testLab,actualLabel]];
        end
        
        dtwRecognized = [dtwRecognized; i, testLab, actualLabel];

    end
        save Variables/recognizedLabel.mat recognizedLabel;
        %save Variables/path.mat path;
        matchPercent = (matched/total) * 100;   
end

            
  


