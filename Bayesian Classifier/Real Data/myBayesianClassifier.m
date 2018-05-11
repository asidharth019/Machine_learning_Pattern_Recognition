function [ DetTargetScores,DetNonTargetScores ] = myBayesianClassifier( caseno )



%% Getting data and seperating in classes and training,validation and test data

data = load('group_18.txt');

c1 = data(1:500,:);
c2 = data(501:1000,:);
c3 = data(1001:end,:);

c1 = c1(randperm(length(c1)),:);
c2 = c2(randperm(length(c2)),:);
c3 = c3(randperm(length(c3)),:);



tc1 = c1(1:.7*(size(c1,1)),:);
vc1 = c1(.7*(size(c1,1))+1:.9*(size(c1,1)),:);
ttc1 = c1(.7*(size(c1,1))+1:end,:);

tc2 = c2(1:.7*(size(c2,1)),:);
vc2 = c2(.7*(size(c2,1))+1:.9*(size(c2,1)),:);
ttc2 = c2(.7*(size(c2,1))+1:end,:);

tc3 = c3(1:.7*(size(c3,1)),:);
vc3 = c3(.7*(size(c3,1))+1:.9*(size(c3,1)),:);
ttc3 = c3(.7*(size(c3,1))+1:end,:);

tc1 = tc1';
vc1 = vc1';
ttc1 = ttc1';

tc2 = tc2';
vc2 = vc2';
ttc2 = ttc2';

tc3 = tc3';
vc3 = vc3';
ttc3 = ttc3';

c1 = c1';
c2 = c2';
c3 = c3';


%% Calculating Mean, Covariance and discriminant Function of all classes from training data

m1 = myMean(tc1);
m2 = myMean(tc2);
m3 = myMean(tc3);

cov1 = myCovariance(tc1);
cov2 = myCovariance(tc2);
cov3 = myCovariance(tc3);


    if caseno == 1 % Bayes with Covariance same for all classes
        A = cov1;
        cov1 = A;
        cov2 = A;
        cov3 = A;
        
        
     elseif caseno == 2  % Bayes with Covariance different for all classes
        
     elseif  caseno == 3 % Naive Bayes with C = sigma^2*I.
        A = eye(length(cov1)).*cov1(1,1);
        cov1 = A;
        cov2 = A;
        cov3 = A;
        
     elseif  caseno == 4 % Naive Bayes with C same for all classes.
        A = cov1;
        A(1,2) = 0;
        A(2,1) = 0;
        cov1 = A;
        cov2 = A;
        cov3 = A;
        
     elseif  caseno == 5 % Naive Bayes with C different for all classes.
      
        cov1(1,2) = 0;
        cov1(2,1) = 0;
        cov2(1,2) = 0;
        cov2(2,1) = 0;
        cov3(1,2) = 0;
        cov3(2,1) = 0;
         
     end      



%% Plotting gaussian PDF

r = .2*min(data(:,1)):15:.7*max(data(:,1)); %// x axis
r1 = .4*min(data(:,2)):15:1.1*max(data(:,2)); %// y axis

[X11 X12] = meshgrid(r,r1);

x1minu11 = X11 - m1(1);
x2minu21 = X12 - m1(2);
icov1 = inv(cov1);
p11 = icov1(1,1).*x1minu11.^2 + icov1(1,2).*x1minu11.*x2minu21 + icov1(2,1).*x1minu11.*x2minu21 + icov1(2,2).*x2minu21.^2;
g1 = (1/(2*pi*sqrt(det(cov1)))) * exp(-0.5 * (p11));


x1minu12 = X11 - m2(1);
x2minu22 = X12 - m2(2);
icov2 = inv(cov2);
p21 = icov2(1,1).*x1minu12.^2 + icov2(1,2).*x1minu12.*x2minu22 + icov2(2,1).*x1minu12.*x2minu22 + icov2(2,2).*x2minu22.^2;
g2 = (1/(2*pi*sqrt(det(cov2)))) * exp(-0.5 * (p21));

x1minu13 = X11 - m3(1);
x2minu23 = X12 - m3(2);
icov3 = inv(cov3);
p31 = icov3(1,1).*x1minu13.^2 + icov3(1,2).*x1minu13.*x2minu23 + icov3(2,1).*x1minu13.*x2minu23 + icov3(2,2).*x2minu23.^2;
g3 = (1/(2*pi*sqrt(det(cov3)))) * exp(-0.5 * (p31));

c = -9*10^-6;
figure;
surf(X11,X12,g1,'EdgeColor','r');
hold on
[~,hcon1]=contourf(X11,X12,g1,10,'Linecolor','r');
hcon1.ContourZLevel=c;

