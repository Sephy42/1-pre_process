function pre_process(path_in_EDJ, path_in_OES, path_in_LM, HS_filename, ratio, path_out, path_out_EDJ, path_out_OES)

% Usage : pre_process(path_in_EDJ, path_in_OES, path_in_LM, HS_filename, ratio, path_out, path_out_EDJ, path_out_OES)
% param : 
% 		path_in_EDJ : string => directory that contains all the dentine surfaces, all named id_EDJ.vtk
%		path_in_OES : string => directory that contains all the enamel surfaces, all named id_OES.vtk
%		path_in_LM : string => directory that contains all the landmarks, all named id_landmarks.vtk
%		HS_filename : string => name of the hemisphere surface.
%		ratio : float [0 , 1] => determines where the landmarks will be placed on the hemisphere. 0 means all points will be mingled on the top of the hemisphere and 1 means all points will be as far as possible from each other
%		path_out : string => directory where hemisphere centered surface and Landmarks on the hemisphere will be, with the names "HS.vtk" and "HS_LM.vtk"			
%		path_out_EDJ : directory where dentine surfaces with distances data and landmarks on dentine will be, with the names "id_EDJ_distances.vtk". and "id_EDJ_LM.vtk".
%		path_out_OES : directory where enamel surfaces with distances data and landmarks on enamel will be, with the names "id_OES_distances.vtk". and "id_OES_LM.vtk".
%
% All the paths can be the same.

% 2016 Margot Cantaloube


projectpath = genpath(pwd);
addpath(projectpath);


%%%%%%%%%%%%%%%%%%%% paths preparation %%%%%%%%%%%%%%%%%%%%%%%

trash = [ 'trash/'];

edj = dir([path_in_EDJ '*_EDJ.vtk']);
oes = dir([path_in_OES '*_OES.vtk']);
lm_edj = dir([path_in_LM '*_landmarks.vtk']);


%%%%%%%%%%%%%%%%%%%%% data preparation %%%%%%%%%%%%%%%%%%%%%%%


for k=1:size(edj,1) 
	
	[V_edj{k}, T_edj{k}] = read_vtk([path_in_EDJ edj(k).name]);		
	[V_oes{k}, T_oes{k}] = read_vtk([path_in_OES oes(k).name]);	
	
	[V_lm_edj{k}] = read_vtk([path_in_LM lm_edj(k).name]);	
	
end

[V_HS, T_HS] = read_vtk(HS_filename);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% distance enamel to dentine computation  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf( 'Step 1 on 5 : computation of the distance enamel to dentine\n' );

for k=1:size(edj,1) 
	[garbage1 garbage2 dist_OES{k}] = closestPoint([path_in_EDJ edj(k).name], [path_in_OES oes(k).name]);
%	Write_vtk_surface(V_oes{k}', T_oes{k}', [], dist_OES{k}, [], fullfile(trash, strrep(oes(k).name, 'OES', 'OES_distance')));  
	fprintf( '\t Species %d on %d \n', k,size(edj,1)  );		
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% projection of the landmarks on the enamel %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf( 'Step 2 on 5 : projection of the landmarks on the enamel\n' );	
	
		
for k=1:size(edj,1)

	[V_lm{k}, dist_EDJ{k}] = project_landmarks_on_OES_and_compute_distance_to_CervixPlane(V_edj{k}, T_edj{k}, V_oes{k}, V_lm_edj{k});
%	V_lm{k} = project_landmarks_on_OES(V_oes{k}, V_lm_edj{k}); 
%	Write_vtk_point(V_lm{k}',[],fullfile(trash, strrep(oes(k).name,'OES','OES_lm.vtk')),[1:size(V_lm{k},2)]);
%	Write_vtk_surface(V_edj{k}', T_edj{k}', [], dist_EDJ{k}, [], fullfile(trash, strrep(edj(k).name, 'EDJ', 'EDJ_distance')));
	fprintf( '\t Species %d on %d \n', k,size(edj,1)  );	
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% projection of the landmarks on the hemisphere %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf( 'Step 3 on 5 : projection of the landmarks on the hemisphere\n' );
	
% pose of symetric landmarks on the hemisphere
V_lm_HS = prepare_landmarks_on_hemisphere(ratio, V_HS);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% rigid registration of all on the hemisphere %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf( 'Step 4 on 5 : rigid registration on the hemisphere\n' );

for k=1:size(oes,1)

	%%%%%%%%%%% Enamel %%%%%%%%%%%
	
	% computation of the registration
	[R, s, ty, tx, new_V_lm_HS, new_V_lm{k}] = rigid(V_lm_HS, V_lm{k});
	
	% application on the enamel surface
	V_oes_registered{k} = s * (R * (V_oes{k} + repmat(ty',1,size(V_oes{k},2)) ));
	
	Write_vtk_point(new_V_lm{k}',[],fullfile(path_out_OES, strrep(oes(k).name,'OES',['OES_lm' int2str(size(new_V_lm{k},2)) '_registered'])),[1:size(new_V_lm{k},2)]);	
	Write_vtk_surface(V_oes_registered{k}', T_oes{k}', [], dist_OES{k}, [], fullfile(path_out_OES, strrep(oes(k).name, 'OES', 'OES_distance_registered'))); 
	
	
	%%%%%%%%%%% Dentine %%%%%%%%%%%

	% computation of the registration
	[R, s, ty, tx, new_V_lm_HS, new_V_lm_edj{k}] = rigid(V_lm_HS, V_lm_edj{k});

	% application on the enamel surface
	V_edj_registered{k} = s * (R * (V_edj{k} + repmat(ty',1,size(V_edj{k},2)) ));

	Write_vtk_point(new_V_lm_edj{k}',[],fullfile(path_out_EDJ, strrep(edj(k).name,'EDJ',['EDJ_lm' int2str(size(new_V_lm_edj{k},2)) '_registered'])),[1:size(new_V_lm_edj{k},2)]);	
	Write_vtk_surface(V_edj_registered{k}', T_edj{k}', [], dist_EDJ{k}, [], fullfile(path_out_EDJ, strrep(edj(k).name, 'EDJ', 'EDJ_distance_registered'))); 


	fprintf( '\t Species %d on %d \n', k,size(oes,1)  );
	
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% centering of the hemisphere and landmarks on it %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf( 'Step 5 on 5 : centering of the hemisphere\n' );

% centering of the hemisphere's landmarks
Write_vtk_point(new_V_lm_HS',[],fullfile(path_out, 'lm_HS_5.vtk'),[1:size(new_V_lm_HS,2)]);
Write_vtk_point(new_V_lm_HS(:,1:size(new_V_lm_HS,2)-1)',[],fullfile(path_out, 'lm_HS_4.vtk'),[1:size(new_V_lm_HS,2)-1]);

% centering of the hemisphere following the translation done on the hemisphere landmarks
V_HS = V_HS + repmat(tx', 1, size(V_HS, 2));
Write_vtk_surface(V_HS', T_HS', [], ones(1,size(V_HS,2)), [], fullfile(path_out,'centered_HS.vtk')); 

end
















