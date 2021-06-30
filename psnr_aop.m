function psnrForAOP = psnr_aop(AOP, aop)

error1 = abs(AOP(:)-aop(:));
error2 = double(ones(numel(AOP),1)) - error1;

error = min(error1, error2);
mse = norm(error,2).^2/numel(AOP);

psnrForAOP = 10*log10(1/mse);

end