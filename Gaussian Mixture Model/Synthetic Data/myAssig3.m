function [target,nontarget,score,actual] = myAssig3(caseno,k,iteration)

%% Getting data and splitting into Training, Validation and Testing
data1 = load('class1.txt');
data2 = load('class2.txt');
data=[data1;data2];
data=data';
data(1,:) = myNormalise(data(1,:));
data(2,:) = myNormalise(data(2,:));
% data1=data1';
% data2=data2';
% data1(1,:) = myNormalise(data1(1,:));
% data1(2,:) = myNormalise(data1(2,:));
% data2(1,:) = myNormalise(data1(1,:));
% data2(2,:) = myNormalise(data1(2,:));
% data1=data1';
% data2=data2';
data=data';
data1=data(1:2000,:);
data2=data(2001:end,:);

tdata1 = data1(1:.7*(size(data1,1)),:);
vdata1 = data1(.7*(size(data1,1))+1:.85*(size(data1,1)),:);
ttdata1 = data1(.85*(size(data1,1))+1:end,:);

tdata2 = data2(1:.7*(size(data2,1)),:);
vdata2 = data2(.7*(size(data2,1))+1:.85*(size(data2,1)),:);
ttdata2 = data2(.85*(size(data2,1))+1:end,:);


%% Running K Means for K = 2 to 30 to find best k using Elbow Method for class 1
%tdata1 = load('18_ls.txt');

% it = 1;
% rangek = 2:1:30;
% sse = zeros(1,length(rangek));
% for k=rangek
% 
% [idx1,m1,cov1,pi1] = myKMeans(tdata1,k,caseno);
% 
% distance = zeros(k,1);
% vidx1 = zeros(length(vdata1),1);
%  for i = 1:length(vdata1)
%      for j = 1:k
%         distance(j,1) =  myeuclideanDistance(vdata1(i,:)',m1(j,:)');
%      end
%       [~,vidx1(i,1)] = min(distance);
%  end
% 
% sse(1,it) = sumOfSquaredError(vdata1,vidx1,m1);
% 
% it = it + 1;
% 
% end
% 
% plot(rangek,sse);
% xlabel('Number of Cluster (K)'); ylabel('Sum of Squared Error');
% set(gca,'FontSize',14,'FontWeight','bold')
% print('-djpeg','Elbow_Method.jpg', '-r300');
% 
% 
% %% Running K Means for K = 2 to 30 to find best k using Elbow Method for class 2
% %tdata2 = load('18_ls.txt');
% 
% it = 1;
% rangek = 2:1:30;
% sse = zeros(1,length(rangek));
% for k=rangek
% 
% [idx2,m2,cov2,pi2] = myKMeans(tdata2,k,caseno);
% 
% distance2 = zeros(k,1);
% vidx2 = zeros(length(vdata2),1);
%  for i = 1:length(vdata2)
%      for j = 1:k
%         distance2(j,1) =  myeuclideanDistance(vdata2(i,:)',m2(j,:)');
%      end
%       [~,vidx2(i,1)] = min(distance2);
%  end
% 
% sse(1,it) = sumOfSquaredError(vdata2,vidx2,m2);
% 
% it = it + 1;
% 
% end
% 
% plot(rangek,sse);
% xlabel('Number of Cluster (K)'); ylabel('Sum of Squared Error');
% set(gca,'FontSize',14,'FontWeight','bold')
% print('-djpeg','Elbow_Method2.jpg', '-r300');
% 

%% Selecting K = 5 by observing above graph

%KMean GMM for class1
[idx1,m1,cov1,pi1] = myKMeans(tdata1,k,caseno);
color = 'rgbym';
[m11,cov11,pi11,idx11] = myGMM(m1,cov1,pi1,tdata1,k,caseno,iteration);

%KMean and GMM for class2
[idx2,m2,cov2,pi2] = myKMeans(tdata2,k,caseno);
[m22,cov22,pi22,idx22] = myGMM(m2,cov2,pi2,tdata2,k,caseno,iteration);

%% Making the decision boundary
        figure;
        r = (-2):.05:(2); 
        r1 = (-2):.05:(2); 
        %point=[r' r1'];
%         point1=myClassProbability(point,pi11,m11',cov11,pi22,m22',cov22,1);
%         point2=myClassProbability(point,pi11,m11',cov11,pi22,m22',cov22,2);
        for i=r
            for j=r1
                point=[i j];
                point1=myClassProbability(point,pi11,m11',cov11,pi22,m22',cov22,1);
                point2=myClassProbability(point,pi11,m11',cov11,pi22,m22',cov22,2);
                if point1 > point2
                    scatter(point(1,1),point(1,2),'g','filled');
                    hold on;
                else
                    scatter(point(1,1),point(1,2),'y','filled');
                    hold on;
                end  
            end
        end
