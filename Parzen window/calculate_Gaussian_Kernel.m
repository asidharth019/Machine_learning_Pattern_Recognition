function density = calculate_Gaussian_Kernel(x, y, h)
 % Returns Gaussian Kernel of x & y
 
    d = x - y;
    d_norm = d*d';
    deno = sqrt(2*pi*h^2)^size(x,2);
    density = exp(-(d_norm/(2*h^2)))/deno;
    
end
