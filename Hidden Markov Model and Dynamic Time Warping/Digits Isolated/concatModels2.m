function [  ] = concatModels2(  )
%Concates HMM Model Files

mod1=textread('1.txt.hmm','%s');
mod2=textread('o.txt.hmm','%s');
mod3=textread('z.txt.hmm','%s');

sta1=str2num(cell2mat(mod1(2,1)));
sta2=str2num(cell2mat(mod2(2,1)));
sta3=str2num(cell2mat(mod3(2,1)));

s1=str2num(cell2mat(mod1(4,1)));
s2=str2num(cell2mat(mod2(4,1)));
s3=str2num(cell2mat(mod3(4,1)));

a1=zeros(2*sta1,s1+1);
 k=5;
for i=1:2*sta1
    for j=1:s1+1
        a1(i,j)= str2num(cell2mat(mod1(k,1)));
        k=k+1;
    end
end

a2=zeros(2*sta2,s2+1);
 k=5;
for i=1:2*sta2
    for j=1:s2+1       
        a2(i,j)= str2num(cell2mat(mod2(k,1)));
        k=k+1;
    end
end

a3=zeros(2*sta3,s3+1);
 k=5;
for i=1:2*sta3
    for j=1:s3+1
        a3(i,j)= str2num(cell2mat(mod3(k,1)));
        k=k+1;
    end
end

acell=cell(3,1);
acell{1}=a1;
acell{2}=a2;
acell{3}=a3;
for i = 1:3
    for j= 1:3
            f1=acell{i};
            f2=acell{j};
          
            
             f1(size(f1,1),:)=f2(1,:);
            f1(size(f1,1),1)=0.500000;
             f1(size(f1,1)-1,1)=0.500000;
    
            
            f2(size(f2,1),1)=0.000000;
            
            dummy1=f2(1,1:size(f2,2)); %double(zeros(1,size(f1,2))); 
            dummy1(1,1)=1.000000;  
                        
         
%             dummy = f2(size(f2,1),:);
            
             dummy=double(zeros(1,size(f1,2)));
          
            
%                 final=[f1;dummy;dummy1;f2];
               final=[f1;f2];
            
            file4=fopen(['hmm-1.04/tmp2/' num2str(i) num2str(j) '.txt'],'w');
            fprintf(file4,'%s','states: ');
            fprintf(file4,'%d\n',size(final,1)/2);
            fprintf(file4,'%s','symbols: ');
            fprintf(file4,'%d\n',size(final,2)-1);
            
            
            for p=1:size(final,1)
                for q=1:size(final,2)               
                    fprintf(file4,'%f ',final(p,q));                                
                end
                fprintf(file4,'\n');
                if mod(p,2) ==0
                    fprintf(file4,'\n');
                end
            end
            fclose(file4);
        end
    end
end




