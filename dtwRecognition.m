function [recognizedLabels]  = dtwRecognition(nsubjects, ntrain, ntest, mappedDataTrain, mappedDataTest)

    recognizedLabels = [];
    for i = 1: nsubjects * ntest
        testImage = mappedDataTest(:,i);
        minCost = 111111;
        testLabel = 1;
        
        save testImage.mat testImage;
        
         for j = 1: nsubjects * ntrain
            trainImage = mappedDataTrain(:,j);
            
            save trainImage.mat trainImage;
            
            cost = dtw(testImage, trainImage);
            
            if(minCost > cost)
                minCost = cost;
                %testLabel = trainLabel(j);
                testLabel = ceil(j/ntrain);
            end   
         end
        
        recognizedLabels = [recognizedLabels testLabel];

    end
end

            
  


