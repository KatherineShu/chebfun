classdef trigspec < spec
%TRIGSPEC    Fourier spectral method in coefficient space.
%   TRIGSPEC is an implementation of CHEBDISCRETIZATION that implements a
%   Fourier spectral method in coefficient space.
%
% See also TRIGCOLLOC.
%
% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS PROPERTIES:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties ( Access = public )
        coeffs        % Coefficients of the operator.
        outputSpace   % The range of the operator.
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS CONSTRUCTOR:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = false )
        
        function disc = trigspec(varargin)
            disc = disc@spec(varargin{:});
            % No dimension adjustment are required for TRIGSPEC.
            disc.dimAdjust = 0;
            disc.projOrder = 0;
        end
        
        % Dimension reduction for operator matrix.
        [PA, P, PS] = reduce(disc, A, S)
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% STATIC METHODS:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = true )
        
        function tech = returnTech()
            %RETURNTECH    Return the appropriate tech to use for TRIGSPEC.
            tech = @fourtech;
        end
        
        % Differentiation matrices for TRIGSPEC.
        D = diffmat(N, m)
        
        % Multiplication matrices for TRIGSPEC.
        D = multmat(N, f)
        
        % Output 1 for TRIGSPEC.
        outputSpace = getOutputSpace(source)
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PRIVATE STATIC METHODS:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = private, Static = true )
        
        % Construct a sparse Hankel operator.
        H = sphankel(r)
        
        % Sparse Toeplitz matrix.
        T = sptoeplitz(col, row)
        
    end
    
end
