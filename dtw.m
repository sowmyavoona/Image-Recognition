function [cost,path,rawDistances] = dtw(testImage, trainImage, flag, titleStr )

    %dimOfTest = size(testImage(1,1),1); 
    %dimOfTrain = size(trainImage(1,1),1); 
    
     noOfVecTest = size(testImage,1);
     noOfVecTrain = size(trainImage,1);
               
    distances = zeros(noOfVecTest,noOfVecTrain);
    prevCoords = zeros(noOfVecTest,noOfVecTrain);

   %% distance matrix
    for i=1:noOfVecTest
        for j=1:noOfVecTrain
             distances(i,j) = norm(testImage(i,:) - trainImage(j,:));
        end
    end
    rawDistances = distances;
    verCount = 0;
    horCount = 0;
    
   %% cost matrix   
    for i = 1:noOfVecTest
        for j = 1: noOfVecTrain    
            if(i == 1 && j ~= 1)
                distances(1,j) = distances(1,j) + distances(1,j-1);
                prevCoords(1,j) = -1;
            elseif(j == 1 && i ~= 1)
                distances(i,1) = distances(i,1) + distances(i-1,1);
                prevCoords(i,1) = 1;
            elseif( i > 1 && j > 1)
                [minDist, minIndex] =  min([distances(i-1,j) distances(i,j-1) distances(i-1,j-1)]);
                distances(i,j) = distances(i,j) + minDist;
                
                if(minIndex == 1)
                     prevCoords(i,j) = 1;
                elseif(minIndex == 2)
                     prevCoords(i,j) = -1;
                elseif(minIndex == 3)
                     prevCoords(i,j) = 0;
                end
            end            
        end
    end
    cost = distances(noOfVecTest,noOfVecTrain) /(noOfVecTest + noOfVecTrain);  
   
    %% finding warping path
    path = [1, 1];
    i = noOfVecTest;
    j = noOfVecTrain;
    
    while( i ~= 1 && j ~= 1)
         if(prevCoords(i,j) == 1)
            path = [i-1,j; path];
            i = i-1;
         elseif(prevCoords(i,j) == -1)
            path = [i,j-1; path];
            j = j-1;
         elseif(prevCoords(i,j) == 0)
            path = [i-1,j-1; path];
            i = i-1;
            j = j-1;  
         end
    end
    path(end,:) = [];
    if(flag == 1)
        figure
        plot(path(:,1), path(:,2));
        title(titleStr);
        xlabel('test');
        ylabel('train');
        axis([1 14 1 14]);
        set(gca,'xtick',[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
        set(gca,'ytick',[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);

        
    end
end
    