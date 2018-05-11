function [newm,newcov,newprior,gnk] = myGMM1(oldm,cov,prior,x,k,noOfiter,diagonal,regularition)

x=x';
oldm=oldm';
suml=0;

if diagonal == 1
        for i = 1:k
            cov{i} = eye(size(x,1)).*diag(cov{i});
        end
end
    
if regularition > 0
    for i = 1:k
       cov{i}(cov{i} < regularition) = regularition;
      % cov{i} = (cov{i} < regularition).*regularition + cov{i};
    end
end

%%Calculating the initial Log Likelihood
for i=1:length(x)
    sumk=0;
    for j=1:k
        oldhood= prior(j)*calculateGPDF(x(:,i),oldm(:,j),cov{j});
        sumk = sumk + oldhood;
    end
    suml= suml + log(sumk);
end

oldhood=suml;
newhood=0;
itr=1;
newm=zeros(size(x,1),k);
newcov=cell(k,1);
newprior=zeros(k,1);
while (itr < noOfiter) && (abs(oldhood - newhood) > 0.01)  %(oldm - newm) ~= zeros(size(x,1),k) 
    %%Calculatng the Responsibilities gammas
    if itr > 1
        oldm=newm;
        cov=newcov;
        prior=newprior;
        oldhood=newhood;
    end
    
     
    gnk=zeros(length(x),k);
    for i=1:length(x)
        deno=0;
        for f=1:k
            deno = deno + prior(f)*calculateGPDF(x(:,i),oldm(:,f),cov{f});
        end
        if deno > 0
            for j=1:k
                gnk(i,j)= (prior(j)*calculateGPDF(x(:,i),oldm(:,j),cov{j}))./deno;
            end
        end
    end
    
    
    %%Calculating the new values of mean,cov,prior
    for i=1:k
        
       Nk=sum(gnk(:,i),1);
       
       if Nk > 0
           for t = 1:size(x,1)
               newm(t,i)= (sum(gnk(:,i).*(x(t,:))',1)./Nk)';
           end


           sumc=zeros(size(x,1),size(x,1));
           for j=1:length(x)
               sumc= sumc + gnk(j,i)*(x(:,j)-newm(:,i))*(x(:,j)-newm(:,i))';
           end
           newcov{i}=sumc./Nk;
       else
          newcov{i} = zeros(size(x,1),size(x,1));
       end
       newprior(i)=Nk/length(x);
    end
    
    if diagonal == 1
        for i = 1:k
            newcov{i} = eye(size(x,1)).*diag(newcov{i});
        end
    end

    if regularition > 0
        for i = 1:k
           newcov{i}(newcov{i} < regularition) = regularition;
          % newcov{i} = (newcov{i} < regularition).*regularition + newcov{i};
        end
    end

    
    %%Calculating new log likelihood
    newsuml=  0;
    for i=1:length(x)
    newsumk=0;
    for j=1:k
        newhood = newprior(j)*calculateGPDF(x(:,i),newm(:,j),newcov{j});
        newsumk = newsumk + newhood;
    end
    newsuml= newsuml + log(newsumk);
    end
    newhood=newsuml;
    itr=itr+1;
end

newm = newm';

disp(['Total number of Iterations for GMM for k = ',num2str(k),' is : ',num2str(itr)]);