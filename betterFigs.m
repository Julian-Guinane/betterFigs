function betterFigs(varargin)
% BETTERFIGS Create and save high quality figures.
%   Examples:
%       betterFigs
%       betterFigs(gcf)
%       betterFigs(gcf, gca)
%       betterFigs(..., 'saveFig', <boolean>)
%       betterFigs(..., 'saveName', <string>)
%       betterFigs(..., 'fileType', <string>)
%       betterFigs(..., 'saveMFig', <boolean>)
%       betterFigs(..., 'saveWidth', <double>)
%       betterFigs(..., 'pageWidth', <double>)
%       betterFigs(..., 'dpi', <double>)
%       betterFigs(..., 'FontSize', <double>)
%       betterFigs(..., 'LineWidth', <double>)
%       betterFigs(..., 'MarkerSize', <double>)
%       betterFigs(..., 'clean', <boolean>)
%       betterFigs(..., 'showGrid', <boolean>)
%       betterFigs(..., 'showGridMinor', <boolean>)
%       betterFigs(..., 'saveDir', <string>)
%       betterFigs(..., 'shrinkLeg', <boolean>)
%       betterFigs(..., 'nColors', <int>)
%       betterFigs(..., 'isChart', <boolean>)
%       betterFigs(..., 'export_fig_args', <cell>)
% 
%   betterFigs allows you to easily set figure properties to consistently
%   produce high quality figures. Figures can then be easily saved into
%   vector formats to avoid any pixelation.
%   
%   Inputs:
%       gcf - handle of figure to apply changes to.
%       gca - handle of axis to apply changes to.
% 
%   Name-Value Pair Arguments:
%       'saveFig'       - <boolean> Default: false
%                       Whether to save given figure to file
%       'saveName'      - <string> Default: []
%                       Name of file to save figure to. Do not include file
%                       type (e.g. .png). If it exists, the 'Name' property of
%                       the given figure will also be used as the saveName.
%       'fileType'      - <string> Default: .pdf Options:
%                       '.pdf', '.eps', '.emf', '.svg', '.png', '.tif', '.jpg'
%                       and '.bmp'.
%                       File type to save figure as.
%       'saveMFig'      - <boolean> Default: false
%                       Whether to save the matlab-figure (.fig file) as well
%                       as the image/vector file.
%       'pageWidth'     - <double> Default: 15
%                       Width of page used in combination with the 'saveWidth'
%                       to resize the figure. Units of cm. Default value
%                       corresponds approximately to an A4 page with margins.
%       'saveWidth'     - <double> Default: 1
%                       Width (relative to the 'pageWidth' parameter) to resize
%                       the figure to.
%       'dpi'           - <double> Default: 1200
%                       Dots per inch resultion to save any raster files as.
%       'LineWidth'     - <double> Default: 1.5
%                       Width (in pt) to set all figure lines to.
%       'MarkerSize'    - <double> Default: 6
%                       Size (in pt) to set all figure markers to.
%       'clean'         - <boolean> Default: false
%                       Whether to remove all axes and grids.
%       'showGrid'      - <boolean> Default: true
%                       Whether to toggle major grid on.
%       'showGridMinor' - <boolean> Default: true
%                       Whether to toggle minor grid on.
%       'saveDir'       - <str> Default: 'Saved Images'
%                       Name of directory to save images to in the current
%                       working directory. If the directory doesn't exist, it
%                       is created.
%       'shrinkLeg'     - <boolean> Default: false
%                       Whether to shrink the line width and marker size in the
%                       legend to make it more compact.
%       'nColors'       - <int> Default: 4
%                       Number of line/marker colors to plot with
%       'isChart'       - <boolean> Default: false
%                       Whether current figure is a chart.
%       'export_fig_args'   - <cell> Default: {}
%                           Cell array of arguments to pass to the export_fig
%                           function for greater contol of file saving.
%   See also EXPORT_FIG, LINSPECER
    
    p = inputParser;
    addOptional(p, 'gcf', []);
    addOptional(p, 'gca', []);
    addParameter(p, 'saveFig', false);
    addParameter(p, 'saveName', []);
    addParameter(p, 'fileType', '.pdf');
    addParameter(p, 'saveMFig', false);
    addParameter(p, 'pageWidth', 15);
    addParameter(p, 'saveWidth', 1);
    addParameter(p, 'dpi', 1200);
    addParameter(p, 'FontSize', 10);
    addParameter(p, 'LineWidth', 1.5);
    addParameter(p, 'MarkerSize', 6);
    addParameter(p, 'clean', false);
    addParameter(p, 'showGrid', true);
    addParameter(p, 'showGridMinor', true);
    addParameter(p, 'saveDir', 'Saved Images');
    addParameter(p, 'shrinkLeg', false);
    addParameter(p, 'nColors', 4);
    addParameter(p, 'isChart', false);
    addParameter(p, 'export_fig_args', {});
    parse(p, varargin{:});
    

    % Warn user if default values not yet set and figures already exist
    if any(~[isequal(get(0, 'defaultAxesColorOrder'), linspecer(p.Results.nColors));...
             isequal(get(0, 'defaultAxesTickLabelInterpreter'), 'latex');...
             isequal(get(0, 'defaultLegendInterpreter'), 'latex');...
             isequal(get(0, 'defaultTextInterpreter'), 'latex');...
             isequal(get(0, 'defaultLegendLocation'), 'best')...
            ])
       
        if ~isempty(findall(0,'Type','Figure'))
            st = dbstack;
            warning('%s should be called at the top of the script to set figure defaults before any figures are made.\n', st(1).name);
        end
        
    end
    
    % Set default values
    set(0,'defaultAxesColorOrder', linspecer(p.Results.nColors));
    set(0,'defaultAxesTickLabelInterpreter','latex'); 
    set(0, 'defaultLegendInterpreter','latex');
    set(0,'defaultTextInterpreter','latex');
    set(0, 'defaultLegendLocation', 'best');

    % Returns if no figures open and no gcf and gca given
    if isempty(findall(0,'Type','Figure')) && isempty(p.Results.gcf) && isempty(p.Results.gca)
       return
    end
    
    % Sets gcf if not supplied
    if isempty(p.Results.gcf)
        cur_gcf = gcf;       
    else
        cur_gcf = p.Results.gcf;
    end
    
    % Sets gca if not supplied
    if isempty(p.Results.gca) && isempty(p.Results.gcf)
        cur_gca = gca;       
    elseif isempty(p.Results.gca)
        cur_gca = cur_gcf.CurrentAxes;
    else
        cur_gca = p.Results.gca;
    end
        
    % Set line properties
