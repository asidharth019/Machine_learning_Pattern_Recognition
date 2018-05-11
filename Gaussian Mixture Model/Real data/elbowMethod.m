function [  ] = elbowMethod( tdata1,vdata1,class )

it = 1;
rangek = 2:1:10;
sse = zeros(1,length(rangek));
for k=rangek

[idx1,m1,cov1,pi1] = myKMeans1(tdata1,k);

distance = zeros(k,1);
vidx1 = zeros(length(vdata1),1);
 for i = 1:length(vdata1)
     for j = 1:k
        distance(j,1) =  myeuclideanDistance(vdata1(i,:)',m1(j,:)');
     end
      [~,vidx1(i,1)] = min(distance);
 end

sse(1,it) = sumOfSquaredError(vdata1,vidx1,m1);


%[idx2,C,sumd,D] = kmeans(tdata1,k);
% sse(1,it) = sum(sumd);

it = it + 1;

end

plot(rangek,sse);
xlabel('Number of Cluster (K)'); ylabel('Sum of Squared Error');
title(['Elbow Method for Class ',(class)]);
set(gca,'FontSize',14,'FontWeight','bold')
print('-djpeg',['Elbow_Method_Class_',(class),'.jpg'], '-r300');
close all

end

