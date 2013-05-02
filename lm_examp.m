% Levenberg-Marquardt example/test

%   Henri Gavin, Dept. Civil & Environ. Engineering, Duke Univ. November 2005
%   modified from: ftp://fly.cnuce.cnr.it/pub/software/octave/leasqr/
%   Press, et al., Numerical Recipes, Cambridge Univ. Press, 1992, Chapter 15.

hold off

epsPlots = 0                             % 1: make .eps plots, 0: don't

% *** For this demonstration example, simulate some artificial measurements by
% *** adding random errors to the curve-fit equation.  

global	example_number

consts = [ 1.0 ];                         % optional vector of constants

example_number = 3;			  % which example to run.  

Npnt = 100;				  % number of data points

t = [1:Npnt]';				  % independent variable
% true value of parameters ...
if example_number == 1, p_true  = [ 20   10   1  50 ]'; end	
if example_number == 2, p_true  = [ 20  -24  30 -40 ]'; end	 
if example_number == 3, p_true  = [  6   20   1   5 ]'; end	

y_dat = lm_func(t,p_true,consts);
y_dat = y_dat + 0.1*randn(Npnt,1);	  % add random noise

% range of values for basic paramter search
a1 = 0.1*p_true(1):0.2*p_true(1):2*p_true(1);
a2 = 0.1*p_true(2):0.2*p_true(2):2*p_true(2);
a3 = 0.1*p_true(3):0.2*p_true(3):2*p_true(3);
a4 = 0.1*p_true(4):0.2*p_true(4):2*p_true(4);

% parameter search
for ia2 = 1:length(a2);
   for ia4 = 1:length(a4);
	pt = [ p_true(1)  a2(ia2) p_true(3) a4(ia4) ];
	delta_y = ( y_dat - lm_func(t,pt,consts) );
	X2(ia2,ia4) = (delta_y' * delta_y)/2;
   end
end

figure(1); % ------------ plot shape of Chi-squared objective function
 clf
 mesh(a2,a4,log10(X2))
  xlabel('p_2')
  ylabel('p_4')
  zlabel('log_{10}(\chi^2)')
plotfile = ['lm_exampA',int2str(example_number),'.eps'];
if epsPlots, print(plotfile,'-solid','-color','-deps','-F:18'); end

% *** Replace the lines above with a read-in of some
% *** experimentally-measured data.

% initial guess parameters  ...
if example_number == 1, p_init  = [  5   2  0.2  10 ]';  end
if example_number == 2, p_init  = [  4  -5  6    10 ]';  end
if example_number == 3, p_init  = [ 10  50  5    5.6 ]';  end

weight = Npnt/sqrt(y_dat'*y_dat);	  % sqrt of sum of data squared

p_min = -10*abs(p_init);
p_max =  10*abs(p_init);

figure(3)
 clf
 plot(t,y_dat,'o');
  xlabel('t')
  ylabel('y(t)')

[p_fit,Chi_sq,sigma_p,sigma_y,corr,R2,cvg_hst] =  ...
		lm('lm_func',p_init,t,y_dat,weight,-0.01,p_min,p_max,consts);

y_fit = lm_func(t,p_fit,consts);

disp('    initial    true       fit        sigma_p percent')
disp(' -------------------------------------------------------')
disp ([ p_init  p_true  p_fit sigma_p 100*abs(sigma_p./p_fit) ])

n = length(p_fit);

figure(2); % ------------ plot convergence history of fit
 clf
 subplot(211)
  plot( [1:length(cvg_hst(:,1))], cvg_hst(:,1:n), 'linewidth',4);
   legend('p_1','p_2','p_3','p_4');
   xlabel('iteration number')
   ylabel('parameter values')
 
 subplot(212)
  semilogy( [1:length(cvg_hst(:,1))],[ cvg_hst(:,n+1) cvg_hst(:,n+2) ], 'linewidth',4)
   legend('\chi^2','\lambda');
   xlabel('iteration number')
   ylabel('\chi^2 and \lambda')
plotfile = ['lm_exampB',int2str(example_number),'.eps'];
if epsPlots, print(plotfile,'-solid','-deps','-F:18'); end
 

figure(3); % ------------ plot data, fit, and confidence interval of fit
 clf
 subplot(211)
   plot(t,y_dat,'o', t,y_fit,'-', 'linewidth',2, t,y_fit+ 1.96*sigma_y,'-r', t,y_fit-1.96*sigma_y,'-r');
    legend('y_{data}','y_{fit}','y_{fit}+1.96\sigma_y','y_{fit}-1.96\sigma_y');
    xlabel('t')
    ylabel('y(t)')
 subplot(212)
   semilogy(t,sigma_y,'-r','linewidth',4);
    xlabel('t')
    ylabel('\sigma_y(t)')
plotfile = ['lm_exampC',int2str(example_number),'.eps'];
if epsPlots, print(plotfile,'-solid','-deps','-F:18'); end


figure(4); % ------------ plot histogram of residuals, are they Gaussean?
 clf
 hist(y_dat - y_fit)
  title('histogram of residuals')
  xlabel('y_{data} - y_{fit}')
  ylabel('count')
plotfile = ['lm_exampD',int2str(example_number),'.eps'];
if epsPlots, print(plotfile,'-solid','-deps','-F:18'); end

