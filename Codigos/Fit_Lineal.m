function [fitresult, gof] = Fit_Lineal(LogDeriva3i, LogKs1i)
%CREATEFIT(LOGDERIVA3I,LOGKS1I)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : LogDeriva3i
%      Y Output: LogKs1i
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 15-Dec-2022 18:50:28


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( LogDeriva3i, LogKs1i );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData, 'predobs' );
% legend( h, 'LogKs1i vs. LogDeriva3i', 'untitled fit 1', 'Lower bounds (untitled fit 1)', 'Upper bounds (untitled fit 1)', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'LogDeriva3i', 'Interpreter', 'none' );
% ylabel( 'LogKs1i', 'Interpreter', 'none' );
% grid on


