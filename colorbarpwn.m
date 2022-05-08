function varargout = colorbarpwn(varargin)
%COLORBARPWN creates Positive-White-Negative colormap and colorbar.
% White is asigned to zero, if While location is not specified.
% Customized colormap/colorbar options are available for:
%   - automatic/manual Positive, White, and Negative color.
%   - automatic/manual Positive, Negative, or Positive-Negative colormap.
%   - automatic/manual White position (at zero or specified).
%   - reversed default Positive and Negative colors.
%   - number of colormap levels.
%   - LaTeX colorbar label.
%   - log scale colormap with adjustable loginess.
%   - returning colorbar handle and/or colormap array.
% -------------------------------------------------------------------------
%
% Syntax:
%
% colorbarpwn(cmin, cmax)
% colorbarpwn(cmin, cmax, 'options')
% colorbarpwn(target, __)
% h = colorbarpwn(__)
% [h, cmap] = colorbarpwn(__)
% cmap = colorbarpwn(__, 'off')
% -------------------------------------------------------------------------
%
% Description:
%
% colorbarpwn(cmin, cmax): creates automatic colormap and colorbar based on
%                          caxis([cmin, cmax]), where White is at zero,
%                          Positive is in red, and Negative is in blue.
%
% 'options':
% (one input/output option can be used independently or with other options)
%
% colorbarpwn(__, 'rev'): creates reversed default colormap, where Positive
%                         is in blue and Negative is in red. 'rev' will be
%                         overwritten if 'colorP' or 'colorN' is manually
%                         specified.
%
% colorbarpwn(__, 'colorP', [R G B]): customizes Positive color with RGB.
%
% colorbarpwn(__, 'colorN', [R G B]): customizes Negative color with RGB.
%
% colorbarpwn(__, 'colorW', [R G B]): customizes White color with RGB.
%
% colorbarpwn(__, 'full'): enforces full Positive-Negative color map with
%                          White is at the middle of [cmin, cmax].
%
% colorbarpwn(__, 'full', Wvalue): enforces full Positive-Negative colormap
%                                  and specifies White position by Wvalue.
%
% colorbarpwn(__, 'level', Nlevel): customizes the number ofcolormap
%                                   levels. The default Nlevel is 128 if
%                                   not specified
%
% colorbarpwn(__, 'label', 'LaTeXString'): creates a LaTeX colorbar label.
%
% colorbarpwn(__, 'log'): creates log scale colormap for coarser
%                         increment near White (smaller White region) with
%                         defualt loginess = 1. (citation [1]).
%
% colorbarpwn(__, 'log', loginess): creates log scale colormap and
%                                   specifies the loginess value to make
%                                   smaller White region (loginess > 0) or
%                                   larger White region (loginess < 0).
%
% colorbarpwn(target, __): sets the colormap for the figure, axes, or chart
%                          specified by target, instead of for the current
%                          figure and adds a colorbar to the axes or chart
%                          specified by target. Specify the target axes or
%                          chart as the first argument in any of the
%                          previous syntaxes. Similar to the combined use
%                          of colormap(target, map) and colorbar(target).
%
% h = colorbarpwn(__): h returns a colorbar handle.
%
% [h, cmap] = colorbarpwn(__): h returns a colorbar handle and cmap
%                              returns the colormap array.
%
% cmap = colorbarpwn(__, 'off'): cmap returns the colormap array only,
%                                without creating the colorbar.
% -------------------------------------------------------------------------
%
% Examples:
%
% colorbarpwn(-1, 2, 'level', 20, 'colorP', [0.6 0.4 0.3]):
%   creates a colormap and a colorbar from -1 to 2 where 0 is in White
%   color with 20 levels on one side and with customized Positive color
%   [0.6 0.4 0.3].
%
% colorbarpwn(ax1, 1, 2, 'log', 1.2, 'label', '$\alpha$'):
%   on axis ax1, creates a colormap and a colorbar from 1 to 2 with only
%   Positive color where the White color region is shortened by a loginess
%   of 1.2; the colorbar label desplays $\alpha$ with LaTeX interpreter.
%
% h = colorbarpwn(ax2, 1, 3, 'full', 1.5):
%   on axis ax2, creates a colormap and a colorbar from 1 to 3 with full
%   default Positive-Negative color spectrum where White color is aligned
%   with the specified Wvalue 1.5 following the 'full' option; h returns
%   the colorbar handle.
%
% [h, cmap] = colorbarpwn(-4, -2, 'full', 'colorW', [0.8 0.8 0.8], ...
%                         'colorN', [0.2 0.4 0.3], 'level', 30):
%   creates a colormap and a colorbar from -4 to -2 with full
%   Positive-Negative color spectrum with 30 levels on each side where
%   White color is customized with [0.8 0.8 0.8] and the Negative end of
%   the spectrum is in customized color [0.2 0.4 0.3]; the White color is
%   aligned with the mean of cmin and cmax -3 on the colorbar since no
%   Wvalue is specifice with 'full' option; h returns the colorbar handle
%   and cmap returns the 59 X 3 colormap array generated.
%
% cmap = colorbarpwn(-2, 2, 'log', -1, 'rev', 'off'):
%   returns a 255 X 3 colormap array to cmap without creating the colorbar;
%   the colormap is with a reversed defualt color spectrum and the White
%   color region is enlarged by a loginess of 1.
% =========================================================================
%
% version 1.3.0
%   - Added support for setting colormap and displaying colorbar on
%     specific target, e.g., colorbarpwn(ax, cmin, cmax).
%   - Updates and corrections in headline description and examples.
% Xiaowei He
% 05/07/2022
% -------------------------------------------------------------------------
% version 1.2.0
%   - Changed the function name from >>colorbarPWN to >>colorbarpwn for
%     friendlier user experience.
%   - Added an option 'off' which disables creatting the colorbar and only
%     returns the colormap array.
%   - Updates in headline description including a few examples.
% Xiaowei He
% 04/27/2022
% -------------------------------------------------------------------------
% version 1.1.1
%   - Minor code improvement.
%   - Updates in headline descriptions.
% Xiaowei He
% 04/21/2022
% -------------------------------------------------------------------------
% version 1.1.0
%   - Added an output argument for the colormap array.
%   - Added an input argument 'rev' for reversed default Positive and
%     Negative colors, where Positive is in blue and Negative is in red.
%   - Improved some logical structures.
%   - Updated some descriptions in the headlines.
% Xiaowei He
% 04/15/2022
% -------------------------------------------------------------------------
% version 1.0.1
%   - Fixed a bug when output coloarbar handle.
% Xiaowei He
% 04/07/2022
% -------------------------------------------------------------------------
% version 1.0.0
% Xiaowei He
% 03/30/2022
% =========================================================================
%
% citation [1]
% Connor Ott (2017). Non-linearly Spaced Vector Generator
% https://www.mathworks.com/matlabcentral/fileexchange/64831-non-linearly-spaced-vector-generator,
% MATLAB Central File Exchange.
% function nonLinVec = nonLinspace(mn, mx, num)
%     loginess = 1.5; % Increasing loginess will decreasing the spacing towards
%                     % the end of the vector and increase it towards the beginning.
%     nonLinVec = (mx - mn)/loginess*log10((linspace(0, 10^(loginess) - 1, num)+ 1)) + mn;
% end
% =========================================================================

    nargoutchk(0, 2)
    narginchk(2, 17)
    % check input arguments
    % axis handle switch
    axflag = false;
    iax = 0;
    axmsg = '';
    if ishandle(varargin{1})
        axflag = true;
        iax = 1;
        axmsg = 'ax, ';
    end
    if nargin < 2+iax
        error(['colorbarpwm(' axmsg 'cmin cmax): not enough input arguments, must specify cmin and cmax.'])
    end

    % assign variables
    cmin = varargin{1+iax};
    cmax = varargin{2+iax};
    if ~isscalar(cmin) || ~isscalar(cmax)
        error(['colorbarpwn(' axmsg 'cmin, cmax): cmin and cmax must be scalars.'])
    end

    if length(varargin) > 2+iax
        options = varargin(3+iax:end);
    else
        options = {};
    end
    if length(options) >= 1
        if isempty(find(strcmp(options{1}, {'level', 'label', 'colorP', 'colorN', 'colorW', 'log', 'full', 'rev', 'off'}), 1))
            error(['colorbar(' axmsg 'cmin, cmax, ' num2str(options{1}) '): invalid input argument ' num2str(options{1}) '.'])
        else
            for i = 2 : length(options)
                if isnumeric(options{i}) && isnumeric(options{i-1})
                    error(['colorbar(' axmsg 'cmin, cmax, ' num2str(options{i}) '): invalid input argument ' num2str(options{i}) '.'])
                 elseif ischar(options{i}) ...
                        && isempty(find(strcmp(options{i}, {'level', 'label', 'colorP', 'colorN', 'colorW', 'log', 'full', 'rev', 'off'}), 1)) ...
                        && ~strcmp(options{i-1}, 'label')
                    error(['colorbar(' axmsg 'cmin, cmax, ''' options{i} '''): invalid input argument ''' options{i} '''.'])
                end
            end
        end

    end

    % full spectrum switch
    fullflag = ~isempty(find(strcmp(options, 'full'), 1));
    % W value specification switch
    if fullflag
        if length(options) > find(strcmp(options, 'full'), 1)
            fullpar = options{find(strcmp(options, 'full'), 1)+1};
            if isscalar(fullpar)
                if fullpar > cmin && fullpar < cmax
                    Wvalue = fullpar;
                else
                    error(['colorbarpwn(' axmsg 'cmin, cmax, ''full'', Wvalue): Wvalue must be within cmin < Wvalue < cmax.'])
                end
            elseif ~iscalar(fullpar) && ~ischar(fullpar)
                error(['colorbarpwn(' axmsg 'cmin, cmax, ''full'', Wvalue): Wvalue must be a scalar when specified.'])
            else
                Wvalue = (cmin + cmax)/2;
            end
        else
            Wvalue = (cmin + cmax)/2;
        end
    else
        Wvalue = 0;
    end

    % determine colormap range
    if cmin >= cmax
        error(['colorbarpwn(' axmsg 'cmin, cmax): cmin must be less than cmax.'])
    elseif cmin >= 0 && ~fullflag
        mapflag = 1;
    elseif cmax <= 0 && ~fullflag
        mapflag = -1;
    else
        mapflag = 0;
    end

    % colormap levels
    levelflag = ~isempty(find(strcmp(options, 'level'), 1));
    if levelflag
        if length(options) > find(strcmp(options, 'level'), 1)
            levelpar = options{find(strcmp(options, 'level'), 1)+1};
            if isscalar(levelpar) && isreal(levelpar) && levelpar > 0
                Nlevel = levelpar;
            else
                error(['colorbarpwn(' axmsg 'cmin, cmax, ''level'', Nlevel): Nlevel must be a real positive number.'])
            end
        else
            error(['colorbarpwn(' axmsg 'cmin, cmax, ''level'', Nlevel): Nlevel must be specified.'])
        end
    else
        Nlevel = 128;
    end

    % reversed default positive and negative color switch
    revflag = ~isempty(find(strcmp(options, 'rev'), 1));
    if revflag
        if length(options) > find(strcmp(options, 'rev'), 1) ...
           && isnumeric(options{find(strcmp(options, 'rev'), 1)+1})
            error(['colorbarpwn(' axmsg 'cmin, cmax, ' num2str(options{find(strcmp(options, 'rev'), 1)+1}) ...
                   '): invalid input argument ' num2str(options{find(strcmp(options, 'rev'), 1)+1}) '.'])
        end
        dftP = [0.0000, 0.4470, 0.8210]; % default blue
        dftN = [0.8500, 0.2250, 0]; % default red
    else
        dftP = [0.8500, 0.2250, 0]; % default red
        dftN = [0.0000, 0.4470, 0.8210]; % default blue
    end


    % manual color switches
    % colorP
    Pflag = ~isempty(find(strcmp(options, 'colorP'), 1));
    if Pflag
        if length(options) > find(strcmp(options, 'colorP'), 1)
            Ppar = options{find(strcmp(options, 'colorP'), 1)+1};
            if ~ischar(Ppar) && isrow(Ppar) && length(Ppar) == 3
                colorP = Ppar;
            else
                error(['colorbarpwn(' axmsg 'cmin, cmax, ''colorP'', [R G B]): colorP input must be a 1x3 row array.'])
            end
        else
            error(['colorbarpwn(' axmsg 'cmin, cmax, ''colorP'', [R G B]): colorP must be specified.'])
        end
        if revflag
            warning(['colorbarpwn(' axmsg 'cmin, cmax, ''colorP'', [R G B], ''rev''): ''rev'' is overwritten since ''colorP'' is specified.'])
        end
    else
        colorP = dftP; % default positive color
    end
    % colorN
    Nflag = ~isempty(find(strcmp(options, 'colorN'), 1));
    if Nflag
        if length(options) > find(strcmp(options, 'colorN'), 1)
            Npar = options{find(strcmp(options, 'colorN'), 1)+1};
            if ~ischar(Npar) && isrow(Npar) && length(Npar) == 3
                colorN = Npar;
            else
                error(['colorbarpwn(' axmsg 'cmin, cmax, ''colorN'', [R G B]): colorN input must be a 1x3 row array.'])
            end
        else
            error(['colorbarpwn(' axmsg 'cmin, cmax, ''colorN'', [R G B]): colorN must be specified.'])
        end
        if revflag
            warning(['colorbarpwn(' axmsg 'cmin, cmax, ''colorN'', [R G B], ''rev''): ''rev'' is overwritten since ''colorN'' is specified.'])
        end
    else
        colorN = dftN; % default negative color
    end
    % colorW
    Wflag = ~isempty(find(strcmp(options, 'colorW'), 1));
    if Wflag
        if length(options) > find(strcmp(options, 'colorW'), 1)
            Wpar = options{find(strcmp(options, 'colorW'), 1)+1};
            if ~ischar(Wpar) && isrow(Wpar) && length(Wpar) == 3
                colorW = Wpar;
            else
                error(['colorbarpwn(' axmsg 'cmin, cmax, ''colorW'', [R G B]): colorW input must be a 1x3 row array.'])
            end
        else
            error(['colorbarpwn(' axmsg 'cmin, cmax, ''colorW'', [R G B]): colorW must be specified.'])
        end
    else
        colorW = [1, 1, 1]; % default white
    end
   
    % log scale colormap switch
    logflag = ~isempty(find(strcmp(options, 'log'), 1));
    % loginess value specification switch
    if logflag
        if length(options) > find(strcmp(options, 'log'), 1)
            logpar = options{find(strcmp(options, 'log'), 1)+1};
            if isscalar(logpar)
                if logpar ~= 0
                    loginess = logpar;
                else
                    error(['colorbarpwn(' axmsg 'cmin, cmax, ''log'', loginess): loginess must not be zero.'])
                end
            elseif ~isscalar(logpar) && ~ischar(logpar)
                error(['colorbarpwn(' axmsg 'cmin, cmax, ''log'', loginess): loginess must a scalar when specified.'])
            else
                loginess = 1;
            end
        else
            loginess = 1;
        end
        nonLinspace = @(mn, mx, num) round((mx - mn)/loginess*log10((linspace(0, 10^(loginess) - 1, num)+ 1)) + mn, 4); % citation [1]
    end

    % generate colormap
    if logflag
        switch mapflag
            case 1
                mapP = [nonLinspace(colorW(1), colorP(1), Nlevel)', nonLinspace(colorW(2), colorP(2), Nlevel)', nonLinspace(colorW(3), colorP(3), Nlevel)'];
                cmap = mapP;
            case -1
                mapN = [nonLinspace(colorW(1), colorN(1), Nlevel)', nonLinspace(colorW(2), colorN(2), Nlevel)', nonLinspace(colorW(3), colorN(3), Nlevel)'];
                cmap = flip(mapN);
            case 0
                if abs(cmax-Wvalue) >= abs(cmin-Wvalue)
                    cratio = abs((cmin-Wvalue)/(cmax-Wvalue));
                    Nfactored = round(cratio*Nlevel);
                    mapP = [nonLinspace(colorW(1), colorP(1), Nlevel)', nonLinspace(colorW(2), colorP(2), Nlevel)', nonLinspace(colorW(3), colorP(3), Nlevel)'];
                    mapN = [nonLinspace(colorW(1), colorN(1), Nfactored)', nonLinspace(colorW(2), colorN(2), Nfactored)', nonLinspace(colorW(3), colorN(3), Nfactored)'];
                else
                    cratio = abs((cmax-Wvalue)/(cmin-Wvalue));
                    Nfactored = round(cratio*Nlevel);
                    mapP = [nonLinspace(colorW(1), colorP(1), Nfactored)', nonLinspace(colorW(2), colorP(2), Nfactored)', nonLinspace(colorW(3), colorP(3), Nfactored)'];
                    mapN = [nonLinspace(colorW(1), colorN(1), Nlevel)', nonLinspace(colorW(2), colorN(2), Nlevel)', nonLinspace(colorW(3), colorN(3), Nlevel)'];
                end
                mapPN = [flip(mapN(2:end, :)); colorW; mapP(2:end, :)];
                cmap = mapPN;
        end
    else
        switch mapflag
            case 1
                mapP = [linspace(colorW(1), colorP(1), Nlevel)', linspace(colorW(2), colorP(2), Nlevel)', linspace(colorW(3), colorP(3), Nlevel)'];
                cmap = mapP;
            case -1
                mapN = [linspace(colorW(1), colorN(1), Nlevel)', linspace(colorW(2), colorN(2), Nlevel)', linspace(colorW(3), colorN(3), Nlevel)'];
                cmap = flip(mapN);
            case 0
                if abs(cmax-Wvalue) >= abs(cmin-Wvalue)
                    cratio = abs((cmin-Wvalue)/(cmax-Wvalue));
                    Nfactored = round(cratio*Nlevel);
                    mapP = [linspace(colorW(1), colorP(1), Nlevel)', linspace(colorW(2), colorP(2), Nlevel)', linspace(colorW(3), colorP(3), Nlevel)'];
                    mapN = [linspace(colorW(1), colorN(1), Nfactored)', linspace(colorW(2), colorN(2), Nfactored)', linspace(colorW(3), colorN(3), Nfactored)'];
                else
                    cratio = abs((cmax-Wvalue)/(cmin-Wvalue));
                    Nfactored = round(cratio*Nlevel);
                    mapP = [linspace(colorW(1), colorP(1), Nfactored)', linspace(colorW(2), colorP(2), Nfactored)', linspace(colorW(3), colorP(3), Nfactored)'];
                    mapN = [linspace(colorW(1), colorN(1), Nlevel)', linspace(colorW(2), colorN(2), Nlevel)', linspace(colorW(3), colorN(3), Nlevel)'];
                end
                mapPN = [flip(mapN(2:end, :)); colorW; mapP(2:end, :)];
                cmap = mapPN;
        end
    end

    % colormap label
    labelflag = ~isempty(find(strcmp(options, 'label'), 1));
    if labelflag
        if length(options) > find(strcmp(options, 'label'), 1)
            labelpar = options{find(strcmp(options, 'label'), 1)+1};
            if ischar(labelpar)
                labelstr = labelpar;
            else
                error(['colorbarpwn(' axmsg 'cmin, cmax, ''label'', ''LaTexString''): LaTexString must be a char variable.'])
            end
        else
            error(['colorbarpwn(' axmsg 'cmin, cmax, ''label'', ''LaTexString''): LaTexString must be specified.'])
        end
    end

    % colorbar generation switch
    offflag = ~isempty(find(strcmp(options, 'off'), 1));
    if offflag
        if length(options) > find(strcmp(options, 'off'), 1) ...
           && isnumeric(options{find(strcmp(options, 'off'), 1)+1})
            error(['colorbarpwn(' axmsg 'cmin, cmax, ' num2str(options{find(strcmp(options, 'off'), 1)+1}) ...
                   '): invalid input argument ' num2str(options{find(strcmp(options, 'off'), 1)+1}) '.'])
        end
        % output
        if nargout == 2
            error(['[h, cmap] = colorbarpwn(' axmsg 'cmin, cmax, ''off''): cannot return colarbar handle h with input argument ''off''.'])
        else
            varargout{1} = cmap;
        end
    end

    % output
    % determine plot axis
    if axflag
        ax = varargin{1};
    else
        ax = gca;
    end

    if ~offflag
        colormap(ax, cmap)
        caxis([cmin, cmax])
        cb = colorbar(ax);
        cb.Label.Interpreter = 'latex';
        if labelflag
            cb.Label.String = labelstr;
        end
        % colorbar handle
        if nargout == 1
            varargout{1} = cb;
        elseif nargout == 2
            varargout{1} = cb;
            varargout{2} = cmap;
        end
    end
end