function h = plus(f, g)
%+	  Plus for chebfun2 objects.
%
% F + G adds F and G. F and G can be scalars or chebfun2 objects. 

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if ( ~isa(f, 'chebfun2') )  % ??? + CHEBFUN2
    
    h = plus(g, f);
    
elseif ( isempty( g ) )       % CHEBFUN2 + []
    
    f = chebfun2;     % return empty chebfun2.
    
elseif ( isempty( f ) )         % empty CHEBFUN2 + CHEBFUN2
    
    % return empty;
    
elseif ( isa( g, 'double' ) )   % CHEBFUN2 + DOUBLE
    g = chebfun2( g, f.domain );  % make into chebfun2
    
    h = plus( f, g );
    
elseif ( ~isa(g, 'chebfun2') ) % CHEBFUN2 + ???
    
    error( 'CHEBFUN2:plus:unknown', ...
        ['Undefined function ''plus'' for input arguments of type %s ' ...
        'and %s.'], class(f), class(g) );
    
else                          % CHEBFUN2 + CHEBFUN2
    
    % Domain Check: 
    if ( ~chebfun2.domainCheck(f, g) ) 
       error('CHEBFUN2:PLUS:DOMAIN', 'Inconsistent domains.'); 
    end
    
    % Check zero chebfun2 objects
    if ( iszero( f ) )
        h = g;
    elseif ( iszero( g ) )
        h = f;
    else
        % Add together two nonzero chebfun2 objects
        h = compression_plus(f, g);
        %h = chebfun2(@(x, y) feval(f, x, y) + feval(g, x, y), f.domain); 
    end 
end

end

% In case we need it for later: 
% 
function h = compression_plus(f, g)
% Add chebfun2 objects together by a compression algorithm.

% The algorithm is as follows: 
% If A = XY^T and B = WZ^T, then A + B = [X W]*[Y Z]^T,
% [Qleft, Rleft] = qr([X W])
% [Qright, Rright] = qr([Y Z])
% A = Qleft * (Rleft * Rright') * Qright'
% [U, S, V] = svd( Rleft * Rright' )
% A = (Qleft * U) * S * (V' * Qright')     -> new low rank representation

h = f;

fScl = diag( 1./f.pivotValues );
gScl = diag( 1./g.pivotValues );
cols = [f.cols g.cols];
rows = [f.rows g.rows];

[Qleft, Rleft] = qr( cols );
[Qright, Rright] = qr( rows );

Z = zeros( length(fScl), length(gScl) );
[U, S, V] = svd( Rleft * [fScl Z; Z.' gScl] * Rright.' );

h.cols = Qleft  * U;
h.rows = Qright * V;
h.pivotValues = 1./diag( S );

end