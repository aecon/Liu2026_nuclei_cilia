// CHANGE INPUT DIRECTORY:
base_directory= "/media/user/SSD2/Tingting/re-analysis for cell counting in COCS/2024-11-11 analysis for imaging data in  COCS batch  2024-02-25 SB258585 Arl13b/";

//subdirectory = "NBH CentrinoneB";
//subdirectory = "NBH DMSO";
//subdirectory = "NBH HPI-4";
//subdirectory = "RML6 CentrinoneB";
//subdirectory = "RML6 DMSO";
//subdirectory = "RML6 HPI-4";
//subdirectory = "NBH SB258585";
subdirectory = "RML6 SB258585";



input_directory = base_directory + subdirectory + "/";

files = getFileList(input_directory);

Nfiles = files.length;
print("Number of files:", Nfiles);

setBatchMode(true);
for(i=0; i<Nfiles; i++){

	if (files[i].contains("_Probabilities.tiff")) {
		print(i, files[i]);

		open(input_directory + files[i]);
		Nz = nSlices;
		print(Nz);
		title = getTitle();

		// Remove background probability channel
		run("Slice Remover", "first=2 last="+Nz+" increment=2");


		/*
		 * SEGMENT PROBABILITY MAP
		 */
		// Smooth probability map: Gaussian blur
		run("Gaussian Blur 3D...", "x=2 y=2 z=2");

		// Threshold cell probability
		setThreshold(0.5, 1000000000000000000000000000000.0000);
		setOption("BlackBackground", true);
		run("Convert to Mask", "background=Dark black");

		// Remove noise: Meadin
		run("Median 3D...", "x=1 y=1 z=1");

		// Save segmentation of probability map
		output_path = substring(files[i], 0, lengthOf(files[i])-5) + "_segmentation.tif";
		saveAs("Tiff", input_directory + output_path);
		
		// COMPUTE VOLUME OF MASK
		run("Analyze Regions 3D", "voxel_count volume surface_area_method=[Crofton (13 dirs.)] euler_connectivity=6");
		mask_volume = getResult("VoxelCount", 0);		
		print(mask_volume);		
		
		output_path = base_directory + "quantification_" + subdirectory + ".csv";
		print(output_path);
		data = title + "," + mask_volume;
		if (File.exists(output_path)) {
		    File.append(data, output_path);
		} else {
		    header = "image,mask_volume\n";
		    File.saveString(header + data + "\n", output_path);
		}
		
		close("*");
	}
}

print("DONE.");
setBatchMode(false);
exit;
