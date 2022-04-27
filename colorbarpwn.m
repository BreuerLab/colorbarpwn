function varargout = colorbarpwn(cmin, cmax, varargin)
%COLORBARPWN creates Positive-White-Negative colormap and colorbar.
% White is asigned to zero, if While location is not specified.
% Customized colormap/colorbar options are available for:
%   - automatic/manual Positive, White, and Negative color.
%   - automatic/manual Positive, Negative, or Positive-Negative colormap.
%   - automatic/manual White position (at zero or specified).
%   - reversed default Positive and Negative colors.
%   - number of colormap levels.
%   - LaTex colorbar label.
%   - log scale colormap with adjustable loginess.
%   - returning colorbar handle and/or colormap array.
% -------------------------------------------------------------------------
% Syntax:
%
% colorbarpwn(cmin, cmax)
% colorbarpwn(cmin, cmax, 'options')
% h = colorbarpwn(__)
% [h, cmap] = colorbarpwn(__)
% cmap = colorbarpwn(__, 'off')
% -------------------------------------------------------------------------
% Description:
%
% colorbarpwn(cmin, cmax), creates automatic colormap and colorbar based on
%                          caxis([cmin, cmax]), where White is at zero,
%                          Positive is in red, and Negative is in blue.
%
% 'options':
% (one input/output option can be used independently or with other options)
%
% colorbarpwn(__, 'rev'), creates reversed default colormap, where Positive
%                         is in blue and Negative is in red. 'rev' will be
%                         overwritten if 'colorP' or 'colorN' is manually
%                         specified.
%
% colorbarpwn(__, 'colorP', [R G B]), customizes Positive color with RGB.
%
% colorbarpwn(__, 'colorN', [R G B]), customizes Negative color with RGB.
%
% colorbarpwn(__, 'colorW', [R G B]), customizes White color with RGB.
%
% colorbarpwn(__, 'full'), enforces full Positive-Negative color map with
%                          White is at the middle of [cmin, cmax].
%
% colorbarpwn(__, 'full', Wvalue), enforces full Positive-Negative colormap
%                                  and specifies White position by Wvalue.
%
% colorbarpwn(__, 'level', Nlevel), customizes the number ofcolormap
%                                   levels. The default Nlevel is 128 if
%                                   not specified
%
% colorbarpwn(__, 'label', 'LaTeXString'), creates a LaTeX colorbar label.
%
% colorbarpwn(__, 'log'), creates log scale colormap for coarser
%                         increment near White (smaller White region) with
%                         defualt loginess = 1. (citation [1]).
%
% colorbarpwn(__, 'log', loginess), creates log scale colormap and
%                                   specifies the loginess value to make
%                                   smaller White region (loginess > 0) or
%                                   larger White region (loginess < 0).
%
% h = colorbarpwn(__), h returns a colorbar handle.
%
% [h, cmap] = colorbarpwn(__), h returns a colorbar handle and cmap
%                              returns the colormap array.
%
% cmap = colorbarpwn(__, 'off'), cmap returns the colormap array only,
%                                without generating the colorbar.
% -------------------------------------------------------------------------
% Examples:
%
% colorbarpwn(-1, 2, 'level', 20, 'colorP', [0.6 0.4 0.3]):
%   creates a colormap and a colorbar from -1 to 2 where 0 is in White
%   color with 20 levels on one side and with customized Positive color
%   [0.6 0.4 0.3].
%
% colorbarpwn(1, 2, 'log', 1.2, 'label', '$\alpha$'):
%   creates a colormap and a colorbar from 1 to 2 with only Positive color
%   where the White color region is shortened by a loginess of 1.2; the
%   colorbar label desplays $\alpha$ with LaTeX interpreter.
%
% [h, cmap] = colorbarpwn(-4, -2, 'full', 'colorW', [0.8 0.8 0.8], ...
%                         'colorN', [0.2 0.4 0.3]):
%   creates a colormap and a colorbar from -4 to -2 with full Positive to
%   Negative color spectrum where 0 is in customized White color
%   [0.8 0.8 0.8] and the Negative end of the spectrum is in customized
%   color [0.2 0.4 0.3]; h returns the colorbar handle.
%
% cmap = colorbarpwn(-2, 2, 'log', -1, 'rev', 'off'):
%   returns a 255 X 3 colormap array to cmap without creating the colorbar;
%   the colormap is with a reversed defualt color spectrum and the White
%   color region is enlarged by a loginess of 1.
%
% =========================================================================
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
% version 1.2.0
%   - Changed the function name from >>colorbarPWN to >>colorbarpwn for
%     friendlier user experience.
%   - Added an input argument 'off' for turning off which disables
%     generating the colorbar and returns the colormap array only.
%   - Updateds in headline description including a few examples.
% Xiaowei He
% 04/27/2022
% =========================================================================
% version 1.1.1
%   - Minor code improvement.
%   - Updates in headline descriptions.
% Xiaowei He
% 04/21/2022
% =========================================================================
% version 1.1.0
%   - Added an output argument for the colormap array.
%   - Added an input argument 'rev' for reversed default Positive and
%     Negative colors, where Positive is in blue and Negative is in red.
%   - Improved some logical structures.
%   - Updated some descriptions in the headlines.
% Xiaowei He
% 04/15/2022
% =========================================================================
% version 1.0.1
%   - Fixed a bug when output coloarbar handle.
% Xiaowei He
% 04/07/2022
% =========================================================================
% version 1.0.0
% Xiaowei He
% 03/30/2022
% =========================================================================

    nargoutchk(0, 2)
    narginchk(2, 16)
    % check input arguments
    if ~isscalar(cmin) || ~isscalar(cmax)
        error('colorbarpwn(cmin, cmax): specify cmin and cmax, must be scalars.')
    end
    if length(varargin) >= 1
        if isempty(find(strcmp(varargin{1}, {'level', 'label', 'colorP', 'colorN', 'colorW', 'log', 'full', 'rev', 'off'}), 1))
            error(['colorbar(cmin, cmax, ' num2str(varargin{1}) '): invalid input argument ' num2str(varargin{1}) '.'])
        else
            for i = 2 : length(varargin)
                if isnumeric(varargin{i}) && isnumeric(varargin{i-1})
                    error(['colorbar(cmin, cmax, ' num2str(varargin{i}) '): invalid input argument ' num2str(varargin{i}) '.'])
                 elseif ischar(varargin{i}) ...
                        && isempty(find(strcmp(varargin{i}, {'level', 'label', 'colorP', 'colorN', 'colorW', 'log', 'full', 'rev', 'off'}), 1)) ...
                        && ~strcmp(varargin{i-1}, 'label')
                    error(['colorbar(cmin, cmax, ''' varargin{i} '''): invalid input argument ''' varargin{i} '''.'])
                end
            end
        end

    end

    % full spectrum switch
    fullflag = ~isempty(find(strcmp(varargin, 'full'), 1));
    % W value specification switch
    if fullflag
        if length(varargin) > find(strcmp(varargin, 'full'), 1)
            fullpar = varargin{find(strcmp(varargin, 'full'), 1)+1};
            if isscalar(fullpar)
                if fullpar > cmin && fullpar < cmax
                    Wvalue = fullpar;
                else
                    error('colorbarpwn(cmin, cmax, ''full'', Wvalue): Wvalue must be within cmin < Wvalue < cmax.')
                end
            elseif ~iscalar(fullpar) && ~ischar(fullpar)
                error('colorbarpwn(cmin, cmax, ''full'', Wvalue): Wvalue must be a scalar when specified.')
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
        error('colorbarpwn(cmin, cmax): cmin must be less than cmax.')
    elseif cmin >= 0 && ~fullflag
        mapflag = 1;
    elseif cmax <= 0 && ~fullflag
        mapflag = -1;
    else
        mapflag = 0;
    end

    % colormap levels
    levelflag = ~isempty(find(strcmp(varargin, 'level'), 1));
    if levelflag
        if length(varargin) > find(strcmp(varargin, 'level'), 1)
            levelpar = varargin{find(strcmp(varargin, 'level'), 1)+1};
            if isscalar(levelpar) && isreal(levelpar) && levelpar > 0
                Nlevel = levelpar;
            else
                error('colorbarpwn(cmin, cmax, ''level'', Nlevel): Nlevel must be a real positive number.')
            end
        else
            error('colorbarpwn(cmin, cmax, ''level'', Nlevel): Nlevel must be specified.')
        end
    else
        Nlevel = 128;
    end

    % reversed default positive and negative color switch
    revflag = ~isempty(find(strcmp(varargin, 'rev'), 1));
    if revflag
        if length(varargin) > find(strcmp(varargin, 'rev'), 1) ...
           && isnumeric(varargin{find(strcmp(varargin, 'rev'), 1)+1})
            error(['colorbarpwn(cmin, cmax, ' num2str(varargin{find(strcmp(varargin, 'rev'), 1)+1}) ...
                   '): invalid input argument ' num2str(varargin{find(strcmp(varargin, 'rev'), 1)+1}) '.'])
        end
        dftP = [0.0000, 0.4470, 0.8210]; % default blue
        dftN = [0.8500, 0.2250, 0]; % default red
    else
        dftP = [0.8500, 0.2250, 0]; % default red
        dftN = [0.0000, 0.4470, 0.8210]; % default blue
    end


    % manual color switches
    % colorP
    Pflag = ~isempty(find(strcmp(varargin, 'colorP'), 1));
    if Pflag
        if length(varargin) > find(strcmp(varargin, 'colorP'), 1)
            Ppar = varargin{find(strcmp(varargin, 'colorP'), 1)+1};
            if ~ischar(Ppar) && isrow(Ppar) && length(Ppar) == 3
                colorP = Ppar;
            else
                error('colorbarpwn(cmin, cmax, ''colorP'', [R G B]): colorP input must be a 1x3 row array.')
            end
        else
            error('colorbarpwn(cmin, cmax, ''colorP'', [R G B]): colorP must be specified.')
        end
        if revflag
            warning('colarbarPWN(cmin, cmax, ''colorP'', [R G B], ''rev''): ''rev'' is overwritten since ''colorP'' is specified.')
        end
    else
        colorP = dftP; % default positive color
    end
    % colorN
    Nflag = ~isempty(find(strcmp(varargin, 'colorN'), 1));
    if Nflag
        if length(varargin) > find(strcmp(varargin, 'colorN'), 1)
            Npar = varargin{find(strcmp(varargin, 'colorN'), 1)+1};
            if ~ischar(Npar) && isrow(Npar) && length(Npar) == 3
                colorN = Npar;
            else
                error('colorbarpwn(cmin, cmax, ''colorN'', [R G B]): colorN input must be a 1x3 row array.')
            end
        else
            error('colorbarpwn(cmin, cmax, ''colorN'', [R G B]): colorN must be specified.')
        end
        if revflag
            warning('colarbarPWN(cmin, cmax, ''colorN'', [R G B], ''rev''): ''rev'' is overwritten since ''colorN'' is specified.')
        end
    else
        colorN = dftN; % default negative color
    end
    % colorW
    Wflag = ~isempty(find(strcmp(varargin, 'colorW'), 1));
    if Wflag
        if length(varargin) > find(strcmp(varargin, 'colorW'), 1)
            Wpar = varargin{find(strcmp(varargin, 'colorW'), 1)+1};
            if ~ischar(Wpar) && isrow(Wpar) && length(Wpar) == 3
                colorW = Wpar;
            else
                error('colorbarpwn(cmin, cmax, ''colorW'', [R G B]): colorW input must be a 1x3 row array.')
            end
        else
            error('colorbarpwn(cmin, cmax, ''colorW'', [R G B]): colorW must be specified.')
        end
    else
        colorW = [1, 1, 1]; % default white
    end
   
    % log scale colormap switch
    logflag = ~isempty(find(strcmp(varargin, 'log'), 1));
    % loginess value specification switch
    if logflag
        if length(varargin) > find(strcmp(varargin, 'log'), 1)
            logpar = varargin{find(strcmp(varargin, 'log'), 1)+1};
            if isscalar(logpar)
                if logpar ~= 0
                    loginess = logpar;
                else
                    error('colorbarpwn(cmin, cmax, ''log'', loginess): loginess must not be zero.')
                end
            elseif ~isscalar(logpar) && ~ischar(logpar)
                error('colorbarpwn(cmin, cmax, ''log'', loginess): loginess must a scalar when specified.')
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
    labelflag = ~isempty(find(strcmp(varargin, 'label'), 1));
    if labelflag
        if length(varargin) > find(strcmp(varargin, 'label'), 1)
            labelpar = varargin{find(strcmp(varargin, 'label'), 1)+1};
            if ischar(labelpar)
                labelstr = labelpar;
            else
                error('colorbarpwn(cmin, cmax, ''label'', ''LaTexString''): LaTexString must be a char variable.')
            end
        else
            error('colorbarpwn(cmin, cmax, ''label'', ''LaTexString''): LaTexString must be specified.')
        end
    end

    % colorbar generation switch
    offflag = ~isempty(find(strcmp(varargin, 'off'), 1));
    if offflag
        if length(varargin) > find(strcmp(varargin, 'off'), 1) ...
           && isnumeric(varargin{find(strcmp(varargin, 'off'), 1)+1})
            error(['colorbarpwn(cmin, cmax, ' num2str(varargin{find(strcmp(varargin, 'off'), 1)+1}) ...
                   '): invalid input argument ' num2str(varargin{find(strcmp(varargin, 'off'), 1)+1}) '.'])
        end
        % output
        if nargout == 2
            error('[h, cmap] = colorbarpwn(cmin, cmax, ''off''): cannot return colarbar handle h with input argument ''off''.')
        else
            varargout{1} = cmap;
        end
    end

    % output
    if ~offflag
        colormap(cmap)
        caxis([cmin, cmax])
        cb = colorbar;
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