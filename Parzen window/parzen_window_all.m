function px = parzen_window_all(data,x,h,row)
 % data is (36 * N) * 23
 % x is 36 * 23
  
   
   N = size(data,1);
   px = zeros(size(x,1),1);
   
   for j = 1:size(x,1)   
       for i=1:N  
           traindata = data(i,:);
           px(j) = px(j) + calculate_Gaussian_Kernel(traindata,x,h); 
       end
   end
   
   px = log(px);

end
