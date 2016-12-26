function matchPercent  = dtwRecognition(nsubjects, ntrain, ntest, mappedDataTrain, mappedDataTest)

    total = nsubjects * ntest;
    matched = 0;
   
    for i = 1: nsubjects * ntest
        testImage = mappedDataTest(:,i);
        minCost = 111111;
        testLabel = 1;
        actualLabel = ceil(i/ntest); 
        
        for j = 1: nsubjects * ntrain
            
            trainImage = mappedDataTrain(:,j);
            
%             if( mod(i,ntest) == 0 && ceil(j/ntrain) == ceil(i/ntest))
%                 flag = 1;
%             else
%                 flag = 0;
%             end
        
            flag = 0;
            
            str = strcat('test: ', num2str(ceil(i/ntest)) , 'train: ', num2str(ceil(j/ntrain)) );
            cost = dtw(testImage, trainImage, flag, str);
        
            if(minCost > cost)
                minCost = cost;
                %testLabel = trainLabel(1,j);
                testLabel = ceil(j/ntrain);
            end   
            
        end
      
        if(testLabel == actualLabel)
            matched = matched + 1;
        end
        
    end
    
        matchPercent = (matched/total) * 100;   
end

            
  


