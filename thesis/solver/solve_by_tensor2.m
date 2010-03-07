underline( 'Tensor product PCG: ' );

%% general options
reltol=1e-3;

%% truncation options
options.eps=get_param( eps, 1e-4 );
options.trunc_mode=get_param( trunc_mode, 1 );
options.relcutoff=true;
options.vareps=get_param( vareps, false );
options.vareps_threshold=0.1;
options.vareps_reduce=0.1;
%options.G={P_I*G_N*P_I', G_X};

%% stats stuff
options.stats_func=@pcg_gather_stats;
options.stats=struct();
if exist('Ui_true', 'var')
    options.stats.X_true=Ui_true;
end
options.stats.trunc_options=trunc_options;
options.stats.G={P_I*G_N*P_I', G_X};

%% call pcg
opts=struct2options(options);
[Ui,flag,info,stats]=tensor_operator_solve_pcg( Ki, Fi, 'Minv', Mi_inv, 'reltol', reltol, opts{:} );


relerr=tensor_error( Ui, Ui_true, [], true );
k=tensor_rank(Ui);
if eps>0
    R=relerr/eps;
else
    R=1;
end

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
