clc;  close all;
k=4;
itr=10;
[t1,nt1,score1,a1]=myAssig3(1,k,itr);
[t2,nt2,score2,a2]=myAssig3(2,k,itr);

%% Uncomment this to plot ROC
figure;
myPlotRoc(score1',a1,k);
myPlotRoc(score2',a2,k);
t = 0:.5:1;
plot(t,t,'--k');
legend('Diagonal Covariance','Non Diagonal Covariance','Location','southeast');

hold off
set(gca,'FontSize',14,'FontWeight','bold')
print('-djpeg',['ROC_for_K_',num2str(k),'.jpg'], '-r300');


%% Uncomment this to plot DET
demo_main(t1,nt1,t2,nt2,k);
set(gca,'FontSize',10,'FontWeight','bold')
 print('-djpeg',['DET_for_K_',num2str(k),'.jpg'], '-r300');


% close all
