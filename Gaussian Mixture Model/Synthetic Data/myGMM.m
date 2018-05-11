unction [newm,newcov,newprior,id] = myGMM(m,cov,prior,x,k,caseno,iteration)

x=x';
m=m';
suml=0;
%%Calculating the initial Log Likelihood
oldhood=0;
for i=1:length(x)
    sumk=0;
    for j=1:k
        oldhood= prior(j)*(1/(power(2*pi,2/2)*sqrt(det(cov{j}))))*exp(-1/2*((x(:,i)-m(:,j))'*(pinv(cov{j}))*(x(:,i)-m(:,j))));
        sumk = sumk + oldhood;
    end
    suml= suml + log(sumk);
end
oldhood=suml;
newhood=0;
itr=1;
newm=zeros(2,k);
newcov=cell(k,1);
newprior=zeros(k,1);
while  (itr < iteration) && (abs(oldhood-newhood)>0.01)
    %%Calculatng the Responsibilities gammas
    if itr > 1
        m=newm;
        cov=newcov;
        prior=newprior;
        oldhood=newhood;
    end
    gnk=zeros(length(x),k);
    for i=1:length(x)
        deno=0;
        for f=1:k
            deno = deno + prior(f)*(1/(power(2*pi,2/2)*sqrt(det(cov{f}))))*exp(-1/2*((x(:,i)-m(:,f))'*(pinv(cov{f}))*(x(:,i)-m(:,f))));
        end
        for j=1:k
            gnk(i,j)= (prior(j)*(1/(power(2*pi,2/2)*sqrt(det(cov{j}))))*exp(-1/2*((x(:,i)-m(:,j))'*(pinv(cov{j}))*(x(:,i)-m(:,j)))))/deno;
        end
    end
    %%Calculating the new values of mean,cov,prior
    for i=1:k
       Nk=sum(gnk(:,i),1);
       newm(:,i)= (sum([gnk(:,i).*(x(1,:))' gnk(:,i).*(x(2,:))'],1))';
       if Nk ~= 0
           newm(:,i)=newm(:,i)/Nk;
       end
       sumc=zeros(2,2);
       for j=1:length(x)
           sumc= sumc + gnk(j,i)*(x(:,j)-newm(:,i))*(x(:,j)-newm(:,i))';
       end
       newcov{i}=sumc;
       if Nk ~= 0
           newcov{i}=newcov{i}/Nk;
       end
        if caseno == 1
          newcov{i}(1,2)=0;
          newcov{i}(2,1)=0;
        end
       newprior(i)=Nk/length(x);
    end
    %%Calculating new log likelihood
    suml=0;
    for i=1:length(x)
        sumk=0;
        for j=1:k
            val= newprior(j)*(1/(power(2*pi,2/2)*sqrt(det(newcov{j}))))*exp(-1/2*((x(:,i)-newm(:,j))'*(pinv(newcov{j}))*(x(:,i)-newm(:,j))));
            sumk = sumk + val;
        end
        suml= suml + log(sumk);
    end
    newhood=suml;
    itr=itr+1;
end
id=zeros(length(x),1);
for i=1:length(x)
    post=zeros(k,1);
    for j=1:k
        post(j,1)= newprior(j)*(1/(power(2*pi,2/2)*sqrt(det(newcov{j}))))*exp(-1/2*((x(:,i)-newm(:,j))'*(pinv(newcov{j}))*(x(:,i)-newm(:,j))));
    end
    [~,id(i)]=max(post(:,1));
end

end