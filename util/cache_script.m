function filename=cache_script( script, varargin )


options=varargin2options(varargin);
[verbosity,options]=get_option( options, 'verbosity', 1 );
check_unsupported_options(options,mfilename);

ws='caller';

store.deps=find_deps( script );
store.dep_dates=cellfun( @filedate, store.deps );
assignin( ws, 'really_long_and_strange_varname_493875ksdjfh', store );

tmp_name=[tempname '.mat'];
evalin( ws, strvarexpand( 'save $tmp_name$' ) );
[status, hash]=hash_matfile( tmp_name );


delete( tmp_name );
if ~status
    filename=fullfile( '.cache',  hash );
else
    filename='';
end


if ~isempty(filename) && exist([filename '.mat'],'file' )
    if verbosity>0
        fprintf( '%s => loading: %s\n', script, filename );
    end
    evalin( ws, ['load ' filename] );
else
    % Now evaluate the script in base workspace
    if verbosity>0
        fprintf( '%s => recomputing\n', script );
    end
    
    evalin( ws, script );
    makesavepath( filename );
    if ~isempty(filename)
        evalin( ws, ['save ' filename] );
    end
end

if nargout==0
    clear filename
end
