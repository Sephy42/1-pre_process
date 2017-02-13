clear

path_in = ['data_out/'];
file = dir(path_in);

for k=3:size(file,1) 

	if isdir(fullfile(path_in, file(k).name))
		rmdir(fullfile(path_in, [file(k).name '/']),'s');
	else
		delete(fullfile(path_in, file(k).name));
	end
end
