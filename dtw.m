function cost = dtw(testImage, trainImage)
 
    %dimOfTest = size(testImage(1,1),1); 
    noOfVecTest = size(testImage,1);
    
    %dimOfTrain = size(trainImage(1,1),1); 
    noOfVecTrain = size(trainImage,1);
    
    distances = zeros(noOfVecTest,noOfVecTrain);

    for i=1:noOfVecTest
        for j=1:noOfVecTrain
             distances(i,j) = norm(testImage(i,:) - trainImage(j,:));
        end
    end
    
    cost = zeros(noOfVecTest,noOfVecTrain);
    cost(1,1) = distances(1,1);

    for j = 2:noOfVecTrain
        cost(1,j) = distances(1,j) + cost(1,j-1);
    end
    for i = 2:noOfVecTest
        cost(i,1) = distances(i,1) + cost(i-1,1);
    end

    for i = 2:noOfVecTest
        for j = 2: noOfVecTrain
            cost(i,j) = distances(i,j) + min([cost(i-1,j) cost(i,j-1) cost(i-1,j-1)]);
        end
    end
    
    cost = cost(noOfVecTest,noOfVecTrain)/double(noOfVecTest+noOfVecTrain);

end
