# Image analysis

Scripts for the image analysis of the paper: xxx


## How to download this repository

Download the repository and the `.ilp` files with Git:
1. Open a **terminal**.
2. Go to the folder where you want to save the repository.
3. Clone the repository:

```bash
git clone https://github.com/aecon/Liu2026_nuclei_cilia.git
cd Liu2026_nuclei_cilia
git lfs pull
```
After this, the .ilp files should appear inside the `ilastik/` folder.


## Requirements

### ilastik
Download [ilastik](https://www.ilastik.org/download).  
This project uses ilastik version `Release 1.4.1.post1 (31. May 2025)`.

### Fiji
Download [Fiji](https://imagej.net/software/fiji/downloads).


## Workflow

### 1. Pre-processing

1. Open **Fiji**.
2. Drag and drop the `1_preprocess.ijm` file onto the **Fiji** window. The macro will open in the script/macro editor.
3. Click **Run**, then select the root input directory when the dialog appears.

The processed images will be saved in the same folders as the originals, with suffix `_tophat.tif`.


### 2. Generation of probability maps

1. Open the folder containing this directory in your file browser.
2. Open a terminal **in this folder**:
   - on Linux, this is usually done by **right-clicking inside the folder** and choosing **"Open in Terminal"**
3. Find the full paths to:
   - the ilastik launcher file: `run_ilastik.sh`
   - the ilastik project file: eg. `ilastik/2D_classifier.ilp`
   - the main folder containing your images
4. Run this command in the terminal:
```bash
ILASTIK=/full/path/to/run_ilastik.sh PROJECT=/full/path/to/project.ilp 2_run_ilastik.sh /full/path/to/image_folder
```
5. Press Enter

This runs `ilastik` on files that do not yet have a matching `_probabilities.tif`,
and creates a zip file called `probabilities.zip` in the main image folder that contains
all probability maps.


### 3. Generation of probability maps

Depending on the input data, use wither of the three ImageJ macros (similar usage as step 1. Pre-processing) to perform quantification.
```
3_postprocess_2D.ijm
3_postprocess_3D.ijm
```

