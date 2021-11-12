function [con_plan,asset_plan,yplan,x] = main()


cd("C:\Users\sugarkhuu\Documents\phd\bonn\bonn_phd\macro1\matlab\ps2");

%% general

    global beta tau r TR T t1 y0 y1 a1 y_plan

    tau  = 0.5;
    r    = 0.04;
    t1   = 25;
    TR_years = 40;
    T_years  = 60;
    TR   = t1 + TR_years;
    T    = t1 + T_years;
    y0   = 1;
    y1   = 0.5 * y0;
    a1   = 0;

    scf_data = readmatrix('inc_wl_us_2019.csv'); % SCF data result from Python code 
    age      = scf_data(:,1);
    a2y_data = scf_data(:,5); % a/y ratio from SCF 2019 data
    y_plan   = yp(scf_data(:,4)); % income path SCF data while employed and 0.5 afterwards

%% 3a
disp("Starting 3a ----------")
    myfig.title    = 'Wealth-to-income over age';
    myfig.x_series = age;
    myfig.y_series = a2y_data;
    myfig.x_label  = 'AGE';
    myfig.fig_name = '3a_a2y_us_2019.png';

    
    myPlot(myfig);

disp("3a done!")
%% 3b
disp("Starting 3b ----------")
    beta    = 0.96;
    a2y_mod = make_a2y();   

    myfig.title    = 'Wealth-to-income over age';
    myfig.x_series = age;
    myfig.y_series = a2y_data;
    myfig.second_y = a2y_mod;
    myfig.x_label  = 'AGE';
    myfig.legend   = {'SCF Data',['Model with beta = ', sprintf('%.2f',beta)]};
    myfig.fig_name = '3b_a2y_model_vs_data.png';
    
    myPlot(myfig);
disp("3b done!")
%% 3c
disp("Starting 3c ----------")
    beta_grid = linspace(0.9,1,101); % grid of beta

    diff_struct = struct();
    diff_struct.dist = []; % distances between data and model (euclidean)
    diff_struct.beta = []; % betas corresponding to distances above

    for i = 1:length(beta_grid)
        beta    = beta_grid(i);
        a2y_mod = make_a2y();   
        dist = norm(a2y_data-a2y_mod);
        diff_struct.beta(end+1) = beta;
        diff_struct.dist(end+1) = dist;
%         plot(diff_struct.beta, diff_struct.dist);
%         pause;
%         hold on;

    end

%     keyboard
%     hold off;
    
    [val,id] = min(diff_struct.dist);
    last_beta = diff_struct.beta(id);
    beta = last_beta;
    a2y_mod = make_a2y();   

    plot(a2y_mod);hold on;plot(a2y_data);

    myfig.title    = 'Wealth-to-income over age';
    myfig.x_series = age;
    myfig.y_series = a2y_data;
    myfig.second_y = a2y_mod;
    myfig.x_label  = 'AGE';
    myfig.legend   = {'SCF Data',['Model with optimum beta = ', sprintf('%.3f',beta)]};
    myfig.fig_name = '3c_a2y_model_opt_vs_data.png';
    
    myPlot(myfig);
    
disp("3c done!")
disp("Done!")
end


function a2y_mod = make_a2y()
% make model wealth to income ratio - depends on the global variables,
% including and most importantly the beta

    global y_plan

    tol    = 1e-3;
    max_it = 1e3;

    % if there was more time: Make it more explicit that I am searching for
    % such an a_T which gives highest value
    % nonnegativity constraint needs to be added!!!
    x = fminbnd(@min_guess,0.1,0.9,optimset(TolX=tol,MaxIter=max_it)); % find optimal asset/wealth plan - here just take the last point aT
    [con_plan,~] = make_plan(x);        % create consumption plan for the optimal plan
    asset_plan   = backplan(con_plan);    % create asset/wealth plan with backward iteration
    a2y_mod      = (asset_plan./y_plan)';       % wealth to income ratio

end


