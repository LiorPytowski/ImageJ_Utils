input = getDirectory("Choose input folder");
//#@ File (label="Input Folder", Style="Directory") input
//#@ File (label="Output Folder", Style="Directory") output
//#@ String (label="Type", choices={"Grid:row-by-row","Grid:column-by-column","Grid:snake by rows","Grid: snake by columns","Filename defined position","Unknown position","Positions from file","Sequential Images"}, value="Sequential Images") ChosenType
//#@ String (label="Order", choices={"All files in directory", "Defined  by image metadata","Defined by TileConfiguration","Left & Down","Right & Down","Right & Up","Left & Up"}, value="All files in directory") Order

filelist = getFileList(input) 

File.makeDirectory(input + "/temporary_folder_can_be_deleted");
temp_folder = input + "/temporary_folder_can_be_deleted";

setBatchMode(true);
for (i = 0; i < lengthOf(filelist); i++) {
        open(input + File.separator + filelist[i]);      
        title = File.nameWithoutExtension;    
        makeRectangle(52, 0, 644, 520);
		run("Crop");
		saveAs("Tiff", input + "/temporary_folder_can_be_deleted/" + title + ".tif");
		run("Close All");
}

setBatchMode(false);
run("Grid/Collection stitching", 
		"type=[Sequential Images] "+
		"order=[All files in directory] "+
		"directory=&temp_folder "+
		"output_textfile_name=ouput.txt "+
		"fusion_method=[Linear Blending] "+
		"regression_threshold=0.30 "+
		"max/avg_displacement_threshold=2.50 "+
		"absolute_displacement_threshold=3.50 "+
		"frame=1 "+
		"computation_parameters=[Save memory (but be slower)] "+
		"image_output=[Fuse and display]");
		
saveAs("Tiff", input + "/Stitched.tif");