[~,hcon2]=contourf(X11,X12,g2,10,'Linecolor','g');
hcon2.ContourZLevel=c;
surf(X11,X12,g2,'EdgeColor','g');

[~,hcon3]=contourf(X11,X12,g3,10,'Linecolor','b');
hcon3.ContourZLevel=c;
surf(X11,X12,g3,'EdgeColor','b');


xlabel('Input Feature X1','FontSize',12,'FontWeight','bold'); ylabel('Input Feature X2','FontSize',12,'FontWeight','bold');
zlabel('Probability Density','FontSize',12,'FontWeight','bold');
title(['Gaussian PDF & Contours for Case ',num2str(caseno)],'FontSize',12,'FontWeight','bold');
set(gca,'FontSize',14,'FontWeight','bold')
zlim([c 6*10^-6])

print('-djpeg', ['RD_Gaussian_PDF_Case_',num2str(caseno),'.jpg'], '-r300');

hold off

%% Plotting contours
 figure;
 
plot(c1(1,:),c1(2,:),'ro',c2(1,:),c2(2,:),'g+',c3(1,:),c3(2,:),'bs');

range = [100 1200 500 2225];
axis(range);

hold on
contour(X11,X12,g1,'Linecolor','r','LineWidth',2);
contour(X11,X12,g2,'Linecolor','g','LineWidth',2);
contour(X11,X12,g3,'Linecolor','b','LineWidth',2);

c = 5;
c1 = range(1);
c2 = range(2);

[v d] = eig(cov1);
v = v+[m1 m1];

    if caseno == 2 %|| caseno == 5

        y = slope(m1,v(:,1),c1)
        v(:,1) = [c1 y];

        y = slope(m1,v(:,2),c2)
        v(:,2) = [c2 y];

    else 

         v(2,2) = v(2,2).*c; 
         v(1,1) = v(1,1).*c;

    end

plot([m1(1) v(1,1)],[m1(2) v(2,1)],'--r','LineWidth',3); 
plot([m1(1) v(1,2)],[m1(2) v(2,2)],'--r','LineWidth',3); 

[v1 d1] = eig(cov2);
 v1 = v1+[m2 m2];

    if caseno == 2 %|| caseno == 5
        y = slope(m2,v1(:,1),c1)
        v1(:,1) = [c1 y];

        y = slope(m2,v1(:,2),c2)
        v1(:,2) = [c2 y];
    else
        v1(2,2) = v1(2,2).*c; 
        v1(1,1) = v1(1,1).*c;    
    end

plot([m2(1) v1(1,1)],[m2(2) v1(2,1)],'--g','LineWidth',3); 
plot([m2(1) v1(1,2)],[m2(2) v1(2,2)],'--g','LineWidth',3); 

[v2 d2] = eig(cov3);
v2 = v2+[m3 m3];


    if caseno == 2 %|| caseno == 5
        y = slope(m3,v2(:,1),c1)
        v2(:,1) = [c1 y];

        y = slope(m3,v2(:,2),c2)
        v2(:,2) = [c2 y];

    else
       v2(2,2) = v2(2,2).*c; 
        v2(1,1) = v2(1,1).*c;   
    end


plot([m3(1) v2(1,1)],[m3(2) v2(2,1)],'--b','LineWidth',3);   
plot([m3(1) v2(1,2)],[m3(2) v2(2,2)],'--b','LineWidth',3); 

 
 axis(range);

xlabel('Input Feature X1','FontSize',12,'FontWeight','bold'); ylabel('Input Feature X2','FontSize',12,'FontWeight','bold');
title(['Constant Density Curves & Eigen Vectors for Case ',num2str(caseno)],'FontSize',12,'FontWeight','bold');
legend({'Class 1','Class 2','Class 3'},'FontSize',12,'FontWeight','bold');
set(gca,'FontSize',14,'FontWeight','bold')
print('-djpeg', ['RD_Contours_Case_',num2str(caseno),'.jpg'], '-r300');
hold off


%% Plotting decision boundary
% 
figure;

plot(ttc1(1,:),ttc1(2,:),'ro',ttc2(1,:),ttc2(2,:),'g+',ttc3(1,:),ttc3(2,:),'bs');
legend({'Class 1 test data','Class 2 test data','Class 3 test data'},'FontSize',12,'FontWeight','bold');
hold on

range = [1*min(data(:,1)) 1*max(data(:,1)) 1*min(data(:,2)) .9*max(data(:,2))];
%range = [-15 20 -10 20];
axis(range);


