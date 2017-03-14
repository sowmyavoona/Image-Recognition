% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>,
% Signal Analysis and Machine Perception Laboratory,
% Department of Electrical, Computer, and Systems Engineering,
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA

% dynamic time warping of two signals

function [d,path, D] =dtw_mathworks(s,t,w, flag, titleStr)
% s: signal 1, size is ns*k, row for time, colume for channel 
% t: signal 2, size is nt*k, row for time, colume for channel 
% w: window parameter
%      if s(i) is matched with t(j) then |i-j|<=w
% d: resulting distance

if nargin<3
    w=Inf;
end

ns=size(s,1);
nt=size(t,1);
if size(s,2)~=size(t,2)
    error('Error in dtw(): the dimensions of the two input signals do not match.');
end
w=max(w, abs(ns-nt)); % adapt window size

%% initialization
D=zeros(ns+1,nt+1)+Inf; % cache matrix
D(1,1)=0;

prevCoords = zeros(ns,nt) + +Inf;

%% begin dynamic programming
for i=1:ns
    for j=max(i-w,1):min(i+w,nt)
        oost=norm(s(i,:)-t(j,:));
        [minDist, minIndex] = min( [D(i,j+1), D(i+1,j), D(i,j)] );
        D(i+1,j+1) = oost+ minDist;
        
          if(minIndex == 1)
            prevCoords(i,j) = 1;
          elseif(minIndex == 2)
            prevCoords(i,j) = -1;
          elseif(minIndex == 3)
            prevCoords(i,j) = 0;
          end
    end
end
d=D(ns+1,nt+1)/ (ns + nt);

 %% finding warping path
    path = [1, 1];
    i = ns;
    j = nt;
    
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