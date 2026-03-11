// Batch Top Hat filter for all images in subfolders
// Applies Top Hat (radius = 30) and saves with "_tophat" suffix

radius = 30; // set radius in pixels

// Choose the root folder
inputDir = getDirectory("Choose the input directory");
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
            processImage(path);
        }
    }
}

function processImage(path) {
    print("Processing: " + path);
    open(path);
    run("Top Hat...", "radius=" + radius + " stack");
    
    // Build save path with suffix
    dot = lastIndexOf(path, ".");
    if (dot == -1) dot = lengthOf(path);
    savePath = substring(path, 0, dot) + "_tophat" + substring(path, dot);
    
    saveAs("Tiff", savePath);
    close();
}