function ass_plan = backplan(conp)
% because forward iteration exaggerates rounding error for constructing
% asset plan, I use backward iteration to create asset plan - Just an
% alternative to make_plan for asset, but more accurate - a_{t} =
% ((a_{t+1}+c(t)-y(t)))/(1+r_{t+1})

    global y_plan r

    aT              =  (conp(end)-y_plan(end))/(1+r);
    ass_plan        = zeros(length(y_plan),1)';
    ass_plan(end)   = aT*(1+r);
    ass_plan(end-1) = aT;

    for i=flip(3:length(y_plan))
        aT_           = (aT+conp(i-1)-y_plan(i-1))/(1+r);
        ass_plan(i-2) = aT_;
        aT            = aT_;
    end

end

function err = min_guess(aT)
% The objective is to find a guess such that the end point of asset from the backward induction gives
% the closest value of a_{T} to the initial guess of a_{T}. Difference is 'err' below.

    global r y1 y_plan

    cT             = aT + y1;                % Consumption at T for a given aT 
    [~,asset_plan] = make_plan(aT);

    % Objective is to minimize the following error of the guess for asset
    % plan
    err = abs(asset_plan(end) - aT);     % Difference between the initial guess of aT and the aT of the asset plan 

end

function [con_plan,asset_plan] = make_plan(aT)
% Construct consumption and asset plans based on the initial guess for a_{T} and backward induction. 

    global r y1 y_plan

    cT         = aT + y1;                % Consumption at T for a given aT 
    con_plan   = conp(cT);               % Backward imputation of consumption based on the Euler equation
    asset_plan = assp(y_plan,con_plan);  % Asset plan for the given consumption pattern
end

function con_plan = conp(ct)
% Consumption plan for given c_{T}
% ct - last period consumption

    global beta r T t1

    eu_fact  = 1/(beta*(1+r));           % Euler equation factor between consumption in two periods
    periods  = linspace(T-t1,0,T-t1+1);  % first to last period as array (decreasing)
    factors  = eu_fact.^periods;         % Euler factor between last and the rest of consumptions
    con_plan = ct*factors;               % Consumption in each period as multiple of the last consumption owing to the Euler equation
end

function asset_plan = assp(y,c)
% Asset plan for given consumption plan and the exogenous income plan
% y - income plan, c - consumption plan

    global r a1

    a1_in      = a1; % given as 0
    periods    = length(y);
    asset_plan = zeros(periods,1)';

    i = 1;
    while i < periods
        a2            = (1+r)*a1_in+y(i)-c(i);    % a_{t+1} = (1+r)a_{t} + y_{t} - c_{t} from the budget constraint
        asset_plan(i) = a2;            
        a1_in         = a2;
        i = i + 1;
    end
    
    asset_plan(i) = (1+r)*a1_in; % the last asset will be totally consumed. Saving here for information purpose. a_{T} = (1+r)*a_{T-1}

end

function y_plan = yp(scf_y)
% Income plan that is exogenous [scf25,...scf40,0.5,...,0.5]

    global TR T t1 y0 y1

    y_working = scf_y(1:(TR-t1+1))'; % income while employed
    y_pension = ones(T-TR,1)'*0.5;
    y_plan    = [y_working, y_pension];

end

function myPlot(varargin)

    arg_list = varargin{:};

    f = figure('visible','off');
    plot(arg_list.x_series, arg_list.y_series,LineWidth=2);
    grid;

    if isfield(arg_list,'second_y')
        hold on
        plot(arg_list.x_series, arg_list.second_y,LineWidth=2);
        hold off
    end 

    if isfield(arg_list,'title')
         title(arg_list.title,FontSize=15);
    end 

    if isfield(arg_list,'xlabel')
        xlabel(arg_list.x_label);
    end 

    if isfield(arg_list,'legend')
        legend(arg_list.legend,'Location','northwest');
      end 

    if isfield(arg_list,'fig_name')
        saveas(f,arg_list.fig_name);
    end 

end