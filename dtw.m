function cost = dtw(testImage, trainImage, flag, titleStr )

    %dimOfTest = size(testImage(1,1),1); 
    %dimOfTrain = size(trainImage(1,1),1); 
    
     noOfVecTest = size(testImage,1);
     noOfVecTrain = size(trainImage,1);
               
    distances = zeros(noOfVecTest,noOfVecTrain);

    for i=1:noOfVecTest
        for j=1:noOfVecTrain
             distances(i,j) = norm(testImage(i,:) - trainImage(j,:));
        end
    end
   
    for i = 1:noOfVecTest
        for j = 1: noOfVecTrain
            
            if(i == 1 && j ~= 1)
                distances(1,j) = distances(1,j) + distances(1,j-1);
                
            elseif(j == 1 && i ~= 1)
                distances(i,1) = distances(i,1) + distances(i-1,1);
                
            elseif( i > 1 && j > 1)
                distances(i,j) = distances(i,j) + min([distances(i-1,j) distances(i,j-1) distances(i-1,j-1)]);
           
            end
            
        end
    end
    cost = distances(noOfVecTest,noOfVecTrain)/(noOfVecTest + noOfVecTrain);
    
    if( flag == 1)
        normalCost = zeros(noOfVecTest,noOfVecTrain);

        for i = 1:noOfVecTest
            for j = 1: noOfVecTrain
                normalCost(i,j) = distances(i,j)/double(i+j);
            end
        end
        figure;
        imagesc(normalCost);         
        colormap(flipud(gray));
        title(titleStr);
    end
    
end
    