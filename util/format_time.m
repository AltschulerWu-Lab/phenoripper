function td=format_time(seconds)
% FORMAT_TIME format time in seconds to hours/minutes/seconds
%   TD=FORMAT_TIME(SECONDS) converts the time in seconds to a string which
%   specified the same time in hours, mingutes and seconds.
% ------------------------------------------------------------------------------
% Copyright ??2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.PhenoRipper.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%


hours=floor(seconds/3600);
min=floor(rem(seconds,3600)/60);
secs=round(rem(rem(seconds,3600),60));
td='';
if(hours>0)
   td=[num2str(hours) 'hours:'];
  
end

if(min>0)
   td=[td num2str(min) 'min:'];
  
end
td=[td num2str(secs) 'sec'];

end
