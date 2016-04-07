% ==============================================================================
% Name  : Dustin Kut Moy Cheung
% ID    : 996881147
% Course: Financial Engineering (APS-502)
% Title : Project Part 2
% ==============================================================================
clear all;

% ------------------------------------------------------------------------------
% Adjusted Closing prices :: expected returns generated from LibreOffice Math
% ------------------------------------------------------------------------------
spy = [
    -0.0352483227
    0.0455158044
    0.008295464
    0.0069515186
    0.0232063914
    0.0206448697
    -0.0134375846
    0.0394635655
    -0.0137963004
    0.0235509705
    0.0274719109
    -0.0025366163
    -0.0296292482
    0.0562045982
    -0.0157057063
    0.009833898
    0.0128561381
    -0.0203120824
    0.0225892458
    -0.0609501536
    -0.0255158707
    0.0850596726
    0.0036551785
    -0.0172825294
];

govt = [
    0.0123457395
    0.0029702447
    -0.0040195303
    0.0075083362
    0.0079059626
    -0.0018923266
    -0.0010096032
    0.0119361328
    -0.0066039772
    0.0102028058
    0.0086720256
    -0.0014622618
    0.0294234356
    -0.0174393929
    0.0060267439
    -0.0060748817
    -0.0031570803
    -0.0087163029
    0.0106425248
    -0.0008719184
    0.0090541481
    -0.0028366822
    -0.0039950914
    -0.0025455368
];

eemv = [
    -0.0813593364
    0.0358743423
    0.031746061
    0.0181818904
    0.0233515436
    0.0199067505
    0.0096554243
    0.0323165835
    -0.0448810344
    0.0127090293
    -0.0213011831
    -0.0300607959
    0.0118311777
    0.0253053815
    0.0044255541
    0.0545670211
    -0.034709929
    -0.0299482017
    -0.0379680316
    -0.0830780436
    -0.0208334163
    0.0505821098
    -0.0389759353
    -0.0197255554
];
% ------------------------------------------------------------------------------
% Calculate standard deviation, and co-variance of the 3 assets
% ------------------------------------------------------------------------------

% time period T is 24
arith_avg_spy  = sum(spy)  / 24;
arith_avg_govt = sum(govt) / 24;
arith_avg_eemv = sum(eemv) / 24;

% ===== Expected return ========================================================
expected_return_spy =  prod(1 + spy)  .^ (1 / 24) - 1;
expected_return_govt = prod(1 + govt) .^ (1 / 24) - 1;
expected_return_eemv = prod(1 + eemv) .^ (1 / 24) - 1;

% ===== Standard Deviation =====================================================
std_spy  = std(spy);
std_govt = std(govt);
std_eemv = std(eemv);

% ===== Co-variance ============================================================
covariance_spy_govt  = sum((spy - arith_avg_spy)   .* (govt - arith_avg_govt)) / 24;
covariance_spy_eemv  = sum((spy - arith_avg_spy)   .* (eemv - arith_avg_eemv)) / 24;
covariance_govt_eemv = sum((govt - arith_avg_govt) .* (eemv - arith_avg_eemv)) / 24;
covariance_spy_spy   = sum((spy - arith_avg_spy)   .* (spy - arith_avg_spy))   / 24;
covariance_govt_govt = sum((govt - arith_avg_govt) .* (govt - arith_avg_govt)) / 24;
covariance_eemv_eemv = sum((eemv - arith_avg_eemv) .* (eemv - arith_avg_eemv)) / 24;

% ==== Generate MVO Optimization ===============================================
Q = [covariance_spy_spy covariance_spy_govt covariance_spy_eemv
     covariance_spy_govt covariance_govt_govt covariance_govt_eemv
     covariance_spy_eemv covariance_govt_eemv covariance_eemv_eemv];

% x1, x2, x3 coefficients only
c = [0 0 0]';

% Set less or equal
A = -[expected_return_spy expected_return_govt expected_return_eemv];

Aeq = [1 1 1];
beq = [1];

ub = [inf; inf; inf];

% no short-selling
lb = [0; 0; 0];

x_axis = []
y_axis = []
for m = 0:0.00005:0.0060
    b = -[m];
    [x, fval] = quadprog(Q, c, A, b, Aeq, beq, lb, ub);
    x_axis = [x_axis; fval];
    expected_return = [expected_return_spy expected_return_govt expected_return_eemv] * x;
    y_axis = [y_axis; expected_return];
end

plot(x_axis, y_axis);
title('Efficient Frontier');
ylabel('Expected Return R');
xlabel('Portfolio Variance');

tix=get(gca,'xtick')';
set(gca,'xticklabel',num2str(tix,'%.4f'))

tiy=get(gca,'ytick')';
set(gca,'yticklabel',num2str(tiy,'%.4f'))
