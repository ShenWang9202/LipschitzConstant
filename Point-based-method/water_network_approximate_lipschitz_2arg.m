function lip = water_network_approximate_lipschitz_2arg(param,Dx,Du,lds,sample_size)
%Approximate the (locally) Lipschitz constant using low-discrepancy (LD) sequence
%Input: nonlinear function f(x,u) as fnonlin, 
%       nonlinear function constants and parameters as param;
%       bounds on x as Dx = [x1_lo x1_hi; x2_lo x2_hi; ...], 
%       bounds on u as Du = [u1_lo u1_hi; u2_lo u2_hi; ...], 
%       certain types of LD sequence as lds e.g. 'sobol' or 'halton' or 'random',
%       number of points to be computed as sample_size
%Output: approximation of lipschitz constant as lip
%Author: Sebastian A. Nugroho
%Date: 9/11/2018

%Check input
if nargin ~= 5
    warning('Function takes 6 arguments. Try again.');
    return;
end

%Number of states 
Nx = size(Dx,1);

%Number of inputs
Nu = size(Du,1);

%Create LD sequence of points
if isequal(lds,'sobol') == 1
%Create Sobol sequence 
    Px = sobolset(Nx);
%     Pu = sobolset(Nu);
elseif isequal(lds,'halton') == 1
%Create Halton sequence 
    Px = haltonset(Nx);
%     Pu = haltonset(Nu);
elseif isequal(lds,'random') == 1
    Pxr = rand(1*sample_size,Nx);
%     Pur = rand(1*sample_size,Nu);
end

%Compute jacobian matrix
%Variables
% x = sym('x', [Nx 1], 'real');
% u = sym('u', [Nu 1] ,'real');

%Initialize maximum norm of Jacobian
lip = -Inf;

%Nonlinear function
try
    fx = @water_dist_fun_point_based; %(x,param,param.nonlinear_type);
catch ME
   if (strcmp(ME.identifier,'MATLAB:UndefinedFunction'))
        warning('Nonlinear function is not found.');
   end
   return;
end
   
%Scale the random points to each domain
if isequal(lds,'random') ~= 1
    %Take the first sample_size points from the LD sequence
    Qx = net(Px,1*sample_size);
%     Qu = net(Pu,1*sample_size);

    %Scale Qx to the region Dx
    Q2x = zeros(size(Qx));
    for i = 1:Nx
        Q2x(:,i) = Qx(:,i)*abs(Dx(i,1)-Dx(i,2))+Dx(i,1);
    end

%     %Scale Qu to the region Du
%     Q2u = zeros(size(Qu));
%     for i = 1:Nu
%         Q2u(:,i) = Qu(:,i)*abs(Du(i,1)-Du(i,2))+Du(i,1);
%     end
else
    %Scale Qx to the region Dx
    Q2x = zeros(size(Pxr));
    for i = 1:Nx
        Q2x(:,i) = Pxr(:,i)*abs(Dx(i,1)-Dx(i,2))+Dx(i,1);
    end

%     %Scale Qu to the region Du
%     Q2u = zeros(size(Pur));
%     for i = 1:Nu
%         Q2u(:,i) = Pur(:,i)*abs(Du(i,1)-Du(i,2))+Du(i,1);
%     end
end

% %Select random points from Q2x -> wrong
% Vx = 1:1:sample_size;
% Vrandx = Vx(randperm(length(Vx),sample_size));
% 
% %Select random points from Q2u -> wrong
% Vu = 1:1:sample_size;
% Vrandu = Vu(randperm(length(Vu),sample_size));

%Select all pairs and compute the Lipschitz constant
for i = 1:sample_size 
   lipconcand = fx(Q2x(i,:)',param,param.nonlinear_type);
   if ~strcmp(param.mode,'max')
    lipconcands = sqrt(lipconcand);
   else
    lipconcands =lipconcand;
   end
   lip = max(lip,lipconcands);
end

end


    