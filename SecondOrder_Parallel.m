function SecondOrder_Parallel(GlobalData_file,InputStructure_file,OutputStructure_file)

GD=load(GlobalData_file);
global_data=GD.global_data;
InputStructure=load(InputStructure_file);
number_of_conditions=length(InputStructure);
OutputStructure=struct;
for i=1:number_of_conditions
   filenames=InputStructure(i).files_in_group; 
   results=SecondOrder(filenames,global_data);
   OutputStructure(i)=InputStructure(i);
   OutputStructure(i).block_profile=results.block_profile;
   OutputStructure(i).superblock_profile=results.superblock_profile;
end
save(OutputStructure_file,OutputStructure);