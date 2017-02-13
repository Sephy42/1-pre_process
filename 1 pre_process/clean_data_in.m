%
clear

path_in = ['data_in/EDJ/'];
edj = dir(path_in)

for k=3:size(edj,1) 
	delete(fullfile(path_in, edj(k).name));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path_in = ['data_in/OES/'];
oes = dir(path_in)

for k=3:size(oes,1) 
	delete(fullfile(path_in, oes(k).name));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path_in = ['data_in/LM_on_EDJ/'];
lm = dir(path_in)

for k=3:size(lm,1) 
	delete(fullfile(path_in, lm(k).name));
end

