# colorbarpwn
Positive-white-negative colormap with zero in white - colorbarpwn

Create positive-white-negative colormap and colorbar. Customized colormap/colorbar options are available.

[h, cmap] = colorbarpwn(caxis1, caxis2, 'options')

COLORBARPWN creates positive-white-negative colormap and colorbar.

White is asigned to zero, if while location is not specified.

Customized colormap/colorbar options are available for:

  - automatic/manual positive, white, and negative color.
  - automatic/manual positive, negative, or positive-negative colormap.
  - automatic/manual white position (at zero or specified).
  - reversed default positive and negative colors.
  - reversed colorbar direction by switching the order of input limits.
  - number of colormap levels.
  - LaTeX colorbar label.
  - log scale colormap with adjustable loginess.
  - returning colorbar handle and/or colormap array.

-------------------------------------------------------------------------

Syntax:

colorbarpwn(caxis1, caxis2)

colorbarpwn(caxis1, caxis2, 'options')

colorbarpwn(target, __)

h = colorbarpwn(__)

[h, cmap] = colorbarpwn(__)

cmap = colorbarpwn(__, 'off')

-------------------------------------------------------------------------

Description:

colorbarpwn(caxis1, caxis2): 

creates automatic colormap and colorbar
                             based on caxis([cmin, cmax]), where
                             cmin = min([caxis1, caxis2]) and
                             cmax = max([caxis1, caxis2]). The colormap
                             has a default style in which zero is in
                             white, positive is in red, and negative is
                             in blue. When caxis1 < caxis2, the colorbar
                             is displayed in 'normal' direction; when
                             caxis1 > caxis2, the colorbar is displayed
                             in 'reversed' direction.

'options':

(one input/output option can be used independently or with other options)

colorbarpwn(__, 'rev'): 

creates reversed default colormap, where positive
                        is in blue and negative is in red. 'rev' will be
                        overwritten if 'colorP' or 'colorN' is manually
                        specified.

colorbarpwn(__, 'colorP', [R G B]): 

customizes positive color with RGB.

colorbarpwn(__, 'colorN', [R G B]): 

customizes negative color with RGB.

colorbarpwn(__, 'colorW', [R G B]): 

customizes white/zero color with RGB.

colorbarpwn(__, 'full'): 

enforces full positive-negative color map with
                         white is at the middle of [cmin, cmax].

colorbarpwn(__, 'full', Wvalue): 

enforces full positive-negative colormap
                                 and specifies white position by Wvalue.

colorbarpwn(__, 'level', Nlevel): 

customizes the number of colormap
                                  levels. The default Nlevel is 128 if
                                  not specified

colorbarpwn(__, 'label', 'LaTeXString'):

creates a LaTeX colorbar label.

colorbarpwn(__, 'log'): 

creates log scale colormap for coarser
                        increment near White (smaller White region) with
                        defualt loginess = 1. (citation [1]).

colorbarpwn(__, 'log', loginess):

creates log scale colormap and
                                  specifies the loginess value to make
                                  smaller White region (loginess > 0) or
                                  larger White region (loginess < 0).

colorbarpwn(target, __): 

sets the colormap for the figure, axes, or chart
                         specified by target, instead of for the current
                         figure and adds a colorbar to the axes or chart
                         specified by target. Specify the target axes or
                         chart as the first argument in any of the
                         previous syntaxes. Similar to the combined use
                         of colormap(target, map) and colorbar(target).

h = colorbarpwn(__): 

h returns a colorbar handle.

[h, cmap] = colorbarpwn(__):

h returns a colorbar handle and cmap
                             returns the colormap array.

cmap = colorbarpwn(__, 'off'):

cmap returns the colormap array only,
                               without creating the colorbar.
                               
-------------------------------------------------------------------------

Examples:

colorbarpwn(-1, 2, 'level', 20, 'colorP', [0.6 0.4 0.3]):

  creates a colormap and a colorbar from -1 to 2 where 0 is in White
  color with 20 levels on one side and with customized positive color
  [0.6 0.4 0.3].

