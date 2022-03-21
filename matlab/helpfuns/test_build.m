gcc_compiler = 'g++';
gcc_string = ['GCC=''', gcc_compiler, ''' ', 'CXXFLAGS=''', '-std=c++11 -fPIC', ''' '];


include{1} = fullfile(osvos_root, 'src', 'misc');  % To get matlab_multiarray.hpp
if (strcmp(computer(),'PCWIN64') || strcmp(computer(),'PCWIN32'))
    include{2} = 'C:\Program Files\boost_1_55_0';  % Boost libraries (change it if necessary)
else
    include{2} = '/opt/local/include/';  % Boost libraries (change it if necessary)
end
include{3} = fullfile(osvos_root, 'src', 'external','piotr_toolbox'); % To build Piotr toolbox
include{4} = fullfile(osvos_root, 'src', 'external'); % To build Piotr toolbox

include_str = '';
for ii=1:length(include)
    include_str = [include_str ' -I''' include{ii} '''']; %#ok<AGROW>
end

build_file = 'mexFeatureDistance.cpp';
eval(['mex ' gcc_string '''' build_file ''' -outdir ''' fullfile(osvos_root, 'lib') '''' include_str])