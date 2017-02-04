// Check if dependendcies are installed and loaded.
// If not, install and load them

// Dependencies
tb_name = "quapro"; // Quadratic and inear programming toolbox

if ~atomsIsLoaded(tb_name) then
    if ~atomsIsInstalled(tb_name) then
        atomsInstall(tb_name);
        if ~atomsIsInstalled(tb_name) then
            error(strcat(['Can not install ' tb_name]));
        end
    end

    atomsLoad(tb_name);   
    if ~atomsIsLoaded(tb_name) then
        error(strcat(['Can not load ' tb_name]));
    end
end

// Load macros
exec('ir_plotline.sci', -1);
exec('ir_scatter.sci', -1);
//exec('ir_predict.sci', -1);

disp('Interval Regression Toolbox is ready.');
