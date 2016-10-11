%% By Lillian Lin
clear all;
clc;
close all;

%% Variable Initalization
ObstacleMap = zeros(7,7);
robot = [1 0];
Path = [0 2];
iteration = 1;
crash = 0;
ActualMap(robot(1),robot(2)+1)=1; % Starting Position
direction=-1; %1 is moving up and -1 moving down

% direction is as seen below
%  0   1   0
% -2   0   2
%  0  -1   0

%% Determine Number of Obstacles
amount = input('How many obstacles will be generated? ');
if isempty(amount)
    amount = 0;
    disp('A default of 0 obstacles will be generated')
end

while (amount<0 | amount>13)
    amount = input('Invalid amount. Please try again. ');
end

%% Generate Obstacles
while amount
    if amount==13
        ObstacleMap(2:2:6,2:2:6)=1;
        ObstacleMap(3:2:5,3:2:5)=1;
        break;
    end
    ObstacleX = randi([2 6]);
    ObstacleY = randi([2 6]);
    if ~(ObstacleMap(ObstacleX,ObstacleY)|ObstacleMap(ObstacleX+1,ObstacleY)|ObstacleMap(ObstacleX-1,ObstacleY)|ObstacleMap(ObstacleX,ObstacleY+1)|ObstacleMap(ObstacleX,ObstacleY-1))
        ObstacleMap(ObstacleX,ObstacleY)=1;
        amount=amount-1;
    end
end

ObstacleMap
input('Press Enter when ready to sweep');

%% Robot doing sweeping motion
MoveQueue=direction;
while (robot(1) ~= 7 | robot(2) ~=7)   
    ActualMap = zeros(7,7);
    switch MoveQueue(1)
        case -2
            move(iteration,1)=robot(1);
            move(iteration,2)=robot(2)-1;
        case 2
            move(iteration,1)=robot(1);
            move(iteration,2)=robot(2)+1;
        otherwise
            move(iteration,1)=robot(1)+MoveQueue(1);
            move(iteration,2)=robot(2);
            if (move(iteration,1)==0 | move(iteration,1)==8) %if edge change row and direction
                direction = -direction;
                move(iteration,2)=robot(2)+1;        
                move(iteration,1)=robot(1);
            end
    end
    
    if ObstacleMap(move(iteration,1),move(iteration,2))
        switch MoveQueue(1)
            case -2
                MoveQueue=[-direction -2 -2 direction direction 2 MoveQueue(3:end)];
            case 2
                MoveQueue=[direction 2 MoveQueue(2:end)];
            otherwise
                MoveQueue=[-2 direction direction 2 MoveQueue(2:end)];
        end
    else
        MoveQueue(1)=[];
        ActualMap(move(iteration,1),move(iteration,2))=8;
        robot(1)=move(iteration,1);
        robot(2)=move(iteration,2);     
        ActualMap+ObstacleMap      
        pause(.5);    
        ActualMap = zeros(7,7);
        iteration = iteration + 1;
        if numel(MoveQueue)==0
            MoveQueue=direction;
        end
    end        
end