%     lines = findobj(cur_gcf,'Type','Line', '-or', 'Type','FunctionLine', '-or', 'Type', 'ErrorBar');
%     for i = 1:numel(lines)
%        lines(i).LineWidth =  p.Results.LineWidth;
%        lines(i).MarkerSize =  p.Results.MarkerSize;
%     end
    
    lineWidths = findobj(cur_gca.Children,'-property','LineWidth');
    lineWidths = findobj(lineWidths,'-not', 'Type', 'Histogram');
    lineWidths = findobj(lineWidths,'-not', 'Type', 'Histogram2');
    lineWidths = findobj(lineWidths,'-not', 'Type', 'Patch');
    
    for i = 1:numel(lineWidths)
       lineWidths(i).LineWidth = p.Results.LineWidth;
    end
    
    markerSizes = findobj(cur_gca.Children,'-property','MarkerSize');
    for i = 1:numel(markerSizes)
       markerSizes(i).MarkerSize = p.Results.MarkerSize;
    end
    
    
    % Set background color properties
    colorProperties = findobj(cur_gcf, '-depth', 1, '-property','Color');
    % Filter our colorbars
    colorProperties = findobj(colorProperties, 'flat', '-not', 'Type','ColorBar');
    for i = 1:numel(colorProperties)
       set(colorProperties(i), 'Color', [1 1 1]);  % Sets figure and axes background
    end

    % Set font size
    set(cur_gca,'fontsize', p.Results.FontSize);    
    
    if ~p.Results.isChart
        hold(cur_gca, 'on');
    end
    
    % Set grid properties
    if ~p.Results.clean
        if ~p.Results.isChart
            box(cur_gca,'on');
            if p.Results.showGrid
                grid(cur_gca, 'on')
                if p.Results.showGridMinor
                    grid(cur_gca, 'minor');
                end

                % set gridline properties
                set(cur_gca,'GridLineStyle','-')                            
                set(cur_gca,'MinorGridLineStyle','-')
                set(cur_gca,'GridColor','k')
                set(cur_gca,'MinorGridColor','k')
            end
        end
    else
        set(cur_gca, 'visible', 'off');
    end
    
    % Shrink legend markers
    if p.Results.shrinkLeg && ~isempty(cur_gca.Legend)
       leg = cur_gca.Legend;
       leg.ItemTokenSize = leg.ItemTokenSize/3; 
    end

    % Tighten axes if not aleady set
    if ~p.Results.isChart && ~any(contains(get(cur_gca, {'XLimMode', 'YLimMode', 'ZLimMode'}), 'manual'))
        axis tight
    end
    
    % Scale figure
    set(cur_gcf, 'Units', 'centimeters');
    pos = cur_gcf.Position;
    if p.Results.saveWidth ~= -1 && ~isprop(cur_gcf, 'OnlyLegendFlag')...
            && get(gcf, 'WindowStyle') ~= "docked"
        scale = p.Results.saveWidth * p.Results.pageWidth / pos(3);
        pos(3:4) = scale * pos(3:4);
        set(cur_gcf, 'Position', pos);
    end
    refresh(cur_gcf)
    

    %% Saving figure
    if isempty(p.Results.saveName)
        saveName = get(cur_gcf, 'Name');
    else
        saveName = p.Results.saveName;
    end
    
    if p.Results.saveFig
        if isempty(saveName)
            error("Figure 'Name' propertry not set, figure not saved.")
        end
        if ~exist(p.Results.saveDir, 'dir')
            warning("Image Directory does not exist, creating one now...");
            mkdir(p.Results.saveDir)
        end
        fullSavePath = fullfile(p.Results.saveDir, saveName);
%         export_fig(fullSavePath, p.Results.fileType, p.Results.dpi,'-nocrop', p.Results.export_fig_args{:});
%         if strcmp(p.Results.fileType, '.pdf')
%             exportgraphics(cur_gcf,strcat(fullSavePath, p.Results.fileType),'ContentType','vector');
%         else
%             exportgraphics(cur_gcf,strcat(fullSavePath, p.Results.fileType),'Resolution',p.Results.dpi);
%         end
        exportgraphics(cur_gcf,strcat(fullSavePath, p.Results.fileType),'Resolution',p.Results.dpi);
        
%         export_fig(fullSavePath, p.Results.fileType, strcat("-r", string(p.Results.dpi)),'-nocrop');
        if p.Results.saveMFig
            savefig(cur_gcf, fullSavePath)
        end
    end

end