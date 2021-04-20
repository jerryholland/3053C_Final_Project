% %Malaria Detection in Microscopic Blood Imaging Multi Image Detection
clc; clear; close all;

count=0;
num=0;
pos=[1 2 3 4 5 6 7 8 9 10];
figs=zeros(1,10)';
Accuracy=zeros(1,10)';
newans=[];

% To provide results of detection
infectionz=[];
infectednum=[];

% Test bank
set1=["cell.1.png" ,"cell.2.png","cell.3.png","cell.4.png","cell.5.png","cell.6.png","cell.7.png","cell.8.png","cell.9.png","cell.10.png"];
set2=["cell.11.png","cell.12.png","cell.13.png","cell.14.png","cell.15.png","cell.16.png","cell.17.png","cell.18.png","cell.19.png","cell.20.png"];
set3=["cell.21.png","cell.22.png","cell.23.png","cell.24.png","cell.25.png","cell.26.png","cell.27.png","cell.28.png","cell.29.png","cell.30.png"];
set4=["cell.31.png" ,"cell.32.png","cell.33.png","cell.34.png","cell.35.png","cell.36.png","cell.37.png","cell.38.png","cell.39.png","cell.40.png"];

% starting message
disp('Input set1, set2, set3 or set4!')
disp('(set4 tests the wrong detection function of set1)');
disp('--------------------------------')
files=input('Enter set number to test: '); % Take input for what set to apply program to
disp('--------------------------------')

% file set retrival
if files ==set1
     Infected_Cell_actual=logical([0 1 1 1 1 0 1 0 0 0]');
elseif files ==set2
    Infected_Cell_actual=loggical([1 1 1 1 1 1 1 1 1 1]');
elseif files ==set3
    Infected_Cell_actual=logical([1 1 1 1 0 1 0 0 1 0]');
elseif files ==set4
     Infected_Cell_actual=logical([0 0 0 0 0 0 0 0 1 1 ]'); %last term is incorect to show how program works
else
    disp('Error occurred, must select set1, set2 or set3')
end

% Message
fprintf('Patients: %g\n',length(files)); %Let's user know how many cell images are being reviewed
fprintf('Figure output: %g\n',length(files)+1); % Let's user know how many figures to expect
fprintf('Table output: 1\n')

disp('--------------------------------')

% image processing
for zz= 1:1:length(files)
pix=imread(files(zz)); %Reads file
npix=rgb2gray(pix);    %Turns file into greyscale
[h,w,c]=size(npix);    %Finds size of image
binary=false(h,w);     %Creates a binary image
    for ii = 1:1:h     %For loop to go through each pixel of the image in the y direction
        for jj = 1:1:w %For loop to go through each pixel of the image in the x direction
            value=npix(ii,jj,1); % Take the greyscale value at the postion (ii,jj)
            if value<100 && value>0 % Limits of 'value' that corespond to an infection
                binary(ii,jj)=1; % If limit is met, that loction will turn white on the binary file 
                count=count+1; %Keeps count of number of infections
            end
        end
    end
                if count >0 %If cell has more than one infection
                    infectionz=[infectionz count]; %Keep number of infections
                             num=1; % Keeps track if the person is infected
                             infectednum=[infectednum num]; %Keeps track of true values
                else
                    infectionz=[infectionz 0]; % no infections
                    
                    infectednum=[infectednum 0];% no infected person

                end
num=0; % Resets count
count=0; %Resets count
                                    
figure(zz) %Creates a figure with each iteration
%Creates three plots for each sample. Shows orginal, greyscale and binary figure. The binary figure shows the infected parts of the cell.
hold on
subplot(1,3,1) 
imshow(pix)
title ('Blood Cell Sample')

subplot(1,3,2)
imshow(npix)
title ('Algorithm')

subplot(1,3,3)
imshow(binary)
title ('Infection detection')

sgtitle('IMAGES')
f = figure(zz);
movegui(f,'northwest');
end
 



%Creates a table to keep track of patients, infected or not and number of infections.
Filename_Patient = [(files(1:10))']; %File name
Program=([' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']'); %Used to show algorithm results and seperate data
Infected_Cell=logical([infectednum(1:10)]'); %Returns if the person is infected or not
Infection_sites= [infectionz(1:10)']; %Number of infections
ACTUAL=([' ',' ',' ',' ',' ',' ',' ',' ',' ',' ']');% Used to show actual results and seperate data

% vector to save data
for oo =1:10
    if Infected_Cell(oo)==Infected_Cell_actual(oo)
        Accuracy(oo)=1;
        newans=[newans Infected_Cell(oo)]; % creates correct ans for set4
    else
        Accuracy(oo)=0;
        newans=[newans Infected_Cell_actual(oo)];% creates correct ans for set4
    end
end


% Table creation

T=table(Filename_Patient,Program,Infection_sites,Infected_Cell,ACTUAL, Infected_Cell_actual,Accuracy);
disp(T)



% Graphs
figure(11)
if mean(Accuracy)==1 % conditon so only one plot is shown
    correct=plot(1:10,newans,'s','LineWidth',3, 'MarkerSize',7,'MarkerEdgeColor','b');
    xlabel('Patient')
    ylabel('Infection: (1=Positive, 0=Negative)')
    title('Corrected status of patient')
    grid on;
    xticks([1:10])
    yticks([-1,0,1]) % Makes the limits of the y axis only 1 or 0, relating to true or false
    axis([0 11 0 2])
    lgd = legend([correct],{'Corect'});

else     % will allow for 2 plots to show, the wrong and the corrected version
    t = tiledlayout('flow','TileSpacing','compact'); % creates tile view of subplots
    nexttile
    
    hold on
    for qq = 1:10
        if Accuracy(qq)==1
                    correct=plot(pos(qq),infectednum(qq),'s','LineWidth',3, 'MarkerSize',7,'MarkerEdgeColor','b');
        else
                    wrong=plot(pos(qq),infectednum(qq),'s','LineWidth',3, 'MarkerSize',7,'MarkerEdgeColor','r'); % alters the effects of the graph
        end
    end
    hold off
    xlabel('Patient')
    ylabel('Infection: (0=Negative, 1=Positive, )')
    title('Status of patient')
    grid on;
    xticks([1:10])
    yticks([-1,0,1]) %graph limits
    axis([0 11 0 2])

    
    nexttile
    correct=plot(1:10,newans,'s','LineWidth',3, 'MarkerSize',7,'MarkerEdgeColor','b');
    xlabel('Patient')
    ylabel('Infection: (1=Positive, 0=Negative)')
    title('Corrected status of patient')
    grid on;
    xticks([1:10])
    yticks([-1,0,1]) % graph limits
    axis([0 11 0 2])


    lgd = legend([correct wrong],{'Corect','Incorrect'}); % legend
    lgd.Layout.Tile = 'east';
end

disp('--------------------------------')

% ending message
disp('Code Testing')
disp('--------------------------------')
fprintf('The percentage of correct detections is: %g',100*(mean(Accuracy))); disp('%');
disp('--------------------------------')
if length(find(Accuracy==0)) >0
    fprintf('Figure %g was detected incorrectly\n',find(Accuracy==0));
    disp('--------------------------------')
    fprintf('Figure %g was fixed\n',find(Accuracy==0));
else
    disp('Figures 1-10 were detected correctly')
end

% shifting figure location
f = figure(11);
movegui(f,'southwest');

