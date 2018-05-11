function px = parzen_window(data,x,h)
 % data is (36 * N) * 23
 % x is 36 * 23
  
   
   N = size(data,1)/size(x,1);
   density = zeros(size(x,1),1);
   
   for j = 1:size(x,1)   
       for i=1:N  
           traindata = data((i-1)*36 + 1:i*36,:);
           density(j) = density(j) + calculate_Gaussian_Kernel(traindata(j,:), x(j,:),h); 
       end
   end
   
   density = density/N; 
   density = log(density);
    px = mean(density);

end