xvals = linspace(1*min(data(:,1)), 1*max(data(:,1)), 50);
yvals = zeros(size(xvals));
yvals1 = zeros(size(xvals));
yvals2 = zeros(size(xvals));

[p q r] = case3par(m1,cov1,m2,cov2);
 f = @(x,y) p(1,1).*(x.^2) + p(1,2).*x.*y + p(2,1).*x.*y + p(2,2).*(y.^2) + q(1,1).*x + q(2,1).*y + r;
fimplicit(f,range,'--b','LineWidth',3); 


[p1 q1 r1] = case3par(m1,cov1,m3,cov3);
f1 = @(x,y) p1(1,1).*(x.^2) + p1(1,2).*x.*y + p1(2,1).*x.*y + p1(2,2).*(y.^2) + q1(1,1).*x + q1(2,1).*y + r1;
fimplicit(f1,range,'--g','LineWidth',3); 


[p2 q2 r2] = case3par(m2,cov2,m3,cov3);
f2 = @(x,y) p2(1,1).*(x.^2) + p2(1,2).*x.*y + p2(2,1).*x.*y + p2(2,2).*(y.^2) + q2(1,1).*x + q2(2,1).*y + r2;
fimplicit(f2,range,'--r','LineWidth',3); 


% for j = 1:length(xvals)
%  yvals(j) = fzero(@(y) f(xvals(j), y), 0);
%  yvals1(j) = fzero(@(y) f1(xvals(j), y), 0);
%  yvals2(j) = fzero(@(y) f2(xvals(j), y), 0);
% end

hold on


% To Color Specific Area
% plot(xvals, yvals,'--b',xvals,yvals1,'--g',xvals,yvals2,'--w','LineWidth', 3);
% area(xvals,yvals,20,'FaceColor','b')
% area(xvals,yvals1,20,'FaceColor','g')
%area(yvals,yvals1,20,'FaceColor','r')


contour(X11,X12,g1,'Linecolor','r','LineWidth', 2);
contour(X11,X12,g2,'Linecolor','g','LineWidth', 2);
contour(X11,X12,g3,'Linecolor','b','LineWidth', 2);

axis(range);
xlabel('Input Feature X1','FontSize',12,'FontWeight','bold'); ylabel('Input Feature X2','FontSize',12,'FontWeight','bold');
title(['Decision Boundary & Surface for Case ',num2str(caseno)],'FontSize',12,'FontWeight','bold');
set(gca,'FontSize',14,'FontWeight','bold')
print('-djpeg', ['RD_Decision_Boundary_Case_',num2str(caseno),'.jpg'], '-r300');

hold off


%% Testing on Testing data and finding predected Class 

 test = [ttc1 ttc2 ttc3];

predicttest = zeros(1,length(test));
op = [ones(1,length(ttc1)) 2*ones(1,length(ttc2)) 3*ones(1,length(ttc3))];

for i = 1:length(test)
    
    if (f(test(1,i),test(2,i)) > 0) && (f1(test(1,i),test(2,i)) > 0)
        predicttest(i) = 1;
    end 
    
    if (f(test(1,i),test(2,i)) < 0) && (f2(test(1,i),test(2,i)) > 0)
        predicttest(i) = 2;
    end 
    
    if (f1(test(1,i),test(2,i)) < 0) && (f2(test(1,i),test(2,i)) < 0)
        predicttest(i) = 3;
    end 
end



%% Plotting Confusion Matrix

myConfusionPlot(predicttest,op,caseno)


%% Calculating Scores

scoresc1 = zeros(1,length(test));
scoresc2 = zeros(1,length(test));
scoresc3 = zeros(1,length(test));

for i = 1:length(test)
    scoresc1(i) = myClassProbability(test(:,i),m1,cov1,m2,cov2,m3,cov3,1);
    scoresc2(i) = myClassProbability(test(:,i),m1,cov1,m2,cov2,m3,cov3,2);
    scoresc3(i) = myClassProbability(test(:,i),m1,cov1,m2,cov2,m3,cov3,3);
end

scores = [scoresc1; scoresc2; scoresc3]';

DetTargetScores = [scoresc1(1:150) scoresc2(151:300) scoresc3(301:450)];
DetNonTargetScores = [scoresc1(151:450) scoresc2(1:150) scoresc2(301:450) scores(1:300) ];

% To Plot Histogram of Scores
%  figure;
%  hist(scores);
 
% Callinf Function to Plot ROC Curve
myPlotRoc(scores,op);


disp('----end----');


end

