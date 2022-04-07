function rmsandbox()
%rmsandbox  Uninstall sandbox
%
%  See also: rmsandbox, 
%            modify_sandbox_path
%
%  Copyright 2016 The MathWorks, Inc.
%
% Edits Christopher Szczyglowski, University of Bristol 2020
%   - Refactored most of the code into 'modify_sandbox_path'
% Edits Fintan Healy, University of Bristol 2022
%   - Refactored to use settings so sandboxes aren't loaded multiple times

name = 'wt_control';
s = settings;
[calling_dir,~,~] = fileparts(mfilename('fullpath'));
if hasGroup(s,"InstalledSandboxes")
    if hasGroup(s.InstalledSandboxes,name)
        installed_dir = s.InstalledSandboxes.(name).dir.ActiveValue;
        if installed_dir ~= calling_dir
            warning("Package %s is not at the location %s \n so installation will be skipped.\n Itr is installed at @ %s",...
                name,calling_dir,installed_dir);
            return
        end
    else
        removeGroup(s.InstalledSandboxes,name);
    end
end

sub_directory_to_remove = ["tbx" ; "examples"];

modify_sandbox_path(sub_directory_to_remove, 'remove');

end