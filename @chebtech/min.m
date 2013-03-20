function [minVal, minPos] = min(f)
%MIN   Global minimum of a CHEBTECH on [-1,1].
%   MINVAL = MIN(F) returns the global minimum of the CHEBTECH F on [-1,1].
%
%   [MINVAL, MINPOS] = MIN(F) returns also a value such that MINVAL = F(MINPOS).
%
%   If F is complex-valued then absolute values are taken to determine maxima
%   but the resulting value corresponds to that of the original function. That
%   is, MINVAL = FEVAL(F, MINPOS) where [~, MINPOS] = MIN(ABS(F)).
%
% See also MAX, MINANDMAX.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% To avoid code duplication, we simply call MINANDMAX:
[minVal, minPos] = minandmax(f);
minVal = minVal(1,:);
minPos = minPos(1,:);

end
