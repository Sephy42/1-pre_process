%

if exist(['data_out/registered_OES/'],'dir') ~= 7
	mkdir(['data_out/registered_OES/']);
end
if exist(['data_out/registered_EDJ/'],'dir') ~= 7
	mkdir(['data_out/registered_EDJ/']);
end

pre_process(['data_in/EDJ/'], ['data_in/OES/'], ['data_in/LM_on_EDJ/'], ['data_in/HS.vtk'], 0.58, ['data_out/'], ['data_out/registered_EDJ/'], ['data_out/registered_OES/']);