%% Plotting of Contours of Class1
% for i = 1:k
% [kind,col,v]=find(idx11==i);
% plot(tdata1(kind,1),tdata1(kind,2));
% end
%figure;
scatter(ttdata1(:,1),ttdata1(:,2),'r','filled');
%hold on
scatter(m11(1,:),m11(2,:),'k','filled');

%disp(['Total number : ',num2str(count)]);
        r = (-2):.01:(2); %// x axis
        r1= (-2):.01:(2); %// y axis
        [X11 X12] = meshgrid(r,r1);
for i = 1:k
% [kind,col,v]=find(idx11==i);
        %gauss1=mvnpdf([X11(:) X12(:)],(m11(:,i))',cov11{i});
        gauss1= calculateGaussianPDF(X11,X12,(m11(:,i))',cov11{i});
        contour(X11,X12,gauss1,3,'Linecolor','red','LineWidth',2,'LevelStep',1); 
end
%% Plotting the Contours for the Class2
% for i = 1:k
% [kind,col,v]=find(idx22==i);
% plot(tdata2(kind,1),tdata2(kind,2));
% end
scatter(ttdata2(:,1),ttdata2(:,2),'b','filled');
scatter(m22(1,:),m22(2,:),'k','filled');


%         r = (-17):.1:(17); %// x axis       
%         r1= (-17):.1:(17); %// y axis       
%         [X11 X12] = meshgrid(r,r1);

for i = 1:k
        g1 = calculateGaussianPDF(X11,X12,(m22(:,i))',cov22{i});
        contour(X11,X12,g1,3,'Linecolor','blue','LineWidth',2,'LevelStep',1);
end

hold off
set(gcf,'Renderer','painters')
xlabel('Input Feature X1'); ylabel('Input Feature X2');

if caseno == 1
   title(['Clusters for K = ',num2str(k),' with Diagonal Covariance']);
else
    title(['Clusters for K = ',num2str(k),' with Non-Diagonal Covariance']);
end

set(gca,'FontSize',14,'FontWeight','bold')

if caseno == 1
    print('-djpeg',['Cluster_K_',num2str(k),'for_Diagonal_Cov.jpg'], '-r300');
else
    print('-djpeg',['Cluster_K_',num2str(k),'for_Non-Diagonal_Cov.jpg'], '-r300');
end


% 
% [idx2,C,sumd,D] = kmeans(tdata1,k);
% figure;
% for i = 1:k
% kind = find(idx2==i);
% scatter(tdata1(kind,1),tdata1(kind,2));
% hold on
% end
% hold off
%% Computing the prediction indices and Confusion Plot

test=[ttdata1' ttdata2'];

actual=[1*ones(1,length(ttdata1')) 2*ones(1,length(ttdata2'))];

pred=zeros(1,length(test));
% score1 = zeros(1,length(test));
% score2 = zeros(1,length(test));
score1=myClassProbability(test',pi11,m11',cov11,pi22,m22',cov22,1);
score2=myClassProbability(test',pi11,m11',cov11,pi22,m22',cov22,2);
score1=score1';
score2=score2';
for i=1:length(test)
%      score1(1,i)=0;
%      for j=1:k
%         val= pi11(j)*(1/(power(2*pi,2/2)*sqrt(det(cov11{j}))))*exp(-1/2*((test(:,i)-m11(:,j))'*(inv(cov11{j}))*(test(:,i)-m11(:,j))));
%         score1(1,i) = score1(1,i) + val;
%      end
%      score2(1,i)=0;
%      for j=1:k
%         val= pi22(j)*(1/(power(2*pi,2/2)*sqrt(det(cov22{j}))))*exp(-1/2*((test(:,i)-m22(:,j))'*(inv(cov22{j}))*(test(:,i)-m22(:,j))));
%         score2(1,i) = score2(1,i) + val;
%      end
     if(score1(1,i) > score2(1,i))
         pred(1,i)=1;
     else
         pred(1,i)=2;
     end
end
myConfusionPlot(pred,actual,caseno,k);


%% Plotting of the ROC curve

% normscore1=myNormalise(score1);
% normscore2=myNormalise(score2);

score = [score1;score2];
%% Target and non-target scores

target=[(score1(1,1:300))';(score2(1,301:600))'];
nontarget=[(score1(1,301:600))';(score2(1,1:300))'];

disp('----end------');
%% Plotting data and Histogram
% scatter(data1(:,1),data1(:,2));
% hold on
% scatter(data2(:,1),data2(:,2));

%hist(tdata1,15)
end