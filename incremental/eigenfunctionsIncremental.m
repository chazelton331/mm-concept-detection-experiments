function [lambda_out,uu2,ii,jj] = eigenfunctionsIncremental(DATA,g,lambdas,NUM_EVECS,bins)
% small differences from the ale/eigenfunctions to adjust in Incremental
% method

CLIP_MARGIN = 2.5; %% percent  2.5 default by writers

nPoints = size(DATA,1);
nDims = size(DATA,2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 1. Choose smallest NUM_EVECS eigenfunctions over all input dimensions

%%% now get all eignvalues and find smallest k
all_l = lambdas(:);

%%% eliminate all the really tiny ones by setting them to be huge
q= all_l<1e-10;
all_l(q) = 1e10;

%%% sort for smallest
[lambda_out,ind] = sort(all_l);

%%% take first NUM_EVECS
use_l = ind(1:NUM_EVECS);

%%% get indices of picked eigenvectors
lambda_out = diag(lambda_out(1:NUM_EVECS));
[ii,jj]=ind2sub(size(lambdas),use_l);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 2. Do clipping of data distribution per dimension
LOWER = CLIP_MARGIN/100; %% clip lowest CLIP_MARIN percent
UPPER = 1-LOWER; % clip symmetrically

for a=1:nDims
    [clip_lower(a),clip_upper(a)] = percentile(DATA(:,a),LOWER,UPPER);
    q = DATA(:,a)<clip_lower(a);
    % set all values below threshold to be constant
    DATA(q,a) = clip_lower(a);
    q2 = DATA(:,a)>clip_upper(a);
    % set all values above threshold to be constant
    DATA(q2,a) = clip_upper(a);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 3. Interpolate DATA in smallest NUM_EVECS eigenfunctions
uu2 = zeros(nPoints,NUM_EVECS,'double');
fprintf('Interpolating data in eigenfunctions\n');
for a=1:NUM_EVECS
    %% get bin indices
    bins_out(:,a) = bins(:,jj(a));
    %% and function value
    uu(:,a) = g(:,ii(a),jj(a));
    %%% now lookup data in it.
    uu2(:,a) = interp1(bins_out(:,a),uu(:,a),DATA(:,jj(a)),'linear','extrap');
end
%%% make sure approx. eigenvectors are of unit length.
suu2 = sqrt(sum(uu2.^2));
uu2 = uu2 ./ (ones(nPoints,1) * suu2);

