function s = zeroDeltaFun(domain)
%ZERODELTAFUN   Constructs the zero DELTAFUN on DOMAIN. 
%   S = ZERODELTAFUN(DOMAIN) creates a DELTAFUN with no delta functions but
%   its FUNPART is the zero fun. If no DOMAIN is provided, the FUN is created
%   on [-1, 1].
%
% See also DELTAFUN.

% Copyright 2014 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

if ( nargin < 1 )
    pref = chebpref();
    domain = pref.domain;
end

% Create a zero fun on the domain:
f = fun.constructor(0, domain);

% Create a zero DELTAFUN object:
s = deltafun(f, [], []);

end