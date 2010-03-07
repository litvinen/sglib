function y=operator_apply( A, x, varargin )
% OPERATOR_APPLY Apply a linear operator or matrix to a vector.
%   B=OPERATOR_APPLY ( A, X ) applies the linear operator A to the
%   vector X. If A is a matrix, then just A*X is returned, otherwise if A
%   is a cell array then, FUNCALL( A{2}, X ) is returned. The functionality is
%   rather trivial but makes it easier to handle both "types" of linear
%   operator in solver codes.
%
% Example (<a href="matlab:run_example operator_apply">run</a>)
%     M=[1, 2; 3, 4; 5, 10];
%     linop={ size(M), {@mtimes, {M}, {1} } };
%     linop2={ { @size, {M}, {1} }, {@mtimes, {M}, {1} } };
%     [m,n]=operator_size( linop2 );
%
%     x=ones(n,1);
%     y=zeros(m,0);
%     y=[y,operator_apply( M, x )];
%     y=[y,operator_apply( linop, x )];
%     y=[y,operator_apply( linop2, x )];
%     disp(y);
%
% See also OPERATOR, OPERATOR_SIZE, ISFUNCTION

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if isempty(A)
    % A is the identity
    y=x;
elseif isnumeric(A)
    % A is a matrix
    y=A*x;
elseif is_tensor_operator(A)
    y=tensor_operator_apply( A, x, varargin{:} );
elseif iscell(A) && isfunction(A{2})
    % A is an operator and secondelement contains function returning the
    % application of the linear operator
    y=funcall( A{2}, x, varargin{:} );
else
    error( 'operator_size:type', 'linear operator is neither a matrix nor a cell array' );
end
