function [fitresult, gof] = Fit_Deriva_Rigidez_SinDano_Incremental(Deriva3i, Kc3i)
%CREATEFIT(DERIVA3I,KC3I)
%  Create a fit.
%
%  Data for 'PerdidaRigidez_Deriva(SinDano_Incrementales)' fit:
%      X Input : Deriva3i
%      Y Output: Kc3i
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 03-Nov-2022 13:48:40


%% Fit: 'PerdidaRigidez_Deriva(SinDano_Incrementales)'.
[xData, yData] = prepareCurveData( Deriva3i, Kc3i );

% Set up fittype and options.
ft = fittype( 'power2' );
excludedPoints = excludedata( xData, yData, 'Indices', 136 );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'Bisquare';% ver LAR o Bisquare para fit mas preciso
opts.StartPoint = [0.157671648320271 -0.223961653232148 0.0586472356900651];
opts.Exclude = excludedPoints;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'PerdidaRigidez_Deriva(SinDano_Incrementales)' );
% h = plot( fitresult, xData, yData, excludedPoints, 'predobs', 0.9 );
% legend( h, 'Kc3i vs. Deriva3i', 'Excluded Kc3i vs. Deriva3i', 'PerdidaRigidez_Deriva(SinDano_Incrementales)', 'Lower bounds (PerdidaRigidez_Deriva(SinDano_Incrementales))', 'Upper bounds (PerdidaRigidez_Deriva(SinDano_Incrementales))', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'Deriva3i', 'Interpreter', 'none' );
% ylabel( 'Kc3i', 'Interpreter', 'none' );
% grid on

