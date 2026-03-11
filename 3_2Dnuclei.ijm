// Batch Top Hat filter for all images in subfolders
// Applies Top Hat (radius = 30) and saves with "_tophat" suffix

radius = 30; // set radius in pixels

// Choose the root folder
inputDir = getDirectory("Choose the ROOT folder containing images:");
print("Processing root folder: " + inputDir);

setBatchMode(true);
processFolder(inputDir);
setBatchMode(false);
print("DONE.");

function processFolder(dir) {
    list = getFileList(dir);
    for (i = 0; i < list.length; i++) {
        path = dir + list[i];
        if (File.isDirectory(path)) {
            // Recursively process subfolders
            processFolder(path);
        } else if (endsWith(path, ".tif") || endsWith(path, ".tiff")) {
            processPmap(path);
        }
    }
}

function processPmap(path) {
	
	if (path.contains("_probabilities.tif")) {
			
	    print("Processing: " + path);
	    open(path);
	    title = getTitle();


		// SEGMENT PROBABILITY MAP
		
		// Smooth probability map: Gaussian blur
		run("Gaussian Blur...", "sigma=1");

		// Threshold cell probability
		setThreshold(128, 255, "raw");
		setOption("BlackBackground", true);
		run("Convert to Mask");

		// Remove noise: Meadin
		run("Median...", "radius=1");

		// COMPUTE AREA
		height = getHeight();
		width = getWidth();
		makeRectangle(0, 0, width, height);
		run("Measure");
		max = getResult("Max", 0);
		Table.reset("Results"); // reset so that area row idx = 0 always
		if (max >= 128) {
			run("Analyze Regions", "pixel_count");
			area = getResult("PixelCount", 0);
			
			// Close the MLJ window
			idx = lastIndexOf(path, "/");
			ss = substring(path, idx+1);
			tableArea = substring(ss, 0, lengthOf(ss)-4) + "-Morphometry";
			selectWindow(tableArea);
			run("Close");
		}
		else {
			area = 0;
		}	
		print("area:", area);

		// SAVE TO FILE
		output_path = inputDir + "quantification_probabilities.csv";
		print(output_path);

		idx = indexOf(path, "2025-12-18");
		opath = substring(path, idx);

		data = opath + "," + area;
		if (File.exists(output_path)) {
		    File.append(data, output_path);
		} else {
		    header = "image,area\n";
		    File.saveString(header + data + "\n", output_path);
		}
		close();
	}
}

