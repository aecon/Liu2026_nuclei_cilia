// CHANGE INPUT DIRECTORY:
base_directory= "/media/user/SSD2/Tingting/LIUTI/5B2 quantification/5B2_quanification/";

subdirectory = "RML6 HPI-4";
//subdirectory = "RML6 SB258585";
//subdirectory = "RML6 DMSO";
//subdirectory = "RML6 Centrinone B";

subsubdirectory = "channel 3/probabilities/"

input_directory = base_directory + subdirectory + "/" + subsubdirectory;

files = getFileList(input_directory);

Nfiles = files.length;
print("Number of files:", Nfiles);


setBatchMode(true);
for(i=0; i<Nfiles; i++){

	if (files[i].contains("Probabilities")) {

		open(input_directory + files[i]);
		Nz = nSlices;
		Ny = getHeight();
		Nx = getWidth();
		totalVolume = Nz*Ny*Nx;
		title = getTitle();
		
		print(i, files[i], Nz, totalVolume);
		
		// Threshold probability map
		setThreshold(0.5, 1000000000000000000000000000000.0000);
		setOption("BlackBackground", true);
		run("Convert to Mask", "background=Dark black");
		
		// COMPUTE VOLUME OF MASK
		run("Analyze Regions 3D", "voxel_count volume surface_area_method=[Crofton (13 dirs.)] euler_connectivity=6");
		mask_volume = getResult("VoxelCount", 0);
		percentage = mask_volume/totalVolume*100.;
		print(mask_volume, totalVolume, percentage);

		// Save results in a csv file
		output_path = base_directory + "quantification_" + subdirectory + ".csv";
		print(output_path);
		data = title + "," + mask_volume + "," + totalVolume + "," + percentage;
		if (File.exists(output_path)) {
		    File.append(data, output_path);
		} else {
		    header = "image,mask_volume,totalVolume,percentage\n";
		    File.saveString(header + data + "\n", output_path);
		}

		close();
	}
}

print("DONE.");
setBatchMode(false);
exit;