colorbarpwn(ax1, 2, 1, 'log', 1.2, 'label', '$\alpha$'):

  on axis ax1, creates a colormap and a colorbar from 1 to 2 with only
  positive color where the white color region is shortened by a loginess
  of 1.2; the colorbar is displayed in reversed direction since 2 > 1;
  the colorbar label desplays $\alpha$ with LaTeX interpreter.

h = colorbarpwn(ax2, 1, 3, 'full', 1.5):

  on axis ax2, creates a colormap and a colorbar from 1 to 3 with full
  default positive-negative color spectrum where white color is aligned
  with the specified Wvalue 1.5 following the 'full' option; h returns
  the colorbar handle.

[h, cmap] = colorbarpwn(-4, -2, 'full', 'colorW', [0.8 0.8 0.8], ...
                        'colorN', [0.2 0.4 0.3], 'level', 30):
                        
  creates a colormap and a colorbar from -4 to -2 with full
  positive-negative color spectrum with 30 levels on each side where
  white color is customized with [0.8 0.8 0.8] and the negative end of
  the spectrum is in customized color [0.2 0.4 0.3]; the white color is
  aligned with the mean of caxis1 and caxis2 -3 on the colorbar since no
  Wvalue is specifice with 'full' option; h returns the colorbar handle
  and cmap returns the 59 X 3 colormap array generated.

cmap = colorbarpwn(-2, 2, 'log', -1, 'rev', 'off'):

  returns a 255 X 3 colormap array to cmap whlie disables displaying the
  colorbar; the colormap is with a reversed defualt color spectrum and
  the white color region is enlarged by a loginess of -1.
  
=========================================================================

version 1.4.0

  - Added support for reversed colorbar direction by switching cmin and
    cmax order, so the input limits became colorbarpwn(caxis1, caxis2).
    E.g., colorbarpwn(2, -1) displays a -1 to 2 colorbar in reversed
    direction, which is equivalent to cb.Direction = 'rev'.
  - Removal of the caxix1 < caxis2 rule accordingly.
  - Fixed a bug that causes an error when using 0 or 1 as the first caxis
    limit, i.e., colorbarpwn(0, caxis2) or colorbarpwn(1, caixs2).
  - Updates in headline description and examples.

Xiaowei He

05/23/2022

-------------------------------------------------------------------------

version 1.3.0

  - Added support for setting colormap and displaying colorbar on
    specific target, e.g., colorbarpwn(ax, cmin, cmax).
  - Updates and corrections in headline description and examples.

Xiaowei He

05/07/2022

-------------------------------------------------------------------------
version 1.2.0

  - Changed the function name from >>colorbarPWN to >>colorbarpwn for
    friendlier user experience.
  - Added an option 'off' which disables creatting the colorbar and only
    returns the colormap array.
  - Updates in headline description including a few examples.

Xiaowei He

04/27/2022

-------------------------------------------------------------------------

version 1.1.1

  - Minor code improvement.
  - Updates in headline descriptions.

Xiaowei He

04/21/2022

-------------------------------------------------------------------------

version 1.1.0

  - Added an output argument for the colormap array.
  - Added an input argument 'rev' for reversed default Positive and
    Negative colors, where Positive is in blue and Negative is in red.
  - Improved some logical structures.
  - Updated some descriptions in the headlines.

Xiaowei He

04/15/2022

-------------------------------------------------------------------------

version 1.0.1

  - Fixed a bug when output coloarbar handle.

Xiaowei He

04/07/2022

-------------------------------------------------------------------------

version 1.0.0

Xiaowei He

03/30/2022

=========================================================================

citation [1]

Connor Ott (2017). Non-linearly Spaced Vector Generator

https://www.mathworks.com/matlabcentral/fileexchange/64831-non-linearly-spaced-vector-generator,

MATLAB Central File Exchange.

function nonLinVec = nonLinspace(mn, mx, num)
    loginess = 1.5; % Increasing loginess will decreasing the spacing towards
    
                    % the end of the vector and increase it towards the beginning.
                    
    nonLinVec = (mx - mn)/loginess*log10((linspace(0, 10^(loginess) - 1, num)+ 1)) + mn;    
end

=========================================================================
