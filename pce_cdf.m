function y=pce_cdf( x, X_alpha, I_X, varargin )
% PCE_CDF Short description of pce_cdf.
%   PCE_CDF Long description of pce_cdf.
%
% Example (<a href="matlab:run_example pce_cdf">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[N,options]=get_option(options,'N',10000);
check_unsupported_options(options,mfilename);


m=size(I_X,2);
y_r=linspace(0,1,N);
xi=randn(m,N);
x_r=pce_evaluate( X_alpha, I_X, xi );
x_r=sort(x_r);
rmind=(abs(x_r(2:end)-x_r(1:end-1))==0);
x_r(rmind)=[];
y_r(rmind)=[];
y=interp1(x_r, y_r, x, 'pchip', NaN );
y(isnan(y) & (x<=x_r(1)))=0;
y(isnan(y) & (x>=x_r(end)))=1;

