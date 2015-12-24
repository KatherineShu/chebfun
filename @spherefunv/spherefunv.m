%SPHEREFUNV   Class constructor for SPHEREFUNV objects.
% 
% SPHEREFUNV(F,G,H) constructs a SPHEREFUNV with two components from the
% function handles F, G, and H.  These can also be SPHEREFUN objects or any
% other object that the SPHEREFUN constructor accepts.  Each component is
% represented as a SPHEREFUN.
%
% SPHEREFUNV(F,G,H,[A B C D]) constructs a SPHEREFUNV object from F, G, and
% H on the domain [A B] x [C D].
%
% See also SPHEREFUN. 

classdef spherefunv
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS PROPERTIES:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties ( Access = public )
        components   % Array of SPHEREFUN objects.
        isTransposed % transposed?
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% STATIC METHODS:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = true )
        % Unit normal vector
        n = unormal( dom );        
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS CONSTRUCTOR:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Static = false )
        
        function F = spherefunv( varargin )
            % The main SPHEREFUNV constructor!
                       
            % Return an empty SPHEREFUNV:
            if ( (nargin == 0) || isempty(varargin) )
                return
            end
                       
            % This function calls the SPHEREFUN2 constructor once for each 
            % non-zero component because a SPHEREFUN2V is just vector of 
            % SPHEREFUN2 objects.
            
            % If the argument is a SPHEREFUN2V, nothing to do:
            if ( isa(varargin{1}, 'spherefunv') ) 
                F = varargin{1};
                return
            end
            
            % Go and try find the domain: 
            domain = [-pi pi 0 pi];
            for jj = 1:numel(varargin)
               if ( isa( varargin{jj}, 'double') && numel( varargin{jj}) == 4 ) 
                   domain = varargin{jj}; 
                   varargin(jj) = []; 
               elseif ( isa( varargin{jj}, 'spherefun') ) 
                   domain = varargin{jj}.domain;  
               end
            end
            
            % Go pick up vectorize flag: 
            vectorize = 0; 
            for jj = 1:numel(varargin) 
                if ( strcmpi( varargin{jj}, 'vectorize' ) )
                    vectorize = 1;
                    varargin(jj) = []; 
                end
            end
            
            % Unwrap input arguments;
            component = 1;
            for jj = 1:numel( varargin )
                if ( iscell( varargin{jj} ) ) 
                    for kk = 1:numel( varargin{jj} )
                        fh{component} = varargin{jj}{kk};
                        component = component + 1; 
                    end
                else
                    fh{component} = varargin{jj};
                    component = component + 1;
                end
            end
            varargin = fh; 
            
            % Convert all function handles to spherefun objects: 
            for jj = 1:numel(varargin)
                if ( isa( varargin{jj}, 'function_handle') )
                    if ( ~vectorize )
                        newcheb = spherefun( varargin{jj}, domain);
                    else
                        newcheb = spherefun( varargin{jj}, domain, 'vectorize');
                    end
                    fh{jj} = newcheb;
                elseif ( isa( varargin{jj}, 'spherefun') )
                    fh{jj} = varargin{jj};
                elseif ( isa( varargin{jj}, 'chebfun') )
                    fh{jj} = spherefun( varargin{jj}, domain);
                elseif ( isa( varargin{jj}, 'double') )
                    fh{jj} = spherefun( varargin{jj}, domain);  
                end
            end

            % Stop now if there are too many components
            if ( numel( fh ) > 3 ) 
                error('SPHEREFUN:SPHEREFUN2V:spherefunv:arrayValued', ...
                          'More than three components is not supported.')
            end 
            
            % Stop now if there are too few components: 
            if ( numel( fh ) < 3 ) 
                error('SPHEREFUN:SPHEREFUN2V:spherefunv:arrayValued', ...
                'Less than three components is not supported.')
            end

            % Stop now if there are no components: 
            if ( numel( fh ) == 0 ) 
                error('SPHEREFUN:SPHEREFUN2V:spherefunv:empty', ...
                'The Chebfun2 constructor needs to be given function handles or chebfun2 objects.')
            end
            
            % Check the domains of all the spherfuns are the same:
            pass = zeros(numel(fh)-1,1);
            for jj = 2:numel(fh)
               pass(jj-1) = domainCheck( fh{1}, fh{jj});   
            end
            
            if ( ~all(pass) )
                error('SPHEREFUN:SPHEREFUN2V:spherefunv:domainCheck', ...
                    'All spherefun objects need to have the same domain.');
            end
            
            % Assign to the spherfunv object: 
            F.components = fh;
            F.isTransposed = 0;

        end
    end 
    
end